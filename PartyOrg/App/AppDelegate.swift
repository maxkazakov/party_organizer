//
//  AppDelegate.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 03/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData
import DITranquillity
import Fabric
import Crashlytics


extension UIApplication{
    
    var mainStoryboard: UIStoryboard?{
        return (self.delegate as? AppDelegate)?.storyboard
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard!
    var rootViewController: UIViewController!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        let container = DIContainer()
        container.append(framework: AppFramework.self)
        if !container.validate() {
            fatalError("Your write incorrect dependencies graph")
        }
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        storyboard = container.resolve()
        window!.rootViewController = storyboard.instantiateInitialViewController()
        window!.makeKeyAndVisible()
                       
        UINavigationBar.appearance().barTintColor = Colors.barAccent
        UINavigationBar.appearance().tintColor = Colors.barText
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Colors.barText]
        UINavigationBar.appearance().isTranslucent = false
        
        application.statusBarStyle = .lightContent
        
        return true
    }
   
}

