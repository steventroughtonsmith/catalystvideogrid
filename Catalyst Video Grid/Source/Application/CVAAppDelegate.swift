//
//  CGAAppDelegate.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

@UIApplicationMain
class CVAAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		if options.userActivities.first?.activityType == "com.example.video.scene" {
			return UISceneConfiguration(name: "Video Scene", sessionRole: .windowApplication)
		}
		
		return UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)
	}
}
