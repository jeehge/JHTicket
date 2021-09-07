//
//  CalendarMenuCell.swift
//  JHTicket
//
//  Created by JH on 2021/09/07.
//

import UIKit

final class CalendarMenuCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var previousButtonPressed: (() -> ())?
    var nextButtonPressed: (() -> ())?
    
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
    
    // MARK: - Public Method
    public func doLayout() {
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 20.0)
        
//        leftButton.setRenderingStyle(name: "pre_button", color: TicketStyler.Color.reversal)
//        rightButton.setRenderingStyle(name: "next_button", color: TicketStyler.Color.reversal)
    }
    
    public func setCalendarMenuCell(day: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        titleButton.setTitle(dateFormatter.string(from: day), for: .normal)
    }
    
    @IBAction public func actionPreviousMonth(_ sender: UIButton) {
        previousButtonPressed?()
    }
    
    @IBAction public func actionNextsMonth(_ sender: UIButton) {
        nextButtonPressed?()
    }
}

