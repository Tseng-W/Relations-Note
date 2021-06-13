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
      searchTextField.delegate = self
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

  // MARK: Buttons.
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
  @IBOutlet var relationHeader: RelationTableHeaderCell!
  @IBOutlet var detailHeader: RelationTableHeaderCell!
  @IBOutlet var featureHeader: RelationTableHeaderCell!

  // MARK: Initial information
  let commentPlaceholder = "備註"
  let commentPlaceholderColor: UIColor = .secondaryLabel

  let selectedColor: UIColor = .button

  let lottieView = LottieWrapper()

  var userViewModel = UserViewModel()
  var eventViewModel = EventViewModel()
  let featureViewModel = FeatureViewModel()
  let relationViewModel = RelationViewModel()

  var relations = [Relation]()

  let selectFloatViewController: SelectFloatViewController = {
    let vc = UIStoryboard.lobby.instantiateViewController(identifier: "selectEvent") as! SelectFloatViewController

    return vc
  }()
  let setCategoryView = SetCategoryStyleView()

  // MARK: Event datas initial.
  var relationCategories: [Category] = []
  var imageLink: String?
  var mood = 2
  var event: Category? {
    didSet {
      if let event = event {
        eventButton.titleLabel?.textColor = .button
        eventButton.setTitle(event.title, for: .normal)
      } else {
        eventButton.titleLabel?.textColor = .buttonDisable
        eventButton.setTitle("事件", for: .normal)
      }
    }
  }
  var location: GeoPoint? {
    didSet {
      if location != nil {
        locationButton.titleLabel?.textColor = .button
      } else {
        locationButton.titleLabel?.textColor = .buttonDisable
      }
    }
  }
  var locationName: String? {
    didSet {
      if let name = locationName {
        locationButton.setTitle(name, for: .normal)
        locationButton.titleLabel?.textColor = .button
      } else {
        locationButton.setTitle("地點", for: .normal)
        locationButton.titleLabel?.textColor = .buttonDisable
      }
    }
  }
  var date = Date() {
    didSet {
      dayButton.setTitle(date.getDayString(type: .day), for: .normal)
      timeButton.setTitle(date.getDayString(type: .time), for: .normal)
    }
  }
  var subEvents: [SubEvent] = []

  var features = [Feature]()

  override func viewDidLoad() {

    super.viewDidLoad()

    userViewModel.user.bind { [weak self] user in
      guard let _ = user else { return }
      self?.filterView.setUp(type: .relation)
    }

    relationViewModel.relations.bind { [weak self] relations in
      self?.relations = relations
    }

    featureTableView.separatorColor = .clear

    setCategoryView.delegate = self

    userViewModel.fetchUserDate()
    relationViewModel.fetchRelations()

    relationFilterSetup()
    selectionViewSetup()

    date = Date()
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
        .addPopTip(at: self.featureHeader, text: "這次互動中你更了解了對方？", direction: .up, attributes: PopTipManager.Style.defaultStyle)
        .addPopTip(at: self.featureTableView, text: "點擊此處新增對方的特徵！", direction: .up, attributes: PopTipManager.Style.defaultStyle)
        .addPopTip(at: self.featureTableView, text: "例如個人資料、興趣喜好或紀念人！", direction: .up, attributes: PopTipManager.Style.defaultStyle)
        .addPopTip(at: self.featureTableView, text: "之後可在關係詳情中查看，避免忘記趕快添加吧！", direction: .up, attributes: PopTipManager.Style.defaultStyle)
        .show()
    }

    LKProgressHUD.dismiss()
  }

  private func relationFilterSetup() {

    view.layoutIfNeeded()

    filterView.onSelected = { categories in
      self.relationCategories = categories
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        self.filterHeightConstraint.constant /= 2.66
        self.view.layoutIfNeeded()
      }
    }

    filterView.onStartEdit = {
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        self.filterHeightConstraint.constant *= 2.66
        self.view.layoutIfNeeded()
      }
    }

    filterView.onAddCategory = { type, hierarchy, superIndex in

      self.setCategoryView.show(
        self.view,
        type: type, hierarchy: hierarchy, superIndex: superIndex)
    }
  }

  private func selectionViewSetup() {

    view.addSubview(selectFloatViewController.view)

    selectFloatViewController.view.addConstarint(
      top: view.topAnchor, left: view.leftAnchor,
      bottom: view.bottomAnchor, right: view.rightAnchor)

    selectFloatViewController.onEventSelected = { event in
      self.event = event
    }

    selectFloatViewController.onDateSelected = { type, date in
      switch type {
      case .time, .day:
        self.date = date
      default:
        return
      }
    }

    selectFloatViewController.onLocationSelected = { geoPoint, name in
      self.location = geoPoint
      self.locationName = name
    }

    selectFloatViewController.onAddCategorySelected = { type, hierarchy, superIndex in

      self.setCategoryView.show(self.view, type: type, hierarchy: hierarchy, superIndex: superIndex)
    }
  }

  // MARK: - IBOutlets

  @IBAction func confirm(_ sender: UIButton) {

    guard let event = event else {
      PopTipManager.shared
        .addPopTip(at: eventButton, text: "請選擇互動事件類型", direction: .up, duration: 3, attributes: PopTipManager.Style.alertStyle)
        .show(isBlur: false)
      return
    }

    guard relationCategories.count > 0 else {
      PopTipManager.shared
        .addPopTip(at: filterView, text: "請選擇互動對象", direction: .up, duration: 3, attributes: PopTipManager.Style.alertStyle)
        .show(isBlur: false)

      return
    }

    guard let userID = userViewModel.user.value?.uid else { return }

    let comment: String = commentTextView.text == "備註" ? .empty : commentTextView.text

    var newEvent = Event(docID: "",
                         owner: userID,
                         relations: relationCategories.map { $0.id },
                         imageLink: imageLink ?? nil,
                         mood: mood,
                         category: event,
                         location: location,
                         locationName: locationName,
                         time: Timestamp(date: date),
                         subEvents: subEvents,
                         comment: comment)

    eventViewModel.addEvent(event: newEvent) { result in
      switch result {
      case .success(let docID):
        newEvent.docID = docID

      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }

    if features.count > 0 {

      guard let relation = relations.first(where: { $0.categoryIndex == relationCategories[0].id }) else { return }

      self.featureViewModel.addFeatures(relation: relation, features: self.features)
    }
    self.dismiss(animated: true)
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
      left: view.leftAnchor, right: view.rightAnchor,
      centerY: view.centerYAnchor,
      paddingLeft: 16, paddingRight: 16,
      height: 200)

    moodSelectView.onSelected = { [weak self] (index, image, color) in
      self?.mood = index
      self?.moodButton.setImage(image, for: .normal)
      self?.moodButton.backgroundColor = color
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
    let provider = SCLAlertViewProvider(rect: self)

    provider.showAlert(type: .rectImage)
  }

  
}

extension AddEventViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print(textField.text!)
  }
}

// MARK: SCLAlert wrapper delegate
extension AddEventViewController: SCLAlertViewProviderDelegate {

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {

    imageButton.setImage(image, for: .normal)

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.imageLink = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}

// MARK: Add category delegate
extension AddEventViewController: CategoryStyleViewDelegate {

  func categoryStyleView(
    styleView: SetCategoryStyleView,
    isCropped: Bool, name: String,
    backgroundColor: UIColor,
    image: UIImage, imageString: String) {
  }

  func iconType(styleView: SetCategoryStyleView) -> CategoryType? {
    .relation
  }
}

// MARK: TextFiled Delegate
extension AddEventViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == commentPlaceholderColor {
      textView.text = nil
      textView.textColor = selectedColor
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = commentPlaceholder
      textView.textColor = commentPlaceholderColor
    }
  }
}

extension AddEventViewController: AddFeatureTableViewDelegate {

  func featureTableView(tableView: AddFeatureTableView, features: [Feature]) {
    self.features = features
  }
}
