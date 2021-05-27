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

  @IBOutlet var filterView: FilterView!
  @IBOutlet var filterHeightConstraint: NSLayoutConstraint!

  // MARK: Buttons.
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
    }
  }
  @IBOutlet var moodButton: UIButton!
  @IBOutlet var eventButton: UIButton!
  @IBOutlet var locationButton: UIButton!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var dayButton: UIButton!
  @IBOutlet var timeButton: UIButton!

  let popTip = PopTip()
  var userViewModel = UserViewModel.shared
  var eventViewModel = EventViewModel.shared
  let selectFloatViewController: SelectFloatViewController = {
    let vc = UIStoryboard.lobby.instantiateViewController(identifier: "selectEvent") as! SelectFloatViewController

    return vc
  }()

  let addCategoryViewController: AddCategoryViewController = {
    let vc = UIStoryboard.lobby.instantiateViewController(identifier: "addCategory") as! AddCategoryViewController

    return vc
  }()

  // MARK: New Categoty data.
  var newCategotySetting: (type: CategoryType, hierarchy:  CategoryHierarchy, superIndex: Int)?

  // MARK: Event datas.
  var relations: [Category] = []
  var mood = 2
  var event: Category?
  var location: GeoPoint?
  var locationName: String?
  var date = Date() {
    didSet {
      dayButton.setTitle(date.getDayString(type: .day), for: .normal)
      timeButton.setTitle(date.getDayString(type: .time), for: .normal)
    }
  }
  var subEvents: [SubEvent] = []

  override func viewDidLoad() {

    super.viewDidLoad()
    
    addCategoryViewController.delegate = self

    date = Date()

    relationFilterSetup()
    selectionViewSetup()
    addCategoryViewSetup()
  }

  private func relationFilterSetup() {
    view.layoutIfNeeded()
    filterView.setUp(type: .relation)
    filterView.onSelected = { categories in
      self.relations = categories
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        self.filterHeightConstraint.constant /= 2
        self.view.layoutIfNeeded()
      }
    }

    filterView.onStartEdit = {
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        self.filterHeightConstraint.constant *= 2
        self.view.layoutIfNeeded()
      }
    }

    filterView.onAddCategory = { type, hierarchy, superIndex in

      self.newCategotySetting = (type, hierarchy, superIndex)

      switch type {
      case .event, .feature:
        self.addCategoryViewController.isVisable = true
      case .relation:
        if hierarchy == .main {
          self.addCategoryViewController.isVisable = true
        } else {
          let vc = UIStoryboard.lobby.instantiateViewController(identifier: "addRelation") as! AddContactFlowViewController
          self.view.addSubview(vc.view)
          vc.isVisable = true
        }
      }
    }
  }

  private func selectionViewSetup() {

    view.addSubview(selectFloatViewController.view)

    selectFloatViewController.view.addConstarint(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    selectFloatViewController.onEventSelected = { event in
      self.event = event
      self.eventButton.setTitle(event.title, for: .normal)
    }

    selectFloatViewController.onDateSelected = { type, date in
      switch type {
      case .time, .day:
        self.date = date
      default:
        return
      }
    }

    selectFloatViewController.onLocationSelected = { geoPoint in
      self.location = geoPoint
      self.locationName = "當前位置"
    }

    selectFloatViewController.onAddCategorySelected = { type, hierarchy, superIndex in
      switch type {
      case .event, .feature:
        self.addCategoryViewController.isVisable = true
        self.newCategotySetting = (type, hierarchy, superIndex)
      case .relation:
        break
      }
    }
  }

  private func addCategoryViewSetup() {

    view.addSubview(addCategoryViewController.view)

    addCategoryViewController.view.addConstarint(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    addCategoryViewController.onIconCreated = { category in

    }
  }

  @IBAction func confirm(_ sender: UIButton) {
    print("confirm")
    guard let event = event,
          let location = location,
          let locationName = locationName else { return }
    guard let userID = userViewModel.user.value?.docId else { return }
    var newEvent = Event(docID: "",
                         owner: userID,
                         relations: [0],
                         mood: mood,
                         event: event,
                         location: location,
                         locationName: locationName,
                         time: Timestamp(date: date),
                         subEvents: subEvents)
    eventViewModel.addEvent(event: newEvent) { result in
      switch result {
      case .success(let docID):
        newEvent.docID = docID
        self.dismiss(animated: true)
      case .failure(let error):
        print(error)
      }
    }
  }

  @IBAction func close(_ sender: UIButton) {
    dismiss(animated: true)
  }

  @IBAction func showLocation(_ sender: UIButton) {

    selectFloatViewController.display(type: .location)
  }

  @IBAction func showChangeMood(_ sender: UIButton) {

    let popChangeMood = PopMoodSelectView(frame: CGRect(x: 0, y: 0, width: 232, height: 40))

    popChangeMood.onSelected = { [weak self] (image, color) in
      self?.moodButton.setImage(image, for: .normal)
      self?.moodButton.backgroundColor = color
    }

    popTip.show(customView: popChangeMood, direction: .up, in: view, from: view.convert(moodButton.frame, from: moodButton.superview!))
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
}

extension AddEventViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}

extension AddEventViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print(textField.text!)
  }
}

extension AddEventViewController: AddCategoryViewDelegate {

  func typeOfCategory(controller: AddCategoryViewController) -> CategoryType? {
    guard let setting = newCategotySetting else { return nil }
    return setting.type
  }

  func superIndexOfCategory(controller: AddCategoryViewController) -> Int {
    guard let setting = newCategotySetting else { return -1 }
    return setting.superIndex
  }

  func hierarchyOfCategory(controller: AddCategoryViewController) -> CategoryHierarchy? {
    guard let setting = newCategotySetting else { return nil }
    return setting.hierarchy
  }
}