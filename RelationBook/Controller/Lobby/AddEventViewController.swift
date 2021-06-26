//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/9.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController {
  @IBOutlet var searchTextField: UITextField! {
    didSet {
//      searchTextField.delegate = self
      searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
      searchTextField.layer.masksToBounds = true
      searchTextField.layer.borderWidth = 1
    }
  }
  @IBOutlet var searchTextFieldHeight: NSLayoutConstraint! {
    didSet {
      searchTextFieldHeight.constant = 0
    }
  }

  @IBOutlet var filterView: FilterView!
  @IBOutlet var filterHeightConstraint: NSLayoutConstraint!

  // MARK: Buttons and tableView
  @IBOutlet var featureTableView: AddFeatureTableView! {
    didSet {
      featureTableView.featureDelagate = self
    }
  }
  @IBOutlet var moodButton: UIButton!
  @IBOutlet var eventButton: UIButton!
  @IBOutlet var locationButton: UIButton!
  @IBOutlet var imageButton: UIButton!
  @IBOutlet var dayButton: UIButton!
  @IBOutlet var timeButton: UIButton!
  @IBOutlet var commentTextView: UITextView! {
    didSet {
      commentTextView.delegate = self
    }
  }

  // MARK: Headers ( With tip button )
  @IBOutlet var relationHeader: RelationTableHeaderCell!
  @IBOutlet var detailHeader: RelationTableHeaderCell!
  @IBOutlet var featureHeader: RelationTableHeaderCell!

  // MARK: Initial information
  var isEditingEvent = false
  var event = Event.getEmptyEvent() {
    didSet {
      setButtonContent()
    }
  }

  let commentPlaceholder = "備註"
  let commentPlaceholderColor: UIColor = .secondaryLabel

  var userViewModel = UserViewModel()
  var eventViewModel = EventViewModel()
  let featureViewModel = FeatureViewModel()
  let relationViewModel = RelationViewModel()

  var relations: [Relation] = []

  let selectFloatViewController = UIStoryboard.lobby.instantiateViewController(identifier: "selectEvent")
    as! SelectFloatViewController
  let setCategoryView = SetCategoryStyleView()

  // MARK: Event datas initial.
  var relationCategory: Category?
  var features: [Feature] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    userViewModel.user.bind { [weak self] user in
      guard let user = user,
            let uid = user.uid else { return }

      self?.setButtonContent()

      self?.event.owner = uid
      self?.filterView.setUp(type: .relation)
    }

    filterView.delegate = self

    relationViewModel.relations.bind { [weak self] relations in
      self?.relations = relations
    }

    featureTableView.separatorColor = .clear

    userViewModel.fetchUserDate()
    relationViewModel.fetchRelations()

    selectionViewSetup()

    if isEditingEvent {
      event.time = Timestamp(date: Date())
//      didSelectedCategory(category: event.category)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    relationHeader.tips = {
      PopTipManager.shared
        .addPopTip(at: self.filterView, text: "在此處選擇互動的對象", direction: .up)
        .addPopTip(at: self.filterView, text: "可以點擊分類頁或滑動切換類型", direction: .up)
        .addPopTip(at: self.filterView, text: "新的關係人可在分類下點擊新增添加", direction: .down)
        .show()
    }

    detailHeader.tips = {
      PopTipManager.shared
        .addPopTip(at: self.detailHeader, text: "此處可設定事件的詳細資料", direction: .up)
        .addPopTip(at: self.eventButton, text: "選取事件的種類，諸如偶遇、會議或是聚會", direction: .up)
        .addPopTip(at: self.imageButton, text: "點擊新增事件照片，像是互動的現場或合照~", direction: .up)
        .addPopTip(at: self.moodButton, text: "這次互動心情如何？記錄你的情緒！", direction: .up)
        .addPopTip(at: self.locationButton, text: "按這裡可以紀錄碰面的地點~", direction: .left)
        .addPopTip(at: self.dayButton, text: "不是今天發生的？點這裡更改日期", direction: .down)
        .addPopTip(at: self.timeButton, text: "這裡可以更改時間喔~", direction: .down)
        .addPopTip(at: self.commentTextView, text: "容易遺忘的細節都可以記錄在此", direction: .up)
        .show()
    }

    featureHeader.tips = {
      PopTipManager.shared
        .addPopTip(at: self.featureHeader, text: "這次互動中你更了解了對方？", direction: .up)
        .addPopTip(at: self.featureTableView, text: "點擊此處新增對方的特徵！", direction: .up)
        .addPopTip(at: self.featureTableView, text: "例如個人資料、興趣喜好或紀念人！", direction: .up)
        .addPopTip(at: self.featureTableView, text: "之後可在關係詳情中查看，避免忘記趕快添加吧！", direction: .up)
        .show()
    }

    LKProgressHUD.dismiss()
  }

  private func selectionViewSetup() {
    view.addSubview(selectFloatViewController.view)
    selectFloatViewController.view.addConstarint(fill: view)

    selectFloatViewController.onEventSelected = { event in
      self.event.category = event
    }

    selectFloatViewController.onDateSelected = { type, date in
      switch type {
      case .time, .day:
        self.event.time = Timestamp(date: date)
      default:
        return
      }
    }

    selectFloatViewController.onLocationSelected = { geoPoint, name in
      self.event.location = geoPoint
      self.event.locationName = name
    }

    selectFloatViewController.onAddCategorySelected = { type, hierarchy, superIndex in
      self.setCategoryView.show(self.view, type: type, hierarchy: hierarchy, superIndex: superIndex)
    }
  }

  // MARK: - IBOutlets
  @IBAction func confirm(_ sender: UIButton) {
    guard event.category.isInitialed() else {
      PopTipManager.shared
        .addPopTip(at: eventButton, text: "請選擇互動事件類型", direction: .up, duration: 3, style: .normal)
        .show(isBlur: false)
      return
    }

    guard !event.relations.isEmpty else {
      PopTipManager.shared
        .addPopTip(at: filterView, text: "請選擇互動對象", direction: .up, duration: 3, style: .normal)
        .show(isBlur: false)

      return
    }

    guard event.isInitialed() else { return }

    let comment: String = commentTextView.text == "備註" ? .empty : commentTextView.text

    event.comment = comment

    if isEditingEvent {
      eventViewModel.updateEvent(event: event)
    } else {
      eventViewModel.addEvent(event: event) { result in
        switch result {
        case .success(let docId):
          self.event.docId = docId

        case .failure(let error):
          print("\(error.localizedDescription)")
        }
      }
    }

    if !features.isEmpty {
      guard let relation = relations.first(where: { $0.categoryIndex == event.relations[0] }) else { return }

      self.featureViewModel.addFeatures(relation: relation, features: self.features)
    }

    dismiss(animated: true)
  }

  @IBAction func close(_ sender: UIButton) {
    dismiss(animated: true)
  }

  @IBAction func showLocation(_ sender: UIButton) {
    selectFloatViewController.display(type: .location)
  }

  @IBAction func showChangeMood(_ sender: UIButton) {
    let moodSelectView = MoodSelectView()
    moodSelectView.cornerRadius = 16
    let blurView = view.addBlurView()
    view.addSubview(moodSelectView)

    moodSelectView.addConstarint(
      left: view.leftAnchor,
      right: view.rightAnchor,
      centerY: view.centerYAnchor,
      paddingLeft: 16,
      paddingRight: 16,
      height: 200)

    moodSelectView.onSelected = { [weak self] index, image, color in
      self?.event.mood = index
      blurView.removeFromSuperview()
    }
  }

  @IBAction func showSetEvent(_ sender: UIButton) {
    selectFloatViewController.display(type: .event)
  }

  @IBAction func showSetDatePicker(_ sender: UIButton) {
    if sender.tag == 0 {
      selectFloatViewController.display(type: .day)
    } else {
      selectFloatViewController.display(type: .time)
    }
  }

  @IBAction func setEventPicture(_ sender: UIButton) {
    let provider = SCLAlertViewProvider(rectImage: self)

    provider.showAlert(type: .rectImage)
  }
}

