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
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = true
    return scrollView
  }()

  let eventTableView: UITableView = {

    let eventTableView = UITableView()

    eventTableView.tag = TableType.event.rawValue
    eventTableView.backgroundColor = .secondarySystemBackground
    eventTableView.separatorColor = .clear

    eventTableView.lk_registerCellWithNib(
      identifier: String(describing: LobbyEventCell.self),
      bundle: nil)
    eventTableView.lk_registerHeaderWithNib(
      identifier: String(describing: RelationTableCell.self),
      bundle: nil)

    return eventTableView
  }()

  let profileTableView: UITableView = {

    let profileTableView = UITableView()

    profileTableView.tag = TableType.event.rawValue
    profileTableView.backgroundColor = .secondarySystemBackground
    profileTableView.separatorColor = .clear


    return profileTableView
  }()

  let relationViewModel = RelationViewModel()
  let eventViewModel = EventViewModel()

  var relation: Category?
  var events = [Event]() {
    didSet {
      eventTableView.reloadData()
    }
  }

  override func viewDidLoad() {

    eventViewModel.events.bind { [weak self] events in
      guard let relation = self?.relation else { return }
      self?.events = events.filter { $0.relations.contains(relation.id)}
    }

    eventViewModel.fetchEvents()

    super.viewDidLoad()

    guard let relation = relation else { dismiss(animated: true); return }

    view.layoutIfNeeded()

    iconSetup(category: relation)
    contentViewSetup(category: relation)

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

    let events = eventViewModel.fetchEventIn(relation: relation)

    setPlaceholder(isHidden: events.count > 0)

    contentView.addSubview(scrollView)

    scrollView.addConstarint(
      top: contentView.topAnchor, left: contentView.leftAnchor,
      bottom: contentView.bottomAnchor, right: contentView.rightAnchor)

    view.layoutIfNeeded()

    eventTableView.delegate = self
    eventTableView.dataSource = self
    profileTableView.delegate = self
    profileTableView.dataSource = self

    scrollViewAddSubPaging(views: [eventTableView, profileTableView])

  }

  private func scrollViewAddSubPaging<T: UIView>(views: [T]) {

    let width = scrollView.frame.width
    let height = scrollView.frame.height
    var x: CGFloat = 0

    for index in 0..<views.count {
      scrollView.addSubview(views[index])
      views[index].frame.origin = CGPoint(x: x, y: 0)
      views[index].frame.size = CGSize(width: width, height: height)

      x = views[index].frame.origin.x + width
    }

    scrollView.contentSize = CGSize(width: x, height: height)
  }

  // MARK: Placeholder
  private func setPlaceholder(isHidden: Bool) {

  }
}

// MARK: - Selection bar Delegate
extension RelationDetailViewController: SelectionViewDelegate, SelectionViewDatasource {

  func numberOfButton(_ selectionView: SelectionView) -> Int {
    2
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    let buttonTitle = ["事件", "個人資訊"]
    return buttonTitle[index]
  }

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

  }
}

// MARK: - TableView Delegate
extension RelationDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {

    switch TableType(rawValue: tableView.tag) {
    case .event:
      guard let relation = relation else { return 0 }
      return eventViewModel.fetchEventIn(relation: relation).count
    case .profile:
      return 0
    case .none:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch TableType(rawValue: tableView.tag) {
    case .event:
      return 0
    case .profile:
      return 0
    case .none:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch TableType(rawValue: tableView.tag) {
    case .event:
      return UITableViewCell()
    case .profile:
      return  UITableViewCell()
    case .none:
      return UITableViewCell()
    }
  }

}
