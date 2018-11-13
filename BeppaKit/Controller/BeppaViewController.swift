//
//  BeppaViewController.swift
//  BeppaKit
//
//  Created by Omid Golparvar on 11/5/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit
import LocalAuthentication

public class BeppaViewController: UIViewController {
	
	@IBOutlet private weak var view_VisualEffect				: UIVisualEffectView!
	@IBOutlet private weak var view_NumpadHolder				: UIView!
	@IBOutlet private weak var label_Title						: UILabel!
	@IBOutlet private var buttons_Numbers						: [NumpadButton]!
	@IBOutlet private weak var button_Delete					: UIButton!
	@IBOutlet private weak var button_Biometric					: UIButton!
	@IBOutlet private weak var stackView_Codes					: UIStackView!
	@IBOutlet private weak var constraint_StackView_Codes_Width	: NSLayoutConstraint!
	@IBOutlet private weak var label_Message					: UILabel!
	
	private lazy var view_ActivityIndicator	: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
		activityIndicator.color = .black
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.alpha = 0.0
		activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
		activityIndicator.startAnimating()
		
		self.view.addSubview(activityIndicator)
		self.view.bringSubviewToFront(activityIndicator)
		return activityIndicator
	}()
	
	private var feedbackGenerator		= UINotificationFeedbackGenerator()
	private var hasBiometricHardware	: Bool		= true
	private var reasonForBiometricUsage	: String	= ""
	private var canEnterNumber			: Bool		= true
	private var enteredCode				: String	= ""
	
	weak var delegate			: BeppaValidationProtocol?
	
	override public func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animateNumpadButtonsOnAppear()
	}
	
	@IBAction private func action_NumbpadTapped(_ sender: UIButton) {
		guard canEnterNumber else { return }
		
		enteredCode += String(sender.tag - 1000)
		let indexOfNewValue = enteredCode.count
		let dotView = stackView_Codes.arrangedSubviews[indexOfNewValue - 1]
		UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
			dotView.backgroundColor = BeppaConfig.UserInterface.PasscodeSymbol.Color
		}, completion: nil)
		
		if enteredCode.count == 1 {
			UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
				self.button_Delete.alpha = 1.0
				self.button_Delete.isEnabled = true
			}, completion: nil)
		}
		
		if indexOfNewValue == BeppaConfig.Controller.NumberOfDigits {
			canEnterNumber = false
			setupViews_ForValidation(isBeforeValidation: true)
			delegate?.beppaController(validate: enteredCode, completion: setupViews_BasedOnValidationResult)
		}
		
	}
	
	@IBAction private func action_DeleteTapped(_ sender: UIButton) {
		guard !enteredCode.isEmpty else { return }
		enteredCode = String(enteredCode.prefix(enteredCode.count - 1))
		let dotView = stackView_Codes.arrangedSubviews[enteredCode.count]
		dotView.backgroundColor = .clear
		if enteredCode.isEmpty {
			UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
				self.button_Delete.alpha = 0.0
			}, completion: { _ in self.button_Delete.isEnabled = false })
		}
	}
	
	@IBAction private func action_BiometricTapped(_ sender: UIButton) {
		guard hasBiometricHardware else { return }
		
		let context = LAContext()
		context.localizedFallbackTitle = "احراز هویت"
		var error: NSError?
		
		guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
				let alert = UIAlertController(title: "بروز خطا", message: error?.localizedDescription, preferredStyle: .alert)
				alert.view.tintColor = .black
				alert.addAction(UIAlertAction(title: "باشه", style: .cancel, handler: { _ in }))
				self.present(alert, animated: true)
				return
		}
		
		context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForBiometricUsage) { success, error in
			if success {
				self.dismiss(animated: true, completion: nil)
			} else {
				print(error ?? "error")
			}
		}
	}
	
}

extension BeppaViewController {
	
	private func setupViews() {
		setupViews_BackgroundView()
		setupViews_TitleLabel()
		setupViews_MessageLabel()
		setupViews_NumpadButtons()
		setupViews_DotViewStackView()
		setupViews_DeleteButton()
		setupViews_BiometricButton()
	}
	
