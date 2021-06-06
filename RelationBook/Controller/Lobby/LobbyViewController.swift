//
//  LobbyViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/1.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FSCalendar


class LobbyViewController: UIViewController {

  let userViewModel = UserViewModel()
  let relationViewModel = RelationViewModel()
  let eventViewModel = EventViewModel()
  
  fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
    [unowned self] in
    let panGesture = UIPanGestureRecognizer(
      target: calendar,
      action: #selector(calendar.handleScopeGesture(_:))
    )
    panGesture.delegate = self
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 2
    return panGesture
  }()
  
  @IBOutlet var calendar: FSCalendar! {
    didSet {
      calendar.delegate = self
      calendar.dataSource = self
      calendar.locale = Locale.init(identifier: "zh-tw")
    }
  }
  
  @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.lk_registerCellWithNib(identifier: String(describing: LobbyEventCell.self), bundle: nil)
      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 60
    }
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()

    calendar.select(Date())

    tableView.separatorColor = .clear

    navigationItem.title = Date().getDayString(type: .day)

    userViewModel.user.bind { value in
      guard let _ = value else { return }
      self.eventViewModel.fetchEvents()
      self.relationViewModel.fetchRelations()
      self.tableView.reloadData()
      self.calendar.reloadData()
    }

    eventViewModel.events.bind { events in
      self.tableView.reloadData()
      self.calendar.reloadData()
    }

    relationViewModel.relations.bind { relations in
      self.tableView.reloadData()
      self.calendar.reloadData()
    }

    userViewModel.fetchUserDate()

    view.addGestureRecognizer(scopeGesture)
    tableView.panGestureRecognizer.require(toFail: scopeGesture)
  }
}

// MARK: - calendar delegate / datasource
extension LobbyViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate {

  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    navigationItem.title = date.getDayString(type: .day)
    tableView.reloadData()
  }

  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    
    calendarHeightConstraint.constant = bounds.height
    view.layoutIfNeeded()
  }

//  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
// MARK: 每月第一週置頂
//  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

    let shouldBegin = tableView.contentOffset.y <= -tableView.contentInset.top
    
    if shouldBegin {
      let velocity = scopeGesture.velocity(in: view)
      switch calendar.scope {
      case .month:
        return velocity.y < 0
      case .week:
        return velocity.y > 0
      @unknown default:
        print("Unexpected error.")
      }
    }
    return shouldBegin
  }

  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {

    let events = eventViewModel.events.value
    let todayEvents = events.filter { event in
      date.isSameDay(date: event.time.dateValue())
    }

    if date.week == 1 && date.month == calendar.currentPage.month {
      return todayEvents.count > 0 ? .redB1 : .redB2
    } else if date.week == 7 && date.month == calendar.currentPage.month {
      return todayEvents.count > 0 ? .greenB1 : .greenB2
    } else {
      return todayEvents.count > 0 ? .label : .secondaryLabel
    }
  }

  func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    if date.isFirstDay {
      return "\(date.month) 月"
    }
    return "\(date.day)"
  }

  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
    let events = eventViewModel.events.value
    let todayEvents = events.filter { event in
      date.isSameDay(date: event.time.dateValue())
    }

    if date.isWeekend {
      return todayEvents.count > 0 ? .redB1 : .redB2
    } else {
      return todayEvents.count > 0 ? .label : .secondaryLabel
    }
  }

  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    if date.isSameDay(date: Date()) {
      return appearance.todayColor
    } else {
      return appearance.todaySelectionColor
    }
  }
}

// MARK: - tableView delegate / datasource
extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    guard let selectedDate = calendar.selectedDate else { return 0 }

    return eventViewModel.fetchEventIn(date: selectedDate).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LobbyEventCell.self), for: indexPath)

    guard let selectedDate = calendar.selectedDate,
          let user = userViewModel.user.value else { return cell }

    if let cell = cell as? LobbyEventCell {

      let event = eventViewModel.fetchEventIn(date: selectedDate)[indexPath.row]

      cell.cellSetup(type: .lobby, event: event, relations: user.getCategoriesWithSuperIndex(subType: .relation).filter { event.relations.contains($0.id) })
    }

    cell.updateConstraintsIfNeeded()

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let user = userViewModel.user.value,
          let cell = tableView.cellForRow(at: indexPath) as? LobbyEventCell else { return }

    cell.isSelected = false

    guard let event = cell.event else { return }

    let relations = cell.relations

    let detailVC = EventDetailView()
    let blurView = view.addBlurView()
    view.addSubview(detailVC)

    detailVC.addConstarint(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, paddingLeft: 16, paddingRight: 16, height: view.frame.height / 1.5)
    detailVC.cornerRadius = detailVC.frame.width * 0.05

    view.layoutIfNeeded()

    detailVC.setUp(event: event, relations: relations)

    detailVC.onDismiss = {
      blurView.removeFromSuperview()
    }
  }
}

// MARK: - custom tab bar delegate
extension LobbyViewController: TabBarTapDelegate {

  func tabBarTapped(_ controller: PBTabBarViewController, index: Int) {
    performSegue(withIdentifier: "addEvent", sender: self)
  }
}