// MARK: - Private
extension AddEventViewController {
  private func setButtonContent() {
    guard eventButton != nil else { return }

    if event.category.isInitialed() {
      eventButton.titleLabel?.textColor = .button
      eventButton.setTitle(event.category.title, for: .normal)
    } else {
      eventButton.titleLabel?.textColor = .buttonDisable
      eventButton.setTitle("事件", for: .normal)
    }

    if event.location != nil {
      locationButton.titleLabel?.textColor = .button
    } else {
      locationButton.titleLabel?.textColor = .buttonDisable
    }

    if let name = event.locationName {
      locationButton.setTitle(name, for: .normal)
      locationButton.titleLabel?.textColor = .button
    } else {
      locationButton.setTitle("地點", for: .normal)
      locationButton.titleLabel?.textColor = .buttonDisable
    }

    dayButton.setTitle(event.time.dateValue().getDayString(type: .day), for: .normal)
    timeButton.setTitle(event.time.dateValue().getDayString(type: .time), for: .normal)

    if event.imageLink != .empty {
      UIImage.loadImage(event.imageLink) { image in
        self.imageButton.setImage(image, for: .normal)
      }
    }

    let moodDate = UserViewModel.moodData[event.mood]
    moodButton.setImage(moodDate.image, for: .normal)
    moodButton.backgroundColor = UIColor.UIColorFromString(string: moodDate.colorString)

    if event.comment == .empty {
      commentTextView.text = "備忘"
      commentTextView.textColor = commentPlaceholderColor
    } else {
      commentTextView.text = event.comment
      commentTextView.textColor = .button
    }
  }
}

// MARK: SCLAlert wrapper delegate
extension AddEventViewController: SCLAlertViewProviderDelegate {
  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {
    imageButton.setImage(image, for: .normal)

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.event.imageLink = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}

// MARK: TextFiled Delegate
extension AddEventViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == commentPlaceholderColor {
      textView.text = nil
      textView.textColor = .button
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    event.comment = textView.text
  }
}

extension AddEventViewController: AddFeatureTableViewDelegate {
  func featureTableView(tableView: AddFeatureTableView, features: [Feature]) {
    self.features = features
  }
}

extension AddEventViewController: CategorySelectionDelegate {
  func initialTarget() -> (mainCategory: Category, subCategory: Category)? {
    if let user = userViewModel.user.value,
       let subRelation = user.relationSet.sub.first(where: { event.relations.contains( $0.id ) }),
       let mainRelation = user.relationSet.main.first(where: { $0.id == subRelation.superIndex }) {
      return (mainRelation, subRelation)
    }
    return nil
  }

  func didSelectedCategory(category: Category) {
    event.relations = [category.id]
    relationCategory = category
    view.layoutIfNeeded()
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.filterHeightConstraint.constant /= 2.66
      self.view.layoutIfNeeded()
    }
  }

  func didStartEdit(pageIndex: Int) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.filterHeightConstraint.constant *= 2.66
      self.view.layoutIfNeeded()
    }
  }

  func addCategory(type: CategoryType, hierarchy: CategoryHierarchy, superIndex: Int, categoryColor: UIColor) {
    setCategoryView.show(
      self.view,
      type: type,
      hierarchy: hierarchy,
      superIndex: superIndex,
      initialColor: categoryColor)
  }
}
