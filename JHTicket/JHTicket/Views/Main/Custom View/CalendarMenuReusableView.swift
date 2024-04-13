//
//  CalendarMenuReusableView.swift
//  JHTicket
//
//  Created by JH on 2021/09/07.
//

import UIKit
import SnapKit
import Then

final class CalendarMenuReusableView: UICollectionReusableView {
    
    // MARK: - Properties
	
	private lazy var titleButton = UIButton().then {
		$0.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
	}
	
	private lazy var leftButton = UIButton().then {
		$0.addAction(UIAction(handler: { _ in self.previousButtonPressed?() }), for: .touchUpInside)
	}
	
	private lazy var rightButton = UIButton().then {
		$0.addAction(UIAction(handler: { _ in self.nextButtonPressed?() }), for: .touchUpInside)
	}
    
    var previousButtonPressed: (() -> ())?
    var nextButtonPressed: (() -> ())?
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
		
		configUI()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
		
		configUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }
    
    // MARK: - Public Method
    public func configUI() {
		addSubviews(titleButton, leftButton, rightButton)
		
		titleButton.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalTo(leftButton.snp.trailing).offset(8)
			make.trailing.equalTo(rightButton.snp.leading).offset(-8)
		}
		
		leftButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
			make.width.height.equalTo(24)
		}
		
		rightButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalToSuperview().offset(-8)
			make.width.height.equalTo(24)
		}
		
//        leftButton.setRenderingStyle(name: "pre_button", color: TicketStyler.Color.reversal)
//        rightButton.setRenderingStyle(name: "next_button", color: TicketStyler.Color.reversal)
    }
    
    public func setCalendarMenuCell(day: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        titleButton.setTitle(dateFormatter.string(from: day), for: .normal)
    }
}
