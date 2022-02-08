//
//  CVAVideoSceneDelegate.swift
//  Catalyst Video Grid
//
//  Created by Steven Troughton-Smith on 08/02/2022.
//

import UIKit

class CVAVideoSceneDelegate: NSObject, UIWindowSceneDelegate {
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
		
		guard let window = window, let windowScene = window.windowScene else { return }
		
		let mainVC = CVAVideoViewController()
		
		window.rootViewController = mainVC
		
#if targetEnvironment(macCatalyst)
		windowScene.titlebar?.titleVisibility = .hidden
		windowScene.titlebar?.toolbarStyle = .unifiedCompact
#endif
	}
}
