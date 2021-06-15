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
        titleLabel.text = "互動地點"
        resetButton.isHidden = false
        cancelButton.superview!.isHidden = false
        mapView.isHidden = false
        resetButton.setTitle("現在位置", for: .normal)
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

    filterView.setUp(type: .event)
    googleMapSetup()

    filterView.canScrollBeHidden = false

    filterView.onSelected = { categories in
      self.onEventSelected?(categories.last!)
      self.isVisable = false
    }

    filterView.onAddCategory = { [weak self] type, hierarchy, superIndex in
      self?.onAddCategorySelected?(type, hierarchy, superIndex)
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

          let gp = GeoPoint(latitude: info.location.latitude,
                            longitude: info.location.longitude)
          onLocationSelected?(gp, info.name)
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

    let visibleRegion = mapView.mapView!.projection.visibleRegion()
    let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

    let autocompleteController = GMSAutocompleteViewController()

    autocompleteController.delegate = self

    let fields: GMSPlaceField = GMSPlaceField(
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

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
