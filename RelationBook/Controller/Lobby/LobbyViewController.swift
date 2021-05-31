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
      tableView.lk_registerCellWithNib(identifier: String(describing: LobbyEventTableCell.self), bundle: nil)
    }
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()

    tableView.separatorColor = .clear

    navigationItem.title = Date().getDayString(type: .day)

    userViewModel.user.bind { value in
      guard let _ = value else { return }
      self.eventViewModel.fetchEvents()
      self.relationViewModel.fetchRelations()
    }

    eventViewModel.events.bind { events in
      self.tableView.reloadData()
    }

    relationViewModel.relations.bind { relations in
      self.tableView.reloadData()
    }

    userViewModel.fetchUserDate()

    view.addGestureRecognizer(scopeGesture)
    tableView.panGestureRecognizer.require(toFail: scopeGesture)
  }
}

extension LobbyViewController: FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {

  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    navigationItem.title = date.getDayString(type: .day)
    tableView.reloadData()
  }

//  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//
//    if calendar.collectionView.decelerationRate.rawValue <= 1 {
//      let date = calendar.date(for: calendar.visibleCells().first!)
//      calendar.select(date, scrollToDate: false)
//    }
//  }

  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    
    calendarHeightConstraint.constant = bounds.height
    view.layoutIfNeeded()
  }
  
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
}

extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    let events = eventViewModel.events.value.filter { event in
      guard let selectedDate = calendar.selectedDate else { return false }

      return selectedDate.isSameDay(date: event.time.dateValue())
    }

    return events.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LobbyEventTableCell.self), for: indexPath)

    if let cell = cell as? LobbyEventTableCell {
      cell.setConstraint()
      view.layoutIfNeeded()
      cell.event = eventViewModel.events.value[indexPath.row]
      cell.relations = relationViewModel.relations.value
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.isSelected = false
  }
}

extension LobbyViewController: TabBarTapDelegate {
  
  func tabBarTapped(_ controller: PBTabBarViewController, index: Int) {
    performSegue(withIdentifier: "addEvent", sender: self)
  }
}
