//
//  AppDelegate.swift
//  Memespeare
//
//  Created by James Orzechowski on 1/28/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import UIKit
import RealmSwift


let uiRealm = try! Realm()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let loadPlayTextController = LoadPlayTextController()
        loadPlayTextController.populateSomeLines()
        
        
        return true
    }








}

