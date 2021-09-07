//
//  CalendarCell.swift
//  JHTicket
//
//  Created by JH on 2021/09/07.
//

import UIKit

final class CalendarCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        doLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doLayout()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        doLayout()
    }
    
    private func doLayout() {
        weekdayLabel.textColor = .lightGray
        dayLabel.textColor = .lightGray
        
        weekdayLabel.font = .systemFont(ofSize: 14.0)
        dayLabel.font = .boldSystemFont(ofSize: 14.0)
    }
    
    // MARK: - Public Method
    
    public func setCalendarCellforWeekday(weekday: String) {
        weekdayLabel.text = weekday
        weekdayLabel.isHidden = false
        dayLabel.isHidden = true
    }
    
    public func setCalendarCellforDay(day: Date, currentMonth: Int?) {
        let componets = Calendar.current.dateComponents([.year, .month, .day], from: day)
        if  let month = componets.month,
            let day = componets.day {
            if month != currentMonth {
                dayLabel.textColor = .lightGray
            } else {
                dayLabel.textColor = .gray
            }
            dayLabel.text = "\(day)"
        }
        dayLabel.isHidden = false
        weekdayLabel.isHidden = true
    }
}
