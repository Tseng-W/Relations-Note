//
//  SelectEventViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit
import GoogleMaps
import Firebase

class SelectFloatViewController: FloatingViewController {

  enum SelectType: String {
    case event = "事件"
    case day = "日期"
    case time = "時間"
    case location = "地點"
  }

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var datePicker: UIDatePicker!
  @IBOutlet var filterView: FilterView!
  @IBOutlet var mapView: GoogleMapView! {
    didSet {
      mapView.delegate = self
    }
  }
  @IBOutlet var resetButton: UIButton! {
    didSet {
      resetButton.addTarget(self, action: #selector(onResetButtonTapped(sender:)), for: .touchUpInside)
    }
  }
  @IBOutlet var cancelButton: UIButton!
  @IBOutlet var confirmButton: UIButton!

  var onEventSelected: ((Category) -> Void)?
  var onDateSelected: ((SelectType, Date) -> Void)?
  var onLocationSelected: ((GeoPoint) -> Void)?
  var onAddCategorySelected: ((CategoryType, CategoryHierarchy, Int) -> Void)?

  var userViewModel = UserViewModel.shared

  var dateDate = Date()

  var type: SelectType = .event {
    didSet {
      titleLabel.text = type.rawValue
      datePicker.isHidden = true
      filterView.isHidden = true
      mapView.isHidden = true
      resetButton.isHidden = true
      cancelButton.superview!.isHidden = true

      switch type {
      case .event:
        filterView.isHidden = false
      case .day, .time :
        resetButton.isHidden = false
        datePicker.isHidden = false
        cancelButton.superview!.isHidden = false

        if type == .day {
          resetButton.setTitle("今天", for: .normal)
          datePicker.datePickerMode = .date
        } else {
          resetButton.setTitle("現在", for: .normal)
          datePicker.datePickerMode = .time
        }
      case .location:
        titleLabel.text = "AppWorksSchool"
        resetButton.isHidden = false
        cancelButton.superview!.isHidden = false
        mapView.isHidden = false
        resetButton.setTitle("當前", for: .normal)
      }
    }
  }

  func display(type: SelectType) {
    self.type = type
    isVisable = true
  }

  override func viewDidLoad() {

    super.viewDidLoad()

    googleMapSetup()

    filterView.setUp(type: .event)
    filterView.canScrollBeHidden = false

    filterView.onSelected = { categories in
      self.onEventSelected?(categories.last!)
      self.isVisable = false
    }

    filterView.onAddCategory = { type, hierarchy, superIndex in
      self.onAddCategorySelected?(type, hierarchy, superIndex)
    }
    setBlurBackground()
  }

  private func googleMapSetup() {
    GMSServices.provideAPIKey(Bundle.valueForString(key: "Google map api key"))
  }

  @objc private func onResetButtonTapped(sender: UIButton) {
    switch type {
    case .time, .day:
      dateDate = Date()
      datePicker.setDate(dateDate, animated: true)
    case .location:
      break
    default:
      return
    }
  }

  @IBAction func onConfirmButtonTapped(_ sender: UIButton) {
    if sender == confirmButton {
      switch type {
      case .day, .time:
        print(datePicker.date)
        dateDate = datePicker.date
        onDateSelected?(type, datePicker.date)
      case .location:
        if let c2d = mapView.getLocation() {
          let gp = GeoPoint(latitude: c2d.latitude, longitude: c2d.longitude)
          onLocationSelected?(gp)
        }
      default:
        break
      }
    }
    isVisable = false
  }
}

extension SelectFloatViewController: GoogleMapViewDelegate {

  func didSelectAt(location: CLLocationCoordinate2D) {

  }
}
