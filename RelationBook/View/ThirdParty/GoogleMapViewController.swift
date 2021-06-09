//
//  GoogleMapViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/19.
//

import UIKit
import GoogleMaps

protocol GoogleMapViewDelegate: AnyObject {
  func didSelectAt(location: CLLocationCoordinate2D)
}

class GoogleMapView: UIView {

  var currentLocation: CLLocationCoordinate2D?

  var mapView: GMSMapView? {
    didSet {
      guard let mapView = mapView else { return }
      mapView.settings.zoomGestures = false
      mapView.delegate = self
      mapView.settings.setAllGesturesEnabled(false)
    }
  }

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

  func getLocation() -> CLLocationCoordinate2D? {
    guard let mapView = mapView else { return nil }
    return mapView.myLocation?.coordinate
  }

  private func addMarker(title: String, snippet: String, position: CLLocationCoordinate2D) {

    let marker = GMSMarker(position: position)
    marker.title = title
    marker.snippet = snippet
    marker.map = mapView
  }

  func centerLocation(center: CLLocationCoordinate2D? = nil) {
    guard let mapView = mapView else { return }

    let location = center ?? currentLocation

    guard let location = location else { return }

    let target = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 16.0)
  }
}

extension GoogleMapView: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    guard let location = locations.last else { return }

    addMarker(title: "幫前位置", snippet: "我", position: location.coordinate)

    currentLocation = location.coordinate

    locationManager.stopUpdatingLocation()

    centerLocation(center: location.coordinate)
  }
}

extension GoogleMapView: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    centerLocation(center: marker.position)
    return true
  }
}
