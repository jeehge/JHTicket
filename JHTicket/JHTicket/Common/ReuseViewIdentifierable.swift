//
//  ReuseViewIdentifierable.swift
//  JHTicket
//
//  Created by JH on 2021/09/03.
//

import UIKit

protocol ReuseViewIdentifierable { }

extension ReuseViewIdentifierable where Self: UIView {
	static var identifier: String {
		return String(describing: self)
	}
	
	static var supplementaryElementOfKind: String {
		return String(describing: self) + "-element-kind"
	}
}

extension ReuseViewIdentifierable where Self: UIViewController {
	static var identifier: String {
		return String(describing: self)
	}
}

extension UITableViewCell: ReuseViewIdentifierable { }
extension UICollectionReusableView: ReuseViewIdentifierable { }
