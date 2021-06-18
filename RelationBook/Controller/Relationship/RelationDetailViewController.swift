//
//  RelationDetailViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/4.
//

import UIKit

class RelationDetailViewController: UIViewController {
  enum TableType: Int {
    case event
    case profile
  }

  @IBOutlet var iconView: IconView!
  @IBOutlet var iconBackground: UIView!
  @IBOutlet var selectionBar: SelectionView! {
    didSet {
      selectionBar.type = .stack
      selectionBar.delegate = self
      selectionBar.datasource = self
    }
  }
  @IBOutlet var contentView: UIView!

  var sortedRelationList = [[Feature]]()

  var scrollView = RBScrollView(isPagingEnabled: true)

  let eventTableView: UITableView = {
    let eventTableView = UITableView()
    eventTableView.tag = TableType.event.rawValue
    eventTableView.estimatedRowHeight = 40

    eventTableView.lk_registerCellWithNib(
      identifier: String(describing: LobbyEventCell.self),
      bundle: nil)
    eventTableView.lk_registerHeaderWithNib(
      identifier: String(describing: RelationTableHeaderCell.self),
      bundle: nil)

    return eventTableView
  }()

  let profileTableView: UITableView = {
    let profileTableView = UITableView()

    profileTableView.tag = TableType.profile.rawValue
    profileTableView.backgroundColor = .background
    profileTableView.lk_registerHeaderWithNib(
      identifier: String(describing: RelationTableHeaderCell.self),
      bundle: nil)
    profileTableView.lk_registerCellWithNib(
      identifier: String(describing: RelationProfileCell.self),
      bundle: nil)

    return profileTableView
  }()

  let relationViewModel = RelationViewModel()
  let eventViewModel = EventViewModel()
  let userViewModel = UserViewModel()

  var relationCategory: Category?
  var relation: Relation? {
    didSet {
      profileTableView.reloadData()
    }
  }

  var events = [Event]() {
    didSet {
      eventsSorted.removeAll()
      var eventPool: [Date: [Event]] = [:]

      events.forEach { event in
        let date = event.time.dateValue().midnight
        if var events = eventPool[date] {
          events.append(event)
          eventPool.updateValue(events, forKey: date)
        } else {
          eventPool[date] = [event]
        }
      }

      eventsSorted = eventPool.sorted { $0.key > $1.key }
      eventTableView.reloadData()
    }
  }
  var eventsSorted: [Dictionary<Date, [Event]>.Element] = []
  var editingEvent: Event?

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let addEventView = segue.destination as? AddEventViewController {
      if let event = editingEvent {
        addEventView.event = event
        addEventView.isEditingEvent = true
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let category = relationCategory else { dismiss(animated: true); return }

    navigationItem.title = category.title

    eventViewModel.events.bind { [weak self] events in
      guard let relation = self?.relationCategory else { return }
      self?.events = events.filter { $0.relations.contains(relation.id) }
    }

    relationViewModel.relations.bind { [weak self] relations in
      self?.relation = relations.first { $0.categoryIndex == self?.relationCategory?.id }
    }

    userViewModel.fetchUserDate()
    eventViewModel.fetchEvents()
    relationViewModel.fetchRelations()

    iconSetup(category: category)

    contentViewSetup(category: category)
  }

  private func iconSetup(category relation: Category) {
    relation.getImage { [weak self] image in
      self?.iconView.setIcon(
        isCropped: relation.isCustom,
        image: image,
        bgColor: relation.getColor(),
        borderWidth: 3,
        borderColor: .white,
        tintColor: .white)
    }

    iconBackground.backgroundColor = relation.getColor()
  }

  // MARK: Content set up
  private func contentViewSetup(category relation: Category) {
    contentView.addSubview(scrollView)

    scrollView.addConstarint(
      top: contentView.topAnchor,
      left: contentView.leftAnchor,
      bottom: contentView.bottomAnchor,
      right: contentView.rightAnchor)

    view.layoutIfNeeded()

    eventTableView.separatorColor = .clear
    eventTableView.backgroundColor = .background
    profileTableView.separatorColor = .clear
    profileTableView.backgroundColor = .background

    eventTableView.delegate = self
    eventTableView.dataSource = self
    profileTableView.delegate = self
    profileTableView.dataSource = self
    scrollView.delegate = self

    scrollViewAddSubPaging(views: [eventTableView, profileTableView])
  }

  private func scrollViewAddSubPaging<T: UIView>(views: [T]) {
    let width = contentView.frame.width
    let height = contentView.frame.height - 200
    var x: CGFloat = 0

    for index in 0..<views.count {
      scrollView.addSubview(views[index])

      views[index].frame.origin = CGPoint(x: x, y: 0)
      views[index].frame.size = CGSize(width: width, height: height)

      x = views[index].frame.origin.x + width
    }

    scrollView.contentSize = CGSize(width: x, height: height)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)

    navigationController?.backToRoot()
  }
}

