//
//  MapViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/3/22.
//

import UIKit
import CoreLocation
import MapKit
import HDAugmentedReality
import GoogleMaps
import SwiftUI

class MapViewController: UIViewController, CLLocationManagerDelegate{
    fileprivate var arViewController: ARViewController!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var arBtn: UIButton!
    var googleMapsView:GMSMapView!
    var theData : restaurantAPIData?
    var list: [Place]? = []
    var locationManager = CLLocationManager()
    
    
    func getDataFromMysql(){
        var url:URL?
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchdata.php?&query=")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(restaurantAPIData.self,from:data)
        for s in theData?.message ?? []{
            let lat = CLLocationDegrees(s.latitude)
            let lon = CLLocationDegrees(s.longitude)
            let name = s.name
            let loc = CLLocation(latitude: lat, longitude: lon)
            let id = s.id
            let place = Place(location: loc, rate: s.rating, name: name, address: "",id: id)
            list?.append(place)
        }
        arViewController.setAnnotations(list ?? [])
    }
    
    @IBAction func arBtnClicked(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        DispatchQueue.global(qos: .userInitiated).async {
            self.getDataFromMysql()
            DispatchQueue.main.async {
                self.present(self.arViewController, animated: true, completion: nil)
            }
        }
        

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //ini google map
        googleMapsView = GMSMapView (frame: self.mapViewContainer.frame)
        googleMapsView.isMyLocationEnabled = true
        googleMapsView.settings.compassButton = true
        googleMapsView.settings.myLocationButton = true
        googleMapsView.mapType = .normal
        self.view.addSubview(googleMapsView)
        
        //UI
        arBtn.layer.cornerRadius = 17
        arBtn.layer.borderWidth = 1
        arBtn.layer.borderColor = UIColor.white.cgColor
              
        fetchLocation()
        for item in theData?.message ?? [] {
            // Creates markers of restaurants.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            marker.title = item.name
            marker.map = googleMapsView
        }
    }
    
    // get restaurants location
    func fetchLocation(){
        var url:URL?
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchdata.php?&query=")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(restaurantAPIData.self,from:data)
    }
    
    // get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.googleMapsView.camera = camera
        self.googleMapsView.isMyLocationEnabled = true

        let marker = GMSMarker(position: center)

        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        marker.map = self.googleMapsView

        marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
    }

    
    

}

extension MapViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
      let annotationView = AnnotationView()
      annotationView.annotation = viewForAnnotation
      annotationView.delegate = self
      annotationView.backgroundColor = .white
      annotationView.layer.cornerRadius = 10
      annotationView.layer.borderWidth = 1
      annotationView.layer.borderColor = UIColor(named: "black")?.cgColor
      annotationView.frame = CGRect(x: 0, y: 0, width: 200, height: 55)
      annotationView.loadUI()
      return annotationView
  }
}
extension MapViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        
    }
}

