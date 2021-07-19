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
  let lottieView = LottieWrapper()

  var popViews: [UIView] = []

  var editingEvent: Event?

  lazy var scopeGesture: UIPanGestureRecognizer = {
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

      calendar.layer.masksToBounds = false
      calendar.layer.shadowColor = UIColor.black.cgColor
      calendar.layer.shadowOffset = CGSize(width: 1, height: 1)
      calendar.layer.shadowOpacity = 1
    }
  }

  @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!

  @IBOutlet var waterfallView: UICollectionView! {
    didSet {
      (waterfallView.collectionViewLayout as? WaterfallLayout)?.delegate = self
      waterfallView.delegate = self
      waterfallView.dataSource = self
      waterfallView.registerCellWithNib(
        identifier: String(describing: LobbyCollectionCell.self),
        bundle: nil
      )
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let addEventView = segue.destination as? AddEventViewController {
      if let event = editingEvent {
        addEventView.event = event
        addEventView.isEditingEvent = true
      }
    }

    editingEvent = nil

    lottieView.dismiss()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    calendar.select(Date())

    navigationItem.title = Date().getDayString(type: .day)

    userViewModel.user.bind { [weak self] user in
      guard user != nil else { return }

      self?.eventViewModel.fetchEvents()
      self?.relationViewModel.fetchRelations()
      self?.calendar.reloadData()
      self?.waterfallView.reloadData()
      self?.lottieView.leave()
    }

    eventViewModel.events.bind { [weak self] _ in
      self?.calendar.reloadData()
      self?.waterfallView.reloadData()
      self?.lottieView.leave()
    }

    relationViewModel.relations.bind { [weak self] _ in
      self?.calendar.reloadData()
      self?.waterfallView.reloadData()
      self?.lottieView.leave()
    }

    view.addGestureRecognizer(scopeGesture)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidDisappear(true)
    userViewModel.fetchUserDate()
    lottieView.show(animation: .mail, jobs: 3)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)

    popViews.forEach { $0.removeFromSuperview() }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let bottomOffest = tabBarController?.tabBar.frame.height ?? 0
    waterfallView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomOffest, right: 0)
  }

  @IBAction func logout(_ sender: UIBarButtonItem) {
    try? Auth.auth().signOut()
  }
}

// MARK: - calendar delegate / datasource
extension LobbyViewController: FSCalendarDelegate,
                               FSCalendarDataSource,
                               FSCalendarDelegateAppearance,
                               UIGestureRecognizerDelegate {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    navigationItem.title = date.getDayString(type: .day)
    waterfallView.reloadData()
  }

  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendarHeightConstraint.constant = bounds.height
    view.layoutIfNeeded()
  }

  //  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
  // MARK: 每月第一週置頂
  //  }

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let shouldBegin = waterfallView.contentOffset.y <= -waterfallView.contentInset.top
//    let shouldBegin = false

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
      return !todayEvents.isEmpty ? .redB1 : .redB2
    } else if date.week == 7 && date.month == calendar.currentPage.month {
      return !todayEvents.isEmpty ? .greenB1 : .greenB2
    } else if date.isSameDay(date: Date()) {
      return !todayEvents.isEmpty ? .systemBackground : .secondaryBackground
    } else {
      return !todayEvents.isEmpty ? .button : . buttonDisable
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

    if date.week == 1 && date.month == calendar.currentPage.month {
      return !todayEvents.isEmpty ? .redB1 : .redB2
    } else if date.week == 7 && date.month == calendar.currentPage.month {
      return !todayEvents.isEmpty ? .greenB1 : .greenB2
    } else if date.isSameDay(date: Date()) {
      return .systemGray6
    } else {
      return !todayEvents.isEmpty ? .button : .buttonDisable
    }
  }

  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    if date.isSameDay(date: Date()) {
      return appearance.todayColor
    } else {
      return .clear
    }
  }
}

// MARK: - custom tab bar delegate
extension LobbyViewController: TabBarTapDelegate {
  func tabBarTapped(_ controller: PBTabBarViewController, index: Int) {
    LKProgressHUD.show()
    performSegue(withIdentifier: "addEvent", sender: self)
  }
}

extension LobbyViewController: EventDetailDelegate {
  func eventDetalView(view: EventDetailView, onEditEvent event: Event) {
    editingEvent = event

    performSegue(withIdentifier: "addEvent", sender: self)
  }

  func eventDetalView(view: EventDetailView, onDeleteEvent event: Event) {
    let provider = SCLAlertViewProvider()

    provider.setConfirmAction { self.eventViewModel.deleteEvent(event: event) }
      .showAlert(type: .delete)
  }
}

extension LobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, WaterfallLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard userViewModel.user.value != nil,
          let cell = collectionView.cellForItem(at: indexPath) as? LobbyCollectionCell else { return }
    cell.isSelected = false

    guard let event = cell.event else { return }

    let detailVC = EventDetailView()
    detailVC.delegate = self
    detailVC.show(view: self.view)
    detailVC.setUp(event: event, relations: [cell.category!])
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let selectedDate = calendar.selectedDate else { return 0 }

    return eventViewModel.fetchEventIn(date: selectedDate).count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            cell: LobbyCollectionCell.self,
            indexPath: indexPath),
          let selectedDate = calendar.selectedDate else {
      String.trackFailure("dequeueReusableCell failures.")
      return LobbyCollectionCell()
    }

    let event = eventViewModel.fetchEventIn(date: selectedDate)[indexPath.row]
    if let relation = userViewModel.getCategory(type: .relation, event: event) {
      cell.setUp(relation: relation, event: event)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let radius = cell.contentView.layer.cornerRadius
    cell.contentView.layer.masksToBounds = true
    cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
  }

  func columnOfWaterfall(_ collectionView: UICollectionView) -> Int {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return 2
    } else {
      return 3
    }
  }

  func waterfall(_ collectionView: UICollectionView, layout waterfallLayout: WaterfallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
    let baseHeight = view.frame.height / 4
    var commentHeight: CGFloat = 0

    guard let selectedDate = calendar.selectedDate,
          let comment = eventViewModel.fetchEventIn(date: selectedDate)[indexPath.row].comment as NSString? else { return baseHeight }
    if comment != "" {
      commentHeight = comment.boundingRect(
        with: CGSize(
          width: view.frame.width / 2,
          height: view.frame.height / 2),
        options: [.usesFontLeading, .usesLineFragmentOrigin],
        attributes: [.font: UIFont.systemFont(ofSize: 14)],
        context: .none).height
    }

    return baseHeight + commentHeight
  }

  func waterfall(_ collectionView: UICollectionView, layout waterfallLayout: WaterfallLayout, heightForSupplementaryView indexPath: IndexPath) -> CGFloat {
    40
  }
}
