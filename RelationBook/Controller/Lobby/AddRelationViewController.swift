//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/9.
//

import UIKit
import AMPopTip
import Firebase

class AddRelationViewController: UIViewController {

  @IBOutlet var searchTextField: UITextField! {
    didSet {
      searchTextField.delegate = self
      searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
      searchTextField.layer.masksToBounds = true
      searchTextField.layer.borderWidth = 1
    }
  }

  @IBOutlet var filterView: FilterView!

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

  let popTip = PopTip()
  let userViewModel = UserViewModel()
  let eventViewModel = EventViewModel()
  let selectEventView: SelectEventViewController = {
    let vc = UIStoryboard.lobby.instantiateViewController(identifier: "selectEvent")

    vc.view.isHidden = true
    return vc as! SelectEventViewController
  }()

  // MARK: Event datas.
  var mood: Category?
  var event: Category?
  var location: GeoPoint?
  var locationName: String?
  var time: Timestamp?
  var subEvents: [SubEvent] = []

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let controller = segue.destination as? SelectEventViewController {
      controller.onSelected = { category in
        print(category)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.layoutIfNeeded()

    filterView.setUp(type: .relation)
    filterView.onSelected = { categories in
      print(categories)
    }

    view.addSubview(selectEventView.view)

    NSLayoutConstraint.activate([
      selectEventView.view.topAnchor.constraint(equalTo: view.topAnchor),
      selectEventView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      selectEventView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      selectEventView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    selectEventView.onSelected = { event in
      self.event = event
      self.selectEventView.onDismiss?()
    }
    selectEventView.onDismiss = {
      self.selectEventView.view.isHidden = true
    }

    let suggestEvent = eventViewModel.mockEvent
    suggestEvent.mood.getImage { image in
      self.moodButton.setImage(image, for: .normal)
    }

    moodButton.backgroundColor = suggestEvent.mood.getColor()
  }

  @IBAction func confirm(_ sender: UIButton) {
    print("confirm")
    filterView.reloadDate()
  }

  @IBAction func close(_ sender: UIButton) {
    dismiss(animated: true)
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
    selectEventView.view.isHidden = false
  }
}

extension AddRelationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    UICollectionViewCell()
  }
}

extension AddRelationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}

extension AddRelationViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print(textField.text!)
  }
}
