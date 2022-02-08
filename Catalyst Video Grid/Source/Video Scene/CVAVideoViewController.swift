//
//  CVAVideoViewController.swift
//  Catalyst Video Grid
//
//  Created by Steven Troughton-Smith on 08/02/2022.
//

import UIKit
import AVKit

class CVAVideoViewController: UIViewController {
	let controller = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .black
		view.addSubview(controller.view)
				
		startPlayback()
    }
	
	func startPlayback() {
		guard let url = Bundle.url(forResource: "Big_Buck_Bunny_720_10s_5MB", withExtension: "mp4", subdirectory: nil, in: Bundle.main.resourceURL!) else { return }
		
		let player = AVPlayer(url: url)
		player.play()

		controller.player = player
	}
	
	// MARK: -
	
	override func viewDidLayoutSubviews() {
		controller.view.frame = view.bounds
	}
	
	// MARK: - Commands
	
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(dismiss(_:)))]
	}
	
	@objc func dismiss(_ sender:Any?) {
		navigationController?.popViewController(animated: true)
	}
}
