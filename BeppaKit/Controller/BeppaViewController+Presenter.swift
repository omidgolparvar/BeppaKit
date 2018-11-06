//
//  BeppaViewController+Presenter.swift
//  BeppaKit
//
//  Created by Omid Golparvar on 11/5/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

extension BeppaViewController {
	
	public static func Present(from sourceController: UIViewController,
							   delegate: BeppaValidationProtocol,
							   animated: Bool = true,
							   completion: (() -> Void)? = nil) {
		
		let bundle = Bundle(for: BeppaViewController.self)
		let storyboard = UIStoryboard(name: "Main", bundle: bundle)
		let controller = storyboard.instantiateViewController(withIdentifier: "BeppaViewController") as! BeppaViewController
		controller.delegate = delegate
		controller.modalTransitionStyle = .crossDissolve
		controller.modalPresentationStyle = .overFullScreen
		sourceController.present(controller, animated: animated, completion: completion)
	}
	
}
