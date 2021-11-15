//
//  DetailViewController.swift
//  SampleOla
//
//  Created by NanoNino on 11/11/21.
//

import UIKit
import GoogleMaps
class DetailViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet var labelBorderDot: UILabel!
    @IBOutlet var labelColorDot: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var buttonReceipt: UIButton!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        let target = revealViewController()
        menuButton.target(forAction: #selector(target?.revealSideMenu), withSender: nil)
        buttonReceipt.layer.cornerRadius = buttonReceipt.frame.height/2
        labelColorDot.layer.cornerRadius = labelColorDot.frame.height/2
        labelColorDot.layer.masksToBounds = true
        
        labelBorderDot.layer.borderWidth = 1
        labelBorderDot.layer.borderColor = UIColor.black.cgColor
        labelBorderDot.layer.masksToBounds = true
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        currentLocation = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }


}
