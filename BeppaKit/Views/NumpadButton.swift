//
//  NumpadButton.swift
//  BeppaKit
//
//  Created by Omid Golparvar on 11/5/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

class NumpadButton: UIButton {
	
	var defaultBackgroundColor	: UIColor? = nil
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = 38.0
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupActions()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupActions()
	}
	
	private func setupActions() {
		addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
		addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel])
	}
	
	@objc
	private func handleTouchDown() {
		backgroundColor = BeppaConfig.UserInterface.NumpadButton.HighlightBackgroundColor
	}
	
	@objc
	private func handleTouchUp() {
		UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
			self.backgroundColor = self.defaultBackgroundColor ?? BeppaConfig.UserInterface.NumpadButton.BackgroundColor
		})
	}
	
}
