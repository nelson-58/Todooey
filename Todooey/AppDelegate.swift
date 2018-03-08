//
//  AppDelegate.swift
//  Todooey
//
//  Created by Andy Harris on 04/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    
        
        do{
            //initialise a new Realm environment
            _ = try Realm()
        }
        catch {
            print ("Problem initialising new realm \(error)")
        }
        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        
        print("App will terminate")
    }


    
    // MARK: - Core Data Saving support


}

