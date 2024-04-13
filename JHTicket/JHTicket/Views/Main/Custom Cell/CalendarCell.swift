//
//  CalendarCell.swift
//  JHTicket
//
//  Created by JH on 2021/09/07.
//

import UIKit
import SnapKit
import Then

final class CalendarCell: UICollectionViewCell {

    // MARK: - Properties
	
	private let dayLabel = UILabel().then {
		$0.textColor = .lightGray
		$0.font = .boldSystemFont(ofSize: 14.0)
	}
    
	private let weekdayLabel = UILabel().then {
		$0.textColor = .lightGray
		$0.font = .systemFont(ofSize: 14.0)
	}
    
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
        
		configUI()
    }
    
    private func configUI() {
		contentView.addSubviews(dayLabel, weekdayLabel)
		
		dayLabel.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.trailing.equalToSuperview().offset(-5)
			make.height.equalTo(22)
		}
        
		weekdayLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
    }
    
    // MARK: - Public Method
    
    func setCalendarCellforWeekday(weekday: String) {
        weekdayLabel.text = weekday
        weekdayLabel.isHidden = false
        dayLabel.isHidden = true
    }
    
    func setCalendarCellforDay(day: Date, currentMonth: Int?) {
        let componets = Calendar.current.dateComponents([.year, .month, .day], from: day)
        if  let month = componets.month,
            let day = componets.day {
            if month != currentMonth {
				dayLabel.textColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
            } else {
                dayLabel.textColor = .gray
            }
            dayLabel.text = "\(day)"
        }
        dayLabel.isHidden = false
        weekdayLabel.isHidden = true
    }
}
