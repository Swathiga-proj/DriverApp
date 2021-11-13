//
//  ChooseLocationViewController.swift
//  SampleOla
//
//  Created by NanoNino on 13/11/21.
//

import UIKit
import GoogleMaps
class ChooseLocationViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet var selectLoc: UIButton!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var centerMarker: UIImageView!
    @IBOutlet var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var selectedLocation = Location()
    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let markerImageView = UIImageView(image: UIImage(named: "default_marker.png"))
//        markerImageView.center = mapView.center
//        mapView.addSubview(markerImageView)
//        mapView.bringSubviewToFront(markerImageView)
        mapView.delegate = self
        selectLoc.layer.cornerRadius = selectLoc.frame.height/2
        selectLoc.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        selectedLocation.lat = position.target.latitude
        selectedLocation.long = position.target.longitude

        getAddress(lat: selectedLocation.lat!, lng: selectedLocation.long!)
    }
    @IBAction func selectLoc(_ sender: Any) {
        let dic = ["address":labelAddress.text, "str":isFrom,"lat":selectedLocation.lat,"lng":selectedLocation.long] as [String:AnyObject]
        UserDefaults.standard.set(dic, forKey: "setLocation")
        NotificationCenter.default.post(name: NSNotification.Name("setLocation"), object: nil, userInfo: nil)

        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getAddress(lat:Double,lng:Double){
        Singleton.shared.getAddressFromLatLon(pdblLatitude: lat, withLongitude: lng) { (address, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                print(address)
                self.labelAddress.text = address
            }
            
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        currentLocation = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        selectedLocation = currentLocation
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }


}
