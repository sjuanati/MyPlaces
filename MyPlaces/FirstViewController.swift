//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit

// Controller de la Llista
class FirstViewController: UITableViewController, ManagerPlacesObserver {
  
    func onPlacesChange() {
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }

    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    let m_location_manager:ManagerLocation = ManagerLocation.shared()
    
    override func viewDidLoad() {

        super.viewDidLoad()
       
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
        
        // Add self observer
        let manager = ManagerPlaces.shared()
        manager.addObserver(object:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // *************** Protocol Table ***************
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Number of elements in Places
        return m_provider.GetCount()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    // Number of sub-sections in tableView
        return 1;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Detect click on one Place within the tableview
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        let place: Place = self.m_provider.GetItemAt(position: indexPath.row)
        dc.place = place
        present(dc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // Height of a row at a given position
        return 80;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instance of class UITableViewCell to fulfill the selected row

        var cell: UITableViewCell
        cell = UITableViewCell()
        let wt: CGFloat = tableView.bounds.size.width
        
        // Add place name
        var label: UILabel
        label = UILabel(frame: CGRect(x:10,y:10,width:wt,height:40))
        let font: UIFont = UIFont(name: "Arial", size: 18)!
        label.font = font
        label.text = m_provider.GetItemAt(position: indexPath.row).name
        label.sizeToFit()
        cell.contentView.addSubview(label)
        
        // Add place icon
        let imageIcon: UIImageView = UIImageView(image: UIImage(named:"placeholder.png"))
        imageIcon.frame = CGRect(x:10, y:35, width:25, height:25)
        cell.contentView.addSubview(imageIcon)
        
        return cell;
    }
    
}

