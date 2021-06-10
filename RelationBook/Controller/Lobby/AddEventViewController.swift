//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/9.
//

import UIKit
import AMPopTip
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

  // MARK: Initial information
  let commentPlaceholder = "備註"
  let commentPlaceholderColor: UIColor = .secondaryLabel

  let selectedColor: UIColor = .button

  let lottieView = LottieWrapper()

  let popTip = PopTip()
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

      LKProgressHUD.showFailure(text: "請選擇事件類別")
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
