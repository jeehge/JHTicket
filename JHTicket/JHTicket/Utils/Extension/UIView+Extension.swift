//
//  UIView+Extension.swift
//  JHTicket
//
//  Created by JH on 4/12/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
