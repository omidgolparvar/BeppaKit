//
//  BeppaValidationProtocol.swift
//  BeppaKit
//
//  Created by Omid Golparvar on 11/6/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

public protocol BeppaValidationProtocol: NSObjectProtocol {
	
	func beppaController(validate passcode: String, completion: @escaping (BeppaValidationResult) -> Void)
	
	func beppaControllerDidValidatePasscode(wasSuccessful: Bool)
	
}

public enum BeppaValidationResult {
	
	case isValid
	case isInvalid(message: String?)
	
}

