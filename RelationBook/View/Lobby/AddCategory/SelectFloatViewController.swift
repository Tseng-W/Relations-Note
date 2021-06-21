//
//  SelectEventViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit
import GoogleMaps
import GooglePlaces
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

      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autocompleteClicked(tapGesture:)))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1

      mapView.addGestureRecognizer(tapGesture)
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
  var onLocationSelected: ((GeoPoint, String) -> Void)?
  var onAddCategorySelected: ((CategoryType, CategoryHierarchy, Int) -> Void)?

  var dateDate = Date()
  var type: SelectType = .event {
    didSet {
      guard let buttonView = cancelButton.superview else { return }
      titleLabel.text = type == .location ? "互動地點" : type.rawValue
      datePicker.datePickerMode = type == .day ? .date : .time

      filterView.isHidden = ![.event].contains { $0 == type }
      datePicker.isHidden = ![.day, .time].contains { $0 == type }
      resetButton.isHidden = ![.day, .time, .location].contains { $0 == type }
      buttonView.isHidden = ![.day, .time, .location].contains { $0 == type }
      mapView.isHidden = ![.location].contains { $0 == type }

      switch type {
      case .day:
        resetButton.setTitle("今天", for: .normal)
      case .time :
        resetButton.setTitle("現在", for: .normal)
      case .location:
        resetButton.setTitle("現在位置", for: .normal)
      default:
        break
      }
    }
  }
  var locationInfo: (location: CLLocationCoordinate2D, name: String)?

  func display(type: SelectType) {
    self.type = type
    isVisable = true

    mapView.centerLocation()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    filterView.delegate = self

    filterView.setUp(type: .event)
    googleMapSetup()

    filterView.canScrollBeHidden = false

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
      mapView.centerLocation()

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
        if let info = locationInfo {
          let geoPoint = GeoPoint(
            latitude: info.location.latitude,
            longitude: info.location.longitude)
          onLocationSelected?(geoPoint, info.name)
        }

      default:
        break
      }
    }
    isVisable = false
  }
}

// MARK: Google Map
extension SelectFloatViewController {
  @objc func autocompleteClicked(tapGesture: UITapGestureRecognizer) {
    guard let mapView = mapView.mapView else { return }

    let visibleRegion = mapView.projection.visibleRegion()
    let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

    let autocompleteController = GMSAutocompleteViewController()

    autocompleteController.delegate = self

    let fields = GMSPlaceField(
      rawValue:
        UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.coordinate.rawValue)
    )
    autocompleteController.placeFields = fields

    let filter = GMSAutocompleteFilter()
    filter.type = .noFilter
    filter.locationBias = GMSPlaceRectangularLocationOption(bounds.northEast, bounds.southWest)
    autocompleteController.autocompleteFilter = filter

    present(autocompleteController, animated: true, completion: nil)
  }
}

// MARK: Google Map & Custom Map View
extension SelectFloatViewController: GMSAutocompleteViewControllerDelegate, GoogleMapViewDelegate {
  func didSelectAt(location: CLLocationCoordinate2D, name: String) {
    locationInfo = (location, name)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    mapView.centerLocation(center: place.coordinate, name: place.name)

    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}

extension SelectFloatViewController: CategorySelectionDelegate {
  func didSelectedCategory(category: Category) {
    onEventSelected?(category)
    isVisable = false
  }

  func didStartEdit(pageIndex: Int) {
  }

  func addCategory(type: CategoryType, hierarchy: CategoryHierarchy, superIndex: Int) {
    onAddCategorySelected?(type, hierarchy, superIndex)
  }
}
