//
//  MainViewController.swift
//  JHTicket
//
//  Created by JH on 2021/09/02.
//

import SnapKit
import Then
import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout()).then {
        $0.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
		$0.register(CalendarMenuReusableView.self, forSupplementaryViewOfKind: CalendarMenuReusableView.supplementaryElementOfKind, withReuseIdentifier: CalendarMenuReusableView.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }

    private var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    private var today = Date()
    private var numberOfWeeks: Int = 0
    private var numberOfItems: Int = 0
    private var currentMonthOfDates: [Date] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    // MARK: - Initialize

    private func configUI() {
        view.addSubviews(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func initPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        collectionView.gestureRecognizers = [panGesture]
    }
	

//	let collectionViewWidth = (collectionView.frame.width - (edgeInsets.right * (7 + 1))) / CGFloat(weekArray.count)
//	let collectionViewHeight = (collectionView.frame.height - topViewHeight - collectionViewWidth) / CGFloat(numberOfWeeks)
//	return CGSize(width: collectionViewWidth, height: collectionViewHeight)
	
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            /// Item spans the width and height of the group
			let itemWidht = UIScreen.main.bounds.width / CGFloat(7)
			let itemHeight = (self.collectionView.frame.height - 100) / CGFloat(self.numberOfWeeks)
			let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidht),
												  heightDimension: .absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            /// Group spans the entire section and has an absolute height of 60
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												   heightDimension: .absolute(itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])

            /// Set the section with the group
            let section = NSCollectionLayoutSection(group: group)

            /// Header size
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            /// Header item
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: CalendarMenuReusableView.supplementaryElementOfKind,
                alignment: .top
            )
            sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        return layout
    }

    // MARK: - IBAction

    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
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
        numberOfWeeks = weekRange.count // 주
        numberOfItems = numberOfWeeks * 7
        dateForCellAtIndexPath(itemsCount: numberOfItems)
        return numberOfItems
    }

    // 현재 달 첫째날 기준의 날짜 데이터를 리턴
    private func firstDateOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month], from: today) // 현재 날짜에서 년 월을 가진 component를 구함
        components.day = 1 // 1일로 셋팅
        let firstDateMonth = calendar.date(from: components)!
        return firstDateMonth
    }

    // 한달치 달력을 currentMonthOfDates 에 저장
    private func dateForCellAtIndexPath(itemsCount: Int) {
        currentMonthOfDates.removeAll()

        guard let ordinalityOfFirstDay = calendar.ordinality(of: Calendar.Component.day, in: Calendar.Component.weekOfMonth, for: firstDateOfMonth()) else { return }
        for i in 0 ..< numberOfItems {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return daysCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		if indexPath.section == 0 {
//            let calendarWeekCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
//            calendarWeekCell.setCalendarCellforWeekday(weekday: weekArray[indexPath.row])
//            return calendarWeekCell
//        } else {
            let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
            let componets = Calendar.current.dateComponents([.year, .month, .day], from: today)
            calendarCell.setCalendarCellforDay(day: currentMonthOfDates[indexPath.row], currentMonth: componets.month)
            return calendarCell
//        }
    }
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == CalendarMenuReusableView.supplementaryElementOfKind {
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarMenuReusableView.identifier, for: indexPath) as! CalendarMenuReusableView
			header.setCalendarMenuCell(day: today)
			header.previousButtonPressed = { [weak self] in
				self?.prevMonth()
				self?.collectionView.reloadData()
			}
			header.nextButtonPressed = { [weak self] in
				self?.nextMonth()
				self?.collectionView.reloadData()
			}
			return header
		}
		else {
			return UICollectionReusableView()
		}
	}
}
