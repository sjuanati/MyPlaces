//
//  DetailController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit


class DetailController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // Places & Location instances
    var place:Place? = nil
    var pl:ManagerLocation? = nil
    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    let m_location_manager:ManagerLocation = ManagerLocation.shared()
    
    // scrollView properties
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    
    // viewPicker values
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
            
            // PLA1 - OK quan NO es llegia des de fitxer
            /*
            if place?.image != nil {
                imagePicked.image = UIImage(data: (place?.image)!)
            } */
            
            let pathImage = m_provider.GetPathImage(p: place!)
            do {
                let imageData = try Data(contentsOf: URL(fileURLWithPath: pathImage))
                imagePicked.image = UIImage(data: imageData)
            } catch {
                // TODO: Error handling
            }
        } else {
            btnUpdate.setTitle("New", for: .normal)
        }

        // Soft keyboard Control
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(hideKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(showKeyboard),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
    // Select image from library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func Close(_ sender: Any) {
    // Go back (to FirstViewController)
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func Remove(_ sender: UIButton) {
    // Remove element from list, except when creating a new element
        if place != nil {
            m_provider.remove(id: place!.id)
            m_provider.store()
            
            let manager = ManagerPlaces.shared()
            manager.UpdateObservers()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Update(_ sender: UIButton) {
    // Add new element or update existing one
        if textName.text != "" {
            let selPicker = viewPicker.selectedRow(inComponent: 0)
            var data:Data? = nil
            
            if imagePicked.image != nil {
                data = imagePicked.image!.jpegData(compressionQuality: 1.0)
            }
        
            //Check repeated Name (either New or Update)
            if m_provider.checkRepeated(nameRepe: textName.text!) == true, place == nil || place?.name != textName.text! {
                let alert = UIAlertController(title: "Alert",
                                              message: "Place <" + textName.text! + "> already exists.",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
            if place != nil {
                //Update element
                m_provider.update(id: place!.id,
                                  name: textName.text!,
                                  description: textDescription.text!,
                                  image_in: data,
                                  location_in: m_location_manager.GetLocation())
            } else {
                //New element
                switch (pickerElems1[viewPicker.selectedRow(inComponent: 0)]) {
                case "Touristic place":
                    m_provider.append(PlaceTourist(name: textName.text!,
                                                    description: textDescription.text!,
                                                    discount_tourist: "10?", //TODO PLA3
                                                    image_in: data,
                                                    location_in: m_location_manager.GetLocation()))
                    default:
                    m_provider.append(Place(type: Place.PlacesTypes.init(rawValue: selPicker)!,
                                            name: textName.text!,
                                            description: textDescription.text!,
                                            image_in: data,
                                            location_in: m_location_manager.GetLocation()))
                    }
                }
                
                // Update Observer
                let manager = ManagerPlaces.shared()
                manager.UpdateObservers()
                
                // Save list into file
                m_provider.store()
                
                dismiss(animated: true, completion: nil)
            }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        view.endEditing(true)
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
            imagePicked.contentMode = .scaleAspectFit
            imagePicked.image = image
            dismiss(animated:true, completion: nil)
    }
 
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    // *************************************************************
    
    // Determine which UITextView is to be edited
    
    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }

    @objc func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if (activeField==textView) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }

    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }

    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (activeField == textField) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    // *************************************************************
    
    // UIScrollView is repositioned when showing the keyboard
    
    
    @objc func showKeyboard(notification: Notification) {
        if (activeField != nil) {
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
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
    
    // Hide keyboard when clicking out of UITextView:

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
  
    // UIScrollView is repositioned when closing the keyboard
    
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