	private func setupViews_BackgroundView() {
		switch BeppaConfig.UserInterface.Controller.BackgroundType {
		case let .solid(color):
			view.backgroundColor = color
			view_VisualEffect.removeFromSuperview()
		case let .visualEffect(style):
			view.backgroundColor = .clear
			view_VisualEffect.effect = UIBlurEffect(style: style)
		case let .mix(color, style):
			view.backgroundColor = color
			view_VisualEffect.effect = UIBlurEffect(style: style)
		}
	}
	private func setupViews_TitleLabel() {
		label_Title.font		= BeppaConfig.UserInterface.Title.Font
		label_Title.text		= BeppaConfig.UserInterface.Title.Text
		label_Title.textColor	= BeppaConfig.UserInterface.Title.TextColor
	}
	private func setupViews_NumpadButtons() {
		buttons_Numbers.forEach { (button) in
			button.backgroundColor	= BeppaConfig.UserInterface.NumpadButton.BackgroundColor
			button.titleLabel?.font	= BeppaConfig.UserInterface.NumpadButton.Font
			button.tintColor		= BeppaConfig.UserInterface.NumpadButton.TintColor
			button.alpha			= 0.0
			button.transform		= CGAffineTransform(scaleX: 0.8, y: 0.8)
		}
	}
	private func setupViews_DotViewStackView() {
		let numberOfDigits = BeppaConfig.Controller.NumberOfDigits
		guard (4...8) ~= numberOfDigits else { fatalError("BeppaKit.Confir.Error: NumberOfDigits should be between 4 and 8") }
		
		let dotViewSize: CGFloat = 16.0
		for index in 0..<numberOfDigits {
			let dotView = UIView(frame: .zero)
			dotView.widthAnchor.constraint(equalToConstant: dotViewSize).isActive = true
			dotView.heightAnchor.constraint(equalToConstant: dotViewSize).isActive = true
			dotView.layer.cornerRadius = dotViewSize / 2
			dotView.clipsToBounds = true
			dotView.backgroundColor = .clear
			dotView.layer.borderColor = BeppaConfig.UserInterface.PasscodeSymbol.Color.cgColor
			dotView.layer.borderWidth = 1.0
			stackView_Codes.insertArrangedSubview(dotView, at: index)
		}
		constraint_StackView_Codes_Width.constant = (CGFloat(numberOfDigits) * dotViewSize) + CGFloat((numberOfDigits-1) * 20)
		view.layoutIfNeeded()
	}
	private func setupViews_DeleteButton() {
		button_Delete.tintColor = BeppaConfig.UserInterface.NumpadButton.TintColor
		button_Delete.alpha = 0.0
		button_Delete.isEnabled = false
	}
	private func setupViews_BiometricButton() {
		let context = LAContext()
		var error: NSError?
		
		if #available(iOS 11.0, *) {
			if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
				let bundle = Bundle(for: BeppaViewController.self)
				switch context.biometryType {
				case .faceID:
					reasonForBiometricUsage = "احراز هویت با استفاده از چهره"
					button_Biometric.setImage(UIImage(named: "faceid", in: bundle, compatibleWith: nil), for: .normal)
					button_Biometric.tintColor = BeppaConfig.UserInterface.NumpadButton.TintColor
					button_Biometric.alpha = 0.0
					button_Biometric.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
				case .touchID:
					reasonForBiometricUsage = "احراز هویت با استفاده از اثر انگشت"
					button_Biometric.setImage(UIImage(named: "touch", in: bundle, compatibleWith: nil), for: .normal)
					button_Biometric.tintColor = BeppaConfig.UserInterface.NumpadButton.TintColor
					button_Biometric.alpha = 0.0
					button_Biometric.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
				default:
					button_Biometric.alpha = 0.0
					button_Biometric.isEnabled = false
					hasBiometricHardware = false
				}
			} else {
				button_Biometric.alpha = 0.0
				button_Biometric.isEnabled = false
				hasBiometricHardware = false
			}
		} else {
			button_Biometric.alpha = 0.0
			button_Biometric.isEnabled = false
			hasBiometricHardware = false
		}
	}
	private func setupViews_MessageLabel() {
		label_Message.font		= BeppaConfig.UserInterface.Message.Font
		label_Message.text		= ""
		label_Message.textColor	= BeppaConfig.UserInterface.Message.TextColor
	}
	
	private func animateNumpadButtonsOnAppear() {
		let buttons: [UIButton] = hasBiometricHardware ? (buttons_Numbers + [button_Biometric]) : buttons_Numbers
		for (index, button) in buttons.enumerated() {
			let delay: TimeInterval = Double(index) * 0.05
			UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction], animations: {
				button.transform	= .identity
				button.alpha		= 1.0
			}, completion: nil)
		}
	}
	
	private func shakeDotViewsForFailure() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.5
		animation.values = [-16.0, 16.0, -16.0, 16.0, -8.0, 8.0, -5.0, 5.0, 0.0]
		stackView_Codes.layer.add(animation, forKey: "shake")
		for (index, dotView) in stackView_Codes.arrangedSubviews.reversed().enumerated() {
			let delay: TimeInterval = 0.1 + Double(index) * (0.5 / Double(BeppaConfig.Controller.NumberOfDigits))
			UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
				dotView.backgroundColor = .clear
			}, completion: nil)
		}
		
		UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
			self.button_Delete.alpha = 0.0
		}, completion: { _ in
			self.canEnterNumber = true
			self.button_Delete.isEnabled = false
		})
		
	}
	
	private func setupViews_ForValidation(isBeforeValidation: Bool) {
		guard BeppaConfig.Controller.HasActivityIndicator else {
			if isBeforeValidation { label_Message.text = "" }
			return
		}
		
		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
			self.view_NumpadHolder.transform				= isBeforeValidation ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
			self.view_NumpadHolder.alpha					= isBeforeValidation ? 0.0 : 1.0
			self.view_NumpadHolder.isUserInteractionEnabled	= !isBeforeValidation
			
			self.label_Message.transform					= isBeforeValidation ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
			self.label_Message.alpha						= isBeforeValidation ? 0.0 : 1.0
			
			if isBeforeValidation { self.view_ActivityIndicator.startAnimating() }
			self.view_ActivityIndicator.alpha				= isBeforeValidation ? 1.0 : 0.0
			self.view_ActivityIndicator.transform			= isBeforeValidation ? .identity : CGAffineTransform(scaleX: 2, y: 2)
		}, completion: { _ in
			if !isBeforeValidation { self.view_ActivityIndicator.stopAnimating() }
			if isBeforeValidation { self.label_Message.text = "" }
		})
		
	}
	
	private func setupViews_BasedOnValidationResult(_ result: BeppaValidationResult) {
		switch result {
		case .isValid:
			feedbackGenerator.notificationOccurred(.success)
			let delegate = self.delegate
			dismiss(animated: true) { delegate?.beppaControllerDidValidatePasscode(self, wasSuccessful: true) }
		case .isInvalid(let message):
			feedbackGenerator.notificationOccurred(.error)
			label_Message.text = message ?? ""
			setupViews_ForValidation(isBeforeValidation: false)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.shakeDotViewsForFailure() }
			enteredCode = ""
			delegate?.beppaControllerDidValidatePasscode(self, wasSuccessful: false)
		}
	}
	
	
	
	
}

