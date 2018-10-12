//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    
    override func viewDidLoad() {
        //TODO: comprovar que la propietat place no és null
        super.viewDidLoad()
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // **** Implementació del protocol Table *****
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Número d'elements guardats a Places
        return m_provider.GetCount()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    // Indicar sub-seccions de la llista. Retornarem 1 pq no hi ha sub-seccions.
        return 1;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Detectar pulsació en un element.
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        let place: Place = self.m_provider.GetItemAt(position: indexPath.row)
        dc.place = place
        present(dc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // Retornar l'altura de la fila situada en una posició determinada.
        return 80;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retornar una instància de la classe UITableViewCell que pinti la fila seleccionada.

        var cell: UITableViewCell
        cell = UITableViewCell()
        let wt: CGFloat = tableView.bounds.size.width
        
        // Afegir nom de l'element a la cel·la
        var label: UILabel
        label = UILabel(frame: CGRect(x:10,y:10,width:wt,height:40))
        let font: UIFont = UIFont(name: "Arial", size: 18)!
        label.font = font
        //label.numberOfLines = 4
        label.text = m_provider.GetItemAt(position: indexPath.row).name
        label.sizeToFit()
        cell.contentView.addSubview(label)
        
        // Afegir icones a l'element de la cel·la
        let imageIcon: UIImageView = UIImageView(image: UIImage(named:"placeholder.png"))
        imageIcon.frame = CGRect(x:10, y:35, width:25, height:25)
        cell.contentView.addSubview(imageIcon)
        
        return cell;
    }
    
    func refresh(){
        self.tableView.reloadData()
    }
}

