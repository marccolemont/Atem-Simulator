//
//  ViewController.swift
//  AtemSimulator
//
//  Created by Damiaan on 22/05/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import Cocoa
import Atem

class ViewController: NSViewController {
	
	@IBOutlet weak var onButton: NSButton!
	@IBOutlet weak var offButton: NSButton!
	
	var switcher: Switcher?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setSwitchOn()
		changePowerState(self)
	}

	@IBAction func changePowerState(_ sender: Any) {
		if onButton.state == .on {
			do {
				switcher = try Switcher()
			} catch {
				presentError(error)
				setSwitchOff()
			}
		} else {
			switcher?.channel.map{ $0.close(mode: .all) }.whenFailure { error in
				self.presentError(error)
				self.setSwitchOn()
			}
		}
	}
	
	func setSwitchOn() {
		onButton.state = .on
		offButton.state = .off
	}
	
	func setSwitchOff() {
		onButton.state = .off
		offButton.state = .on
	}
}

class WindowController: NSWindowController {
	
	var controller: Controller?
	override func windowDidLoad() {
		super.windowDidLoad()
		controller = try? Controller(ipAddress: "127.0.0.1")
			
		controller?.messageHandler.when{ (newState: PreviewBusChanged) in
			print(newState)
		}
	}

	@IBAction func moveLever(_ sender: NSSlider) {
		controller?.transition(to: UInt16(sender.intValue))
	}
}
