//
//  GeoLocationVC.swift
//  ISMS
//  VC
//  Created by Gurleen Osahan on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SelectLocationDelegate : class {
    func selectedLatitudeLongitude(lat:String,long: String, address:String )
    
}

class GeoLocationVC: BaseUIViewController {
      //MARK:- Variables
    var centerMapCoordinate     :CLLocationCoordinate2D!
    var markerArray = [GMSMarker]()
    private var locationManager = CLLocationManager()
    var marker                  :GMSMarker!
    var zoomLevel:    Float     = 18.5
    var address:String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var cameraIdlePosition : CLLocationCoordinate2D?
    var delegate: SelectLocationDelegate?
        //MARK:- Outlets
    
    @IBOutlet weak var map_centerPin: UIImageView!
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var lbl_address: UILabel!
    //MARK:- View functions
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            MapView.delegate = self
            MapView.isMyLocationEnabled = true
            MapView.settings.myLocationButton = true
            self.MapView.bringSubviewToFront(map_centerPin)
            self.MapView.bringSubviewToFront(lbl_address)
            self.checkUsersLocationServicesAuthorization()
        }
        override func viewDidDisappear(_ animated: Bool) {
          MapView.clear()
        }
        
        // MARK:- Functions
        func getAddress(lat:Double,long:Double){
            GoogleReverseGeocoding.sharedInstance.geocode(latitude: lat, longitude: long) { (placemark, address, error) in
                if error == nil{
                    if let _ = placemark, let completeAddress = address {
                     self.lbl_address.text = completeAddress
                     self.address = completeAddress
                    }
                }else{
                    // do something with the error
                    self.showAlert(Message: error?.localizedDescription ?? "")
                }
            }
        }
    
        //locationMangerSetUp
        func setLocationManager(){
            
            if MapView != nil{
                MapView.settings.myLocationButton = false
                MapView.isMyLocationEnabled = true
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //locationManager.requestAlwaysAuthorization()
                locationManager.distanceFilter = 50
                locationManager.startUpdatingLocation()
                locationManager.delegate = self
                guard let latitude = self.locationManager.location?.coordinate.latitude,let longitude = self.locationManager.location?.coordinate.longitude else {
                    return
                }
                //API
               
                
                print("you get latitude and longitude for Api: \(latitude)and \(longitude)")
            }
        }
        func setCurrentLocationOnMap(){
            
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
                guard let latitude = locationManager.location?.coordinate.latitude,let longitude = locationManager.location?.coordinate.longitude else {
                    return }
                if MapView != nil{
                    let camera = GMSCameraPosition.camera(withLatitude: latitude ,longitude: longitude , zoom: zoomLevel)
                    self.MapView.animate(to: camera)
                }
                
            }
        }
        //checkAuthorizaton
        func checkUsersLocationServicesAuthorization(){
            
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined:
                
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                
                break
                
            case .restricted, .denied:
                // Disable location features
                
                let alert = UIAlertController(title: "Allow Location Access", message: "iEMS needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    
                    //  guard let settingsUrl = URL(string:  UIApplicationOpenSettingsURLString) else { return }
                    guard let settingsUrl = URL(string:"App-Prefs:root=Privacy&path=LOCATION") else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                // Finished opening URL
                            })
                        } else {
                            
                            UIApplication.shared.openURL(settingsUrl)
                        }
                    }
                    
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
                    self.checkUsersLocationServicesAuthorization()
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                break
                
            case .authorizedWhenInUse:
                setLocationManager()
                setCurrentLocationOnMap()
                break
                
            case .authorizedAlways:
                setLocationManager()
                setCurrentLocationOnMap()
                break
                
                
            }
            
        }
    @IBAction func Action_done(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if latitude != nil {
            self.delegate?.selectedLatitudeLongitude(lat: "\(String(describing: latitude!))", long: "\(String(describing: longitude!))", address: address ?? "" ) }
    }
    @IBAction func Action_CurrentLocation(_ sender: Any) {
            onTapGetCurrentloc()
        }
        //Current Location
        func onTapGetCurrentloc(){
            if MapView != nil{
                guard let lat = MapView.myLocation?.coordinate.latitude,
                    let lng = MapView.myLocation?.coordinate.longitude else {
                        return
                }
                let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: Float(zoomLevel))
                self.MapView.animate(to: camera)
            }
        }
        //MARK:- Actions
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    //MARK:- CLLocationManagerDelegate
    extension GeoLocationVC: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            guard status == .authorizedWhenInUse else {
                return
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {
                return
            }
            if MapView != nil{
                MapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }
            locationManager.stopUpdatingLocation()
        }
    }
    //MARK:- GMSMapViewDelegate
    extension GeoLocationVC: GMSMapViewDelegate {
        
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            latitude = mapView.camera.target.latitude
            longitude = mapView.camera.target.longitude
            if let lat = latitude,let long = longitude{
                cameraIdlePosition = CLLocationCoordinate2D(latitude: lat, longitude: long)
                self.getAddress(lat: lat, long: long)
            }
        }
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            print("moved")
        }
 
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            checkUsersLocationServicesAuthorization()
            
        }
//        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//            plotMarker(AtCoordinate: coordinate, onMapView: mapView)
//        }
//
//        //MARK: Plot Marker Helper
//        private func plotMarker(AtCoordinate coordinate : CLLocationCoordinate2D, onMapView vwMap : GMSMapView) {
//            let marker = GMSMarker(position: coordinate)
//            marker.map = vwMap
//        }
    }
    

