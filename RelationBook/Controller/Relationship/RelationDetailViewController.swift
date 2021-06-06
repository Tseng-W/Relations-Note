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
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var iconBackground: UIView!
  @IBOutlet var selectionBar: SelectionView! {
    didSet {
      selectionBar.type = .stack
      selectionBar.delegate = self
      selectionBar.datasource = self
    }
  }
  @IBOutlet var contentView: UIView!

  var scrollView: UIScrollView = {

    let scrollView = UIScrollView()

    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceVertical = false
    scrollView.alwaysBounceHorizontal = false
    scrollView.bounces = false
    scrollView.backgroundColor = .secondarySystemBackground

    return scrollView
  }()

  let eventTableView: UITableView = {

    let eventTableView = UITableView()

    eventTableView.tag = TableType.event.rawValue
    eventTableView.backgroundColor = .secondarySystemBackground
    eventTableView.estimatedRowHeight = 60

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
    profileTableView.backgroundColor = .secondarySystemBackground
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
      var eventPool = [Date: [Event]]()

      events.forEach { event in
        let eventDate = event.time.dateValue().midnight
        if eventPool[eventDate] != nil {
          eventPool[eventDate]!.append(event)
        } else {
          eventPool[eventDate] = [event]
        }
      }

      eventsSorted = eventPool.sorted { $0.key > $1.key }
      eventTableView.reloadData()
    }
  }
  var eventsSorted = [Dictionary<Date, [Event]>.Element]()

  override func viewDidLoad() {

    super.viewDidLoad()

    guard let category = relationCategory else { dismiss(animated: true); return }

    nameLabel.text = category.title

    eventViewModel.events.bind { [weak self] events in
      guard let relation = self?.relationCategory else { return }
      self?.events = events.filter { $0.relations.contains(relation.id)}
    }

    relationViewModel.relations.bind { [weak self] relations in
      self?.relation = relations.first(where: { $0.categoryIndex == self?.relationCategory?.id })
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
      top: contentView.topAnchor, left: contentView.leftAnchor,
      bottom: contentView.bottomAnchor, right: contentView.rightAnchor)

    view.layoutIfNeeded()

    eventTableView.separatorColor = .clear
    eventTableView.backgroundColor = .secondarySystemBackground
    profileTableView.separatorColor = .clear
    profileTableView.backgroundColor = .secondarySystemBackground

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
}

// MARK: - Selection bar Delegate
extension RelationDetailViewController: SelectionViewDelegate, SelectionViewDatasource, UIScrollViewDelegate {

  func numberOfButton(_ selectionView: SelectionView) -> Int {
    2
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {

    let buttonTitle = ["事件", "個人資訊"]

    return buttonTitle[index]
  }

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {

      self.scrollView.contentOffset.x =  self.scrollView.frame.width * CGFloat(index)

      self.view.layoutIfNeeded()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    let paging: CGFloat = scrollView.contentOffset.x / scrollView.frame.width

    selectionBar.moveIndicatorToIndex(index: Int(paging))
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
          image: UIImage.getPlaceholder(
            .event,
            style: traitCollection.userInterfaceStyle),
          description: "沒有互動紀錄")
      } else { tableView.removePlaceholder() }

      return number

    case .profile:

      if let relation = relation,
         relation.feature.count > 0 {
        tableView.removePlaceholder()
        return relation.feature.count
      }

      tableView.addPlaceholder(
        image: UIImage.getPlaceholder(
          .profile,
          style: traitCollection.userInterfaceStyle),
        description: "沒有互動紀錄")

      return 0

    case .none:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch TableType(rawValue: tableView.tag) {

    case .event:

      return eventsSorted[section].value.count

    case .profile:

      guard let relation = relation else { return 0 }
      return relation.feature[section].contents.count

    case .none:
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

      let header = RelationTableHeaderCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

      header.tagTitleLabel.text = filter[relation.feature[section].categoryIndex]

      return header

    case .none:
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

      if let cell = cell as? LobbyEventCell {
        cell.cellSetup(type: .relation, event: event, relations: [relationCategory!])
      }

      return cell

    case .profile:

      let cell = tableView.dequeueReusableCell(
        withIdentifier: String(describing: RelationProfileCell.self),
        for: indexPath)

      guard let relation = relation else { return cell }

      if let cell = cell as? RelationProfileCell {
        cell.setup(
          feature: relation.feature[indexPath.section],
          index: indexPath.row)
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
      let blueView = view.addBlurView()
      view.addSubview(detailVC)

      detailVC.addConstarint(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, paddingLeft: 16, paddingRight: 16, height: view.frame.height / 1.5)
      detailVC.cornerRadius = detailVC.frame.width * 0.05

      view.layoutIfNeeded()

      detailVC.setUp(event: event, relations: [category])

      detailVC.onDismiss = {
        blueView.removeFromSuperview()
      }
    case .profile:
      break

    case .none:
      break
    }
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
