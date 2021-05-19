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

  var mapView: GMSMapView? {
    didSet {
      guard let mapView = mapView else { return }
      mapView.settings.zoomGestures = false
      mapView.delegate = self
    }
  }
  var locationManager = CLLocationManager()
  weak var delegate: GoogleMapViewDelegate? {
    didSet {

      locationManager.requestWhenInUseAuthorization()

      if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
      }

//      let mapId = GMSMapID(identifier: Bundle.valueForString(key: "Google map id"))

      mapView = GMSMapView(frame: frame)

      addSubview(mapView!)

      mapView?.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
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

  private func centerLocation(location: CLLocationCoordinate2D) {
    guard let mapView = mapView else { return }
    let target = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 19.0)
  }
}

extension GoogleMapView: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    guard let userLocation = locations.last,
          let mapView = mapView else { return }

//    let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 19.0)

    centerLocation(location: userLocation.coordinate)

    mapView.isMyLocationEnabled = true

    addMarker(title: "幫前位置", snippet: "世界的中心", position: userLocation.coordinate)

    locationManager.stopUpdatingLocation()
  }
}

extension GoogleMapView: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    centerLocation(location: marker.position)
    return true
  }
}