// MARK: - Selection bar Delegate
extension RelationDetailViewController: SelectionViewDelegate, SelectionViewDatasource, UIScrollViewDelegate {
  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? {
    .button
  }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor {
    .button
  }

  func numberOfButton(_ selectionView: SelectionView) -> Int {
    2
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    let buttonTitle = ["事件", "個人資訊"]

    return buttonTitle[index]
  }

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
      self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(index)

      self.view.layoutIfNeeded()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else { return }

    let paging: CGFloat = scrollView.contentOffset.x / scrollView.frame.width

    selectionBar.moveIndicatorToIndex(index: Int(paging))
  }
}

extension RelationDetailViewController {
  private func getFeatureSourtedByType(_ relation: Relation, _ user: User) -> [[Feature]] {
    var sortedRelation: [Int: [Feature]] = [:]

    relation.feature.forEach { feature in
      let filterIndex = user.getCategoriesWithSuperIndex(mainType: .feature).first { $0.id == feature.categoryIndex }!

      if sortedRelation.keys.contains(filterIndex.superIndex) {
//        if sortedRelation[filterIndex.superIndex]!.contains(where: { data in
//          data.contents[0].text != feature.contents[0].text
//        }) {
//          sortedRelation[filterIndex.superIndex]!.append(feature)
//        }
        sortedRelation[filterIndex.superIndex]!.append(feature)
      } else {
        sortedRelation[filterIndex.superIndex] = [feature]
      }
    }

    return sortedRelation.map { return $0.value }
  }
}

// MARK: - TableView Delegate
extension RelationDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    switch TableType(rawValue: tableView.tag) {

    case .event:
      let number = eventsSorted.count

      if number == 0 {
        tableView.addPlaceholder(
          image: UIImage.getPlaceholder(.event, style: traitCollection.userInterfaceStyle), description: "沒有互動紀錄")
      } else { tableView.removePlaceholder() }

      return number

    case .profile:
      if let relation = relation,
         !relation.feature.isEmpty,
         let user = userViewModel.user.value {
        tableView.removePlaceholder()

        sortedRelationList = getFeatureSourtedByType(relation, user)

        return sortedRelationList.count
      }

      tableView.addPlaceholder(
        image: UIImage.getPlaceholder(
          .profile,
          style: traitCollection.userInterfaceStyle),
        description: "未記錄個人特徵資訊")
      return 0

    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch TableType(rawValue: tableView.tag) {
    case .event:

      return eventsSorted[section].value.count

    case .profile:

      return sortedRelationList[section].count

    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch TableType(rawValue: tableView.tag) {
    case .event:
      let header = RelationTableHeaderCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))

      header.tagTitleLabel.text = eventsSorted[section].key.getDayString(type: .day)

      return header

    case.profile:

      guard let relation = relation,
            let user = userViewModel.user.value else { return nil }

      let filter = user.getFilter(type: .feature)

      let feature = relation.feature[section]
      let category = user.getCategoriesWithSuperIndex(mainType: .feature).filter { $0.id == feature.categoryIndex }[0]

      let header = RelationTableHeaderCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

      header.tagTitleLabel.text = filter[category.superIndex]

      return header

    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch TableType(rawValue: tableView.tag) {
    case .event:
      let events = eventsSorted.sorted { $0.key > $1.key }

      let event = events[indexPath.section].value[indexPath.row]

      let cell = tableView.dequeueReusableCell(
        withIdentifier: String(describing: LobbyEventCell.self),
        for: indexPath)

      if let cell = cell as? LobbyEventCell,
         let category = relationCategory {
        cell.cellSetup(type: .relation, event: event, relations: [category])
      }

      return cell

    case .profile:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: String(describing: RelationProfileCell.self),
        for: indexPath)

      guard relation != nil else { return cell }

      if let cell = cell as? RelationProfileCell {
        cell.setup(
          feature: sortedRelationList[indexPath.section][indexPath.row],
          index: 0)
      }

      return cell

    case .none:
      return UITableViewCell()
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }

    cell.isSelected = false

    switch TableType(rawValue: tableView.tag) {
    case .event:

      guard let category = relationCategory else { return }

      let event = eventsSorted[indexPath.section].value[indexPath.row]

      let detailVC = EventDetailView()
      detailVC.delegate = self

      let blueView = view.addBlurView()
      view.addSubview(detailVC)

      detailVC.addConstarint(
        left: view.leftAnchor,
        right: view.rightAnchor,
        centerY: view.centerYAnchor,
        paddingLeft: 16,
        paddingRight: 16,
        height: view.frame.height / 1.5)

      detailVC.cornerRadius = detailVC.frame.width * 0.05

      view.layoutIfNeeded()

      detailVC.setUp(event: event, relations: [category])

      detailVC.onDismiss = {
        blueView.removeFromSuperview()
      }
    default:
      break
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
}

extension RelationDetailViewController: EventDetailDelegate {
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
