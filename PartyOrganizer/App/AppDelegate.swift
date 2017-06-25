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
        
        let builder = DIContainerBuilder()
        builder.register(module: AppModule())
        let container = try! builder.build()
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        storyboard = try! container.resolve()
        window!.rootViewController = storyboard.instantiateInitialViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
   
}

