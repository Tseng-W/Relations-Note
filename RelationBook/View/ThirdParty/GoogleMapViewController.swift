//
//  GoogleMapViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/19.
//

import UIKit
import GoogleMaps

protocol GoogleMapViewDelegate: AnyObject {
  func didSelectAt(location: CLLocationCoordinate2D, name: String)
}

class GoogleMapView: UIView {

  var currentLocation: CLLocationCoordinate2D?
  var currentName: String?

  var mapView: GMSMapView? {
    didSet {

      guard let mapView = mapView else { return }

      mapView.settings.zoomGestures = false
      mapView.delegate = self
      mapView.settings.setAllGesturesEnabled(false)
    }
  }
  var marker = GMSMarker()

  var locationManager = CLLocationManager()
  weak var delegate: GoogleMapViewDelegate? {
    didSet {

      locationManager.requestWhenInUseAuthorization()

      if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      }

      //      let mapId = GMSMapID(identifier: Bundle.valueForString(key: "Google map id"))

      mapView = GMSMapView(frame: frame)
      mapView?.isMyLocationEnabled = false

      addSubview(mapView!)

      mapView?.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)

      layoutIfNeeded()

      locationManager.startUpdatingLocation()
    }
  }

  private func addMarker(title: String, snippet: String, position: CLLocationCoordinate2D) {

    marker.map = nil

    marker = GMSMarker(position: position)
    marker.title = title
    marker.snippet = snippet
    marker.map = mapView
  }

  func centerLocation(center: CLLocationCoordinate2D? = nil, name: String? = nil) {
    guard let mapView = mapView else { return }

    if let center = center {
      currentLocation = center
    }

    if let name = name {
      currentName = name

      addMarker(title: name, snippet: .empty, position: (center ?? currentLocation)!)
    }

    let location = center ?? currentLocation

    guard let location = location else { return }

    let target = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

    mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 16.0)

    delegate?.didSelectAt(location: location, name: (name ?? currentName)!)
  }
}

extension GoogleMapView: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    guard let location = locations.last else { return }

    currentLocation = location.coordinate

    locationManager.stopUpdatingLocation()

    centerLocation(center: location.coordinate, name: "當前位置")
  }
}

extension GoogleMapView: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    centerLocation(center: marker.position)
    return true
  }
}
