//
//  BeppaConfig+UserInterface.swift
//  BeppaKit
//
//  Created by Omid Golparvar on 11/5/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import Foundation

extension BeppaConfig {
	
	public final class UserInterface {}
	
}

extension BeppaConfig.UserInterface {
	
	public final class Controller {
		public static var BackgroundType			: ControllerBackgroundType	= .visualEffect(style: .extraLight)
	}
	
	public final class Title {
		public static var Font						: UIFont	= UIFont.boldSystemFont(ofSize: 16)
		public static var Text						: String	= "رمز عبور را وارد نمایید"
		public static var TextColor					: UIColor	= .black
	}
	
	public final class NumpadButton {
		public static var BackgroundColor			: UIColor	= UIColor.black.withAlphaComponent(0.1)
		public static var Font						: UIFont	= UIFont.boldSystemFont(ofSize: 24)
		public static var HighlightBackgroundColor	: UIColor	= UIColor.white
		public static var TintColor					: UIColor	= .black
	}
	
	public final class PasscodeSymbol {
		public static var Color						: UIColor	= .black
	}
	
	public final class Message {
		public static var Font						: UIFont	= UIFont.systemFont(ofSize: 14)
		public static var TextColor					: UIColor	= .red
	}
	
}

extension BeppaConfig.UserInterface {
	
	public enum ControllerBackgroundType {
		case solid(color: UIColor)
		case visualEffect(style: UIBlurEffect.Style)
		case mix(backgroundColor: UIColor, visualEffectStyle: UIBlurEffect.Style)
	}
	
}
