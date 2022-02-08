//
//  CGASceneDelegate.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

class CVASceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected scene of type UIWindowScene but got an unexpected type")
		}
		window = UIWindow(windowScene: windowScene)
		
		if let window = window {
			
			buildPrimaryUI()
			window.makeKeyAndVisible()
		}
	}
	
	// MARK: -
	
	func buildPrimaryUI() {
		
		guard let window = window else { return }

		let mainVC = CVAMainViewController()
		mainVC.sceneDelegate = self
		
		window.rootViewController = mainVC
		
#if targetEnvironment(macCatalyst)
		mainVC.navigationController?.isNavigationBarHidden = true
#endif
	}
	
}
