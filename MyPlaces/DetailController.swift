//
//  DetailController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    // S'assigna la propietat quan és consulta i no s'assigna quan és un nou element (+)
    var place:Place? = nil
    
    // Instància de tots els valors per poder eliminar el que hem seleccionat
    let m_provider:ManagerPlaces = ManagerPlaces.shared()

    @IBOutlet weak var selectType: UIPickerView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constraintHeight.constant = 400
        labelStatus.text = ""
        textName.text = place?.name
        textDescription.text = place?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    // Afegir element nou o actualitzar element existent (PLA2)
    /*
        if place == nil {
            if textName.text != nil {
                labelStatus.text = "Please insert a Name"
            } else if textDescription.text != nil {
                labelStatus.text = "Please insert a Description"
            } else {
                m_provider.append(Place(name: textName.text!, description: textDescription.text!, image_in: nil))
            }
        } else {
        }
    */
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
