//
//  GoogleReversGeocoding.swift
//  OrganicsBazaar
//  Geocoding
//  Created by Taranjeet Singh on 5/30/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleReverseGeocoding {
    
    static let sharedInstance = GoogleReverseGeocoding()
    
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, _ completeAddress: String?, Error?) -> ())  {
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, nil, error)
                return
            }
            
            let completeAddress = self.getCompleteAddress(placemarks)
            
            completion(placemark, completeAddress, nil)
        }
    }
    
    private func getCompleteAddress(_ placemarks: [CLPlacemark]?) -> String {
        guard let placemarks = placemarks else {
            return ""
        }
        
        let place = placemarks as [CLPlacemark]
        if place.count > 0 {
            let place = placemarks[0]
            var addressString : String = ""
            if place.thoroughfare != nil {
             //   print(place.thoroughfare! + "a")
                addressString = addressString + place.thoroughfare! + ", "
            }
            if place.subThoroughfare != nil {
                 // print(place.subThoroughfare! + "b")
                addressString = addressString + place.subThoroughfare! + ", "
            }
            if place.locality != nil {
               // print(place.locality! + "c")
                addressString = addressString + place.locality! + ", "
            }
            if place.postalCode != nil {
                addressString = addressString + place.postalCode! + ", "
            }
            if place.subAdministrativeArea != nil {
             //   print(place.subAdministrativeArea + "d")
                addressString = addressString + place.subAdministrativeArea! + ", "
            }
            if place.country != nil {
                
                // print(place.country + "e")
                addressString = addressString + place.country!
            }
            
            return addressString
        }
        return ""
    }
}
