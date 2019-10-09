//
//  SceneDelegate.swift
//  BlunoTest
//
//  Created by Avario Babushka on 23/09/19.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = scene as? UIWindowScene else {
			return
		}
		
		let contentView = StatusScreen(data: StatusScreenData())
			.environmentObject(BlunoService())
		
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = UIHostingController(rootView: contentView)
		self.window = window
		window.makeKeyAndVisible()
	}
	
}

