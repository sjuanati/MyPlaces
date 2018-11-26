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
/*
        // PLA1 - Afegir Places d'exemple

        let manager = ManagerPlaces.shared()
        
        manager.append(Place(type: .TouristicPlace,
                        name: "Barcelona",
                        description: "Best City",
                        image_in: nil,
                        location_in: ManagerLocation.GetLocation()))
        manager.append(Place(type: .GenericPlace,
                        name: "Paris",
                        description: "Worst City",
                        image_in: nil,
                        location_in: ManagerLocation.GetLocation()))
        manager.append(Place(type: .GenericPlace,
                        name: "London",
                        description: "Average City",
                        image_in: nil,
                        location_in: ManagerLocation.GetLocation()))
        manager.append(Place(type: .TouristicPlace,
                        name: "Amsterdam",
                        description: "",
                        image_in: nil,
                        location_in: ManagerLocation.GetLocation()))
        manager.store()
 */
 
        // Change Navigation Bar colors
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.darkGray
        navigationBarAppearance.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 28)!]
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.barTintColor = UIColor.darkGray
        
        
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

