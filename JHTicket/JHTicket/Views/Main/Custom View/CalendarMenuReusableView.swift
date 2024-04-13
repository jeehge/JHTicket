//
//  CalendarMenuReusableView.swift
//  JHTicket
//
//  Created by JH on 2021/09/07.
//

import SnapKit
import Then
import UIKit

final class CalendarMenuReusableView: UICollectionReusableView {
    // MARK: - Properties

    private lazy var titleButton = UIButton().then {
		$0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
    }

    private lazy var leftButton = UIButton().then {
		$0.setImage(UIImage(named: "previousButton"), for: .normal)
        $0.addAction(UIAction(handler: { _ in self.previousButtonPressed?() }), for: .touchUpInside)
    }

    private lazy var rightButton = UIButton().then {
		$0.setImage(UIImage(named: "nextButton"), for: .normal)
        $0.addAction(UIAction(handler: { _ in self.nextButtonPressed?() }), for: .touchUpInside)
    }
	
	private let WeeklyView = UIStackView().then {
		$0.axis = .horizontal
		$0.spacing = 2
		$0.distribution = .fillEqually
	}
	private let weekArray = ["일".localized, "월".localized, "화".localized, "수".localized, "목".localized, "금".localized, "토".localized]
	
    var previousButtonPressed: (() -> Void)?
    var nextButtonPressed: (() -> Void)?

    // MARK: - Initialize

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configUI()
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)

        configUI()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    // MARK: - Public Method

    public func configUI() {
        addSubviews(titleButton, leftButton, rightButton, WeeklyView)

        titleButton.snp.makeConstraints { make in
			make.height.equalTo(40)
            make.leading.equalTo(leftButton.snp.trailing).offset(8)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8)
        }

        leftButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
			make.bottom.equalTo(WeeklyView.snp.top).offset(-8)
            make.width.height.equalTo(24)
        }

        rightButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalTo(WeeklyView.snp.top).offset(-8)
            make.width.height.equalTo(24)
        }
		
		WeeklyView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.equalTo(60)
		}
		
		weekArray.forEach { text in
			let label = UILabel()
			label.textAlignment = .center
			label.text = text
			label.textColor = .lightGray
			WeeklyView.addArrangedSubview(label)
		}
		
//        leftButton.setRenderingStyle(name: "pre_button", color: TicketStyler.Color.reversal)
//        rightButton.setRenderingStyle(name: "next_button", color: TicketStyler.Color.reversal)
    }

    func setCalendarMenuCell(day: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        titleButton.setTitle(dateFormatter.string(from: day), for: .normal)
    }
}
