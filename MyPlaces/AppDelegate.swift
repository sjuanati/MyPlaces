//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Sergi Juanati on 20/9/18.
//  Copyright © 2018 Sergi Juanati. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let manager = ManagerPlaces.shared()

        print("*** Inici resultats PAC1")
        
        // Afegir Places
        
        /*
        manager.append(Place(name: "Barcelona", description: "Best City", image_in: nil))
        manager.append(Place(name: "Paris", description: "Worst City", image_in: nil))
        manager.append(Place(name: "London", description: "Average City", image_in: nil))
        manager.append(Place(name: "Amsterdam", description: "Cool City", image_in: nil))
        */
        
        manager.append(Place(type: .TouristicPlace, name: "Barcelona", description: "Best City", image_in: nil, location_in: nil))
        manager.append(Place(type: .GenericPlace, name: "Paris", description: "Worst City", image_in: nil, location_in: nil))
        manager.append(Place(type: .GenericPlace, name: "London", description: "Average City", image_in: nil, location_in: nil))
        manager.append(Place(type: .TouristicPlace, name: "Amsterdam", description: "Cool City", image_in: nil, location_in: nil))
        
 
        // Comptar el número de Places
        print("Número total d'elements: ", manager.GetCount())
        
        // Buscar un Place per posició (i guardar el seu ID)
        //let idProva  = manager.GetItemAt(position: 1).id

        // Eliminar un Place per ID
        //manager.remove(id: idProva)

        // Mostrar els Places
        for index in 0..<manager.GetCount() {
            print("Element \(index): Nom: ", manager.GetItemAt(position: index).name,
                  "Tipus: ", manager.GetItemAt(position: index).type,
                  " Desc: ", manager.GetItemAt(position: index).description,
                  " ID: ", manager.GetItemAt(position: index).id)
        }
        
        print("*** Fi de resultats PAC1")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

