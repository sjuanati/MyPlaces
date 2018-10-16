//
//  DetailController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit


class DetailController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // S'assigna la propietat quan és consulta i no s'assigna quan és un nou element (+)
    var place:Place? = nil
    var pl:ManagerLocation? = nil
    
    // Propietats per al scrollView
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    // Instància de tots els valors per poder eliminar el que hem seleccionat
    let m_provider:ManagerPlaces = ManagerPlaces.shared()

    let pickerElems1 = ["Generic place", "Touristic place"]
    
    @IBOutlet weak var viewPicker: UIPickerView!
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var btnUpdate: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.constraintHeight.constant = 400
        textName.delegate = self
        textDescription.delegate = self
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        if place != nil {
            textName.text = place?.name
            textDescription.text = place?.description
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
        } else {
            btnUpdate.setTitle("New", for: .normal)
        }

        // Soft keyboard Control
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(hideKeyboard),
                                       name: Notification.Name.UIKeyboardWillHide,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(showKeyboard),
                                       name: Notification.Name.UIKeyboardWillShow,
                                       object: nil)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func Close(_ sender: Any) {
    // Tornar enrera (a FirstViewController)
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func Remove(_ sender: UIButton) {
    // Eliminar element de la llista, excepte quan estem creant un nou element
        if place != nil {
            m_provider.remove(id: place!.id)
            let tbc:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            present(tbc, animated: true, completion: nil)
        }
        //TODO: botó remove en gris quan estiguem afegint nou element
    }
    
    
    @IBAction func Update(_ sender: UIButton) {
    // Afegir element nou o actualitzar element existent

        if textName.text != "", textDescription.text != "" {
            let selPicker = viewPicker.selectedRow(inComponent: 0)
            var data:Data? = nil
            if imagePicked.image != nil {
                data = UIImageJPEGRepresentation(imagePicked.image!, 1.0)
            }
            if place != nil {
                //Update element
                m_provider.update(id: place!.id,
                                  name: textName.text!,
                                  description: textDescription.text!,
                                  image_in: data,
                                  location_in: ManagerLocation.GetLocation())
            } else {
                //New element
                print(ManagerLocation.GetLocation())
                m_provider.append(Place(type: Place.PlacesTypes.init(rawValue: selPicker)!,
                                        name: textName.text!,
                                        description: textDescription.text!,
                                        image_in: data,
                                        location_in: ManagerLocation.GetLocation()))
            }
            
            let tbc:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            present(tbc, animated: true, completion: nil)
            
        } else {
            print("Algun es null")
            //TODO: pop-up que ens informi que els camps són obligatoris
        }
        
    }
    
    // *************** Protocol UIPickerViewDelegate ***************
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    // Número de columnes
        return 1
    }
    
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    // Número de files
        return pickerElems1.count
    }
    
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    // Element a retornar per la fila i el component (columna) passats com a argument
        return pickerElems1[row]
    }
    
    // *************************************************************


    // ********** Protocol UIImagePickerControllerDelegate *********
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        view.endEditing(true)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imagePicked.contentMode = .scaleAspectFit
            imagePicked.image = image
            dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    // *************************************************************
    
    // Per saber quin UITextView volem editar:
    
    @objc func textViewShouldBeginEditing(_ textView: UITextView) {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
    }

    @objc func textViewShouldEndEditing(_ textView: UITextView) {
        if (activeField==textView) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
    }

    @objc func textFieldShouldBeginEditing(_ textField: UITextView) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }

    @objc func textFieldShouldEndEditing(_ textField: UITextView) {
        if (activeField == textField) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
    }
    
    // *************************************************************
    
    // Al mostrar el teclat reposicionem la UIScrollView
    
    
    @objc func showKeyboard(notification: Notification) {
        if (activeField != nil) {
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            keyboardHeight = keyboardViewEndFrame.size.height
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace > 0 {
                self.scrollView.setContentOffset(CGPoint(x: self.lastOffset.x, y: collapseSpace + 10), animated: false)
                self.constraintHeight.constant += self.keyboardHeight
            } else{
                keyboardHeight = nil }
            }
    }
    
    // Al pitjar fora del UITextView es tanca el teclat (Hide soft keyboard):

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
  
    // Al tancar-se el teclat reposicionem la UIScrollView:
    
    @objc func hideKeyboard(notification: Notification) {
        if(keyboardHeight != nil) {
            self.scrollView.contentOffset = CGPoint(x:self.lastOffset.x, y: self.lastOffset.y)
            self.constraintHeight.constant -= self.keyboardHeight
        }
        keyboardHeight = nil
    }
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    

}
