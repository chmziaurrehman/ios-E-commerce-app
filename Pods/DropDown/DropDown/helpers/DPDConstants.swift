//
//  Constants.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct DPDConstant {

	internal struct KeyPath {

		static let Frame = "frame"

	}

	internal struct ReusableIdentifier {

		static let DropDownCell = "DropDownCell"

	}

	internal struct UI {

		static let TextColor = #colorLiteral(red: 0.4117647059, green: 0.2823529412, blue: 0.6156862745, alpha: 1)
		static let TextFont = UIFont(name: "Montserrat-Regular", size: 13)
		static let BackgroundColor = UIColor(white: 0.99, alpha: 5)
		static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 5)
		static let SeparatorColor = #colorLiteral(red: 0.4117647059, green: 0.2823529412, blue: 0.6156862745, alpha: 1)
		static let CornerRadius: CGFloat = 5
		static let RowHeight: CGFloat = 44
		static let HeightPadding: CGFloat = 20

		struct Shadow {

			static let Color = UIColor.darkGray
			static let Offset = CGSize.zero
			static let Opacity: Float = 0.4
			static let Radius: CGFloat = 8

		}

	}

	internal struct Animation {

		static let Duration = 0.15
		static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
		static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
		static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

	}

}
