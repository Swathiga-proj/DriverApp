//
//  Singleton.swift
//  SampleOla
//
//  Created by NanoNino on 13/11/21.
//

import UIKit
import GoogleMaps

typealias Address = (_ address:String?,_ error:Error?)-> Void

class Singleton: NSObject {
   static let shared = Singleton()
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completion : @escaping Address) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = pdblLatitude
            center.longitude = pdblLongitude

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        completion(nil, error as! Error)
                    }
                    
                    if placemarks != nil{
                 let pm = placemarks! as! [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print(addressString)
                        completion(addressString, nil)
                  }
                    }
            })

        }


}
