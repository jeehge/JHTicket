//
//  MainViewController.swift
//  JHTicket
//
//  Created by JH on 2021/09/02.
//

import UIKit

final class MainViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    private let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
    private let topViewHeight: CGFloat = 50.0
    
    private var today = Date()
    private let weekArray = ["일".localized,
                             "월".localized,
                             "화".localized,
                             "수".localized,
                             "목".localized,
                             "금".localized,
                             "토".localized]
    private var numberOfWeeks: Int = 0
    private var numberOfItems: Int = 0
    private var currentMonthOfDates: [Date] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        initPanGesture()
    }
    
    // MARK: - Initialize
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func initPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        collectionView.gestureRecognizers = [panGesture]
    }
    
    // MARK: - IBAction
    
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: collectionView)
        if gesture.state == UIPanGestureRecognizer.State.ended {
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x > 0 { // 이전달
                    prevMonth()
                    collectionView.reloadData()
                } else { // 다음달
                    nextMonth()
                    collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Custom Method
    
    // 달력에 표시할 날짜의 갯수
    private func daysCount() -> Int {
        let weekRange: Range = calendar.range(of: Calendar.Component.weekOfMonth, in: Calendar.Component.month, for: firstDateOfMonth())!
        numberOfWeeks = weekRange.count  // 주
        numberOfItems = numberOfWeeks * weekArray.count
        dateForCellAtIndexPath(itemsCount: numberOfItems)
        return numberOfItems
    }
    
    // 현재 달 첫째날 기준의 날짜 데이터를 리턴
    private func firstDateOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month], from: today) // 현재 날짜에서 년 월을 가진 component를 구함
        components.day = 1  // 1일로 셋팅
        let firstDateMonth = calendar.date(from: components)!
        return firstDateMonth
    }
    
    // 한달치 달력을 currentMonthOfDates 에 저장
    private func dateForCellAtIndexPath(itemsCount: Int) {
        currentMonthOfDates.removeAll()
        
        guard let ordinalityOfFirstDay = calendar.ordinality(of: Calendar.Component.day, in: Calendar.Component.weekOfMonth, for: firstDateOfMonth()) else { return }
        for i in 0..<numberOfItems {
            var dateComponents = DateComponents()
            /*
             토요일이라고 하면.i가 0일때 i-토요일(7-1) = -6
             toDate에서 -6을 더한 날짜부터 모든 날짜를 배열에 담는다.
             즉, 저번달 날짜부터 담는다.
            */
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            if let date = calendar.date(byAdding: dateComponents, to: firstDateOfMonth()) {
                currentMonthOfDates.append(date)
            }
        }
    }
    
    private func prevMonth() {
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        let month = components.month! - 1
        components.setValue(month, for: .month)
        today = calendar.date(from: components) ?? Date()
        dateForCellAtIndexPath(itemsCount: daysCount())
    }
    
    private func nextMonth() {
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        let month = components.month! + 1
        components.setValue(month, for: .month)
        today = calendar.date(from: components) ?? Date()
        dateForCellAtIndexPath(itemsCount: daysCount())
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /*
        첫번째는 저번달 년/월 다음달
        두번째는 월화수목금토일
        세번째는 날짜
        */
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return weekArray.count
        default:
            return daysCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = UICollectionViewCell()
        if indexPath.section == 0 {
            let calendarMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarMenuCell.identifier, for: indexPath) as! CalendarMenuCell
            calendarMenuCell.setCalendarMenuCell(day: today)
            calendarMenuCell.previousButtonPressed = { [weak self] in
                self?.prevMonth()
                self?.collectionView.reloadData()
            }
            calendarMenuCell.nextButtonPressed = { [weak self] in
                self?.nextMonth()
                self?.collectionView.reloadData()
            }
            cell = calendarMenuCell
        } else if indexPath.section == 1 {
            let calendarWeekCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
            calendarWeekCell.setCalendarCellforWeekday(weekday: weekArray[indexPath.row])
            cell = calendarWeekCell
        } else {
            let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
            let componets = Calendar.current.dateComponents([.year, .month, .day], from: today)
            calendarCell.setCalendarCellforDay(day: currentMonthOfDates[indexPath.row], currentMonth: componets.month)
            cell = calendarCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let collectionViewWidth = UIScreen.main.bounds.width
            return CGSize(width: collectionViewWidth, height: topViewHeight)
        } else if indexPath.section == 1 {
			let collectionViewWidth = (UIScreen.main.bounds.width - (edgeInsets.right * 7)) / CGFloat(weekArray.count)
            let collectionViewHeight = collectionViewWidth
            return CGSize(width: collectionViewWidth, height: collectionViewHeight)
        } else {
            let collectionViewWidth = (UIScreen.main.bounds.width - (edgeInsets.right * 7)) / CGFloat(weekArray.count)
			let collectionViewHeight = (UIScreen.main.bounds.height - topViewHeight - collectionViewWidth) / CGFloat(numberOfWeeks)
            return CGSize(width: collectionViewWidth, height: collectionViewHeight)
        }
    }
    
    // 최소 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.bottom
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
