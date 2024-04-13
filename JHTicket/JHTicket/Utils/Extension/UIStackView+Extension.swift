//
//  UIStackView+Extension.swift
//  JHTicket
//
//  Created by JH on 4/13/24.
//

import UIKit

extension UIStackView {
	public func addArrangedSubviews(_ views: UIView...) {
		views.forEach {
			addArrangedSubview($0)
		}
	}
}
