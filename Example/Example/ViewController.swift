//
//  ViewController.swift
//  Example
//
//  Created by Omid Golparvar on 11/5/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit
import BeppaKit

class ViewController: UIViewController {
	
	@IBOutlet weak var label_Message	: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func action_PresentController(_ sender: UIButton) {
		BeppaConfig.UserInterface.Controller.BackgroundType = .mix(backgroundColor: UIColor.blue.withAlphaComponent(0.5), visualEffectStyle: .light)
		BeppaConfig.UserInterface.Title.Font = UIFont(name: "Vazir-Bold", size: 16)!
		BeppaConfig.UserInterface.NumpadButton.Font = UIFont(name: "Vazir-Bold", size: 24)!
		BeppaConfig.UserInterface.Message.Font = UIFont(name: "Vazir-Medium", size: 12)!
		BeppaConfig.Controller.NumberOfDigits = 5
		BeppaConfig.Controller.HasActivityIndicator = true
		
		BeppaViewController.Present(from: self, delegate: self)
	}
	
}

extension ViewController: BeppaValidationProtocol {
	
	func beppaControllerDidValidatePasscode(wasSuccessful: Bool) {
		print("Success: \(wasSuccessful)")
	}
	
	
	func beppaController(validate passcode: String, completion: @escaping (BeppaValidationResult) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			if passcode == "12345" {
				completion(.isValid)
			} else {
				completion(.isInvalid(message: "این یک متن نمونه است که می‌تواند دارای بیشتر از یک خط باشد."))
			}
		}
	}
	
}

