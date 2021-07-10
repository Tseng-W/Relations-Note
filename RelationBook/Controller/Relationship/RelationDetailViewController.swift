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

  var relationCategory: Category?

  private var sortedFeatures: [(index: Int, features: [Feature])] = []

  private var scrollView = RBScrollView(isPagingEnabled: true)

  private let eventTableView: UITableView = {
    let eventTableView = UITableView()
    eventTableView.tag = TableType.event.rawValue
    eventTableView.estimatedRowHeight = 40

    eventTableView.registerCellWithNib(
      identifier: String(describing: LobbyEventCell.self),
      bundle: nil)
    eventTableView.registerHeaderWithNib(
      identifier: String(describing: RelationTableHeaderCell.self),
      bundle: nil)

    return eventTableView
  }()

  private let profileTableView: UITableView = {
    let profileTableView = UITableView()

    profileTableView.tag = TableType.profile.rawValue
    profileTableView.backgroundColor = .background
    profileTableView.registerHeaderWithNib(
      identifier: String(describing: RelationTableHeaderCell.self),
      bundle: nil)
    profileTableView.registerCellWithNib(
      identifier: String(describing: RelationProfileCell.self),
      bundle: nil)

    return profileTableView
  }()

  private let relationViewModel = RelationViewModel()
  private let eventViewModel = EventViewModel()
  private let userViewModel = UserViewModel()

  private var relation: Relation? {
    didSet {
      profileTableView.reloadData()
    }
  }

  private var events: [Event] = [] {
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
  private var eventsSorted: [Dictionary<Date, [Event]>.Element] = []
  private var editingEvent: Event?

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
        borderWidth: 2,
        borderColor: .white,
        tintColor: .white)
    }

    iconBackground.backgroundColor = relation.getColor()
  }

  // MARK: Content set up
  private func contentViewSetup(category relation: Category) {
    contentView.addSubview(scrollView)
    scrollView.addConstarint(fill: contentView)
    view.layoutIfNeeded()

    eventTableView.separatorColor = .clear
    eventTableView.backgroundColor = .background
    profileTableView.separatorColor = .clear
    profileTableView.backgroundColor = .background

    eventTableView.delegate = self
    eventTableView.dataSource = self
    profileTableView.delegate = self
    profileTableView.dataSource = self
    scrollView.delegate = selectionBar
    selectionBar.matchedScrollView = scrollView

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

    navigationController?.popToRootViewController(animated: true)
  }
}

extension RelationDetailViewController {
  func getFeatureSourtedByType(features: [Feature], categories: [Category]) -> [(index: Int, features: [Feature])] {
    var sortedFeatures: [Int: [Feature]] = [:]

    features.forEach { feature in
      if let category = categories.first(where: { $0.id == feature.categoryIndex }) {
        if var features = sortedFeatures[category.superIndex] {
          features.append(feature)
          sortedFeatures.updateValue(features, forKey: category.superIndex)
        } else {
          sortedFeatures[category.superIndex] = [feature]
        }
      } else {
        print("Unexpected feature index: \(feature) out of range.")
      }
    }

    return sortedFeatures.map { return ($0.key, $0.value) }.sorted { $0.index < $1.index }
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

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else { return }

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
          image: UIImage.getPlaceholder(.event, style: traitCollection.userInterfaceStyle), description: "沒有互動紀錄")
      } else { tableView.removePlaceholder() }

      return number

    case .profile:
      if let relation = relation,
         !relation.feature.isEmpty,
         let user = userViewModel.user.value {
        tableView.removePlaceholder()

        let featureCategories = user.getCategoriesWithSuperIndex(mainType: .feature)

        sortedFeatures = getFeatureSourtedByType(
          features: relation.feature,
          categories: featureCategories)

        return sortedFeatures.count
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
      guard section < sortedFeatures.count else { return 0 }

      return sortedFeatures[section].features.count
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
      guard let user = userViewModel.user.value else { return nil }

      let filter = user.getFilter(type: .feature)
      let header = RelationTableHeaderCell(
        frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

      header.tagTitleLabel.text = filter[sortedFeatures[section].index]

      return header

    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch TableType(rawValue: tableView.tag) {
    case .event:
      guard let cell = tableView.dequeueReusableCell(cell: LobbyEventCell.self, indexPath: indexPath),
            let category = relationCategory else {
        String.trackFailure("dequeueReusableCell failures")
        return LobbyEventCell()
      }

      let events = eventsSorted.sorted { $0.key > $1.key }

      let event = events[indexPath.section].value[indexPath.row]

      cell.cellSetup(type: .relation, event: event, relations: [category])

      return cell

    case .profile:
      guard let cell = tableView.dequeueReusableCell(cell: RelationProfileCell.self, indexPath: indexPath),
            relation != nil else {
        String.trackFailure("dequeueReusableCell failures")
        return RelationProfileCell()
      }

      guard relation != nil else { return cell }

      cell.setup(
        feature: sortedFeatures[indexPath.section].features[indexPath.row],
        index: 0)

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
      detailVC.show(view: self.view)
      detailVC.setUp(event: event, relations: [category])

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
