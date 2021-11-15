//
//  HomeViewController.swift
//  SampleOla
//
//  Created by NanoNino on 11/11/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
class HomeViewController: UIViewController, CLLocationManagerDelegate,UITextFieldDelegate,Getlocation,GMSMapViewDelegate {
    
    

    
    @IBOutlet var labelDistance: UILabel!
    @IBOutlet var labelDuration: UILabel!
    @IBOutlet var viewDurDis: UIStackView!
    @IBOutlet var textFieldDestination: UITextField!
    @IBOutlet var textFieldSource: UITextField!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var CenterMarker: UIImageView!
    
    var sourceMarker = GMSMarker()
    var destinationMarker = GMSMarker()
    var setLocationMarker = GMSMarker()
    var lastCamerPosition : GMSCameraPosition?
    var choosen = ""
    var movePin = false
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //menu
        let target = revealViewController()
        menuButton.target(forAction: #selector(target?.revealSideMenu), withSender: nil)
        
        textFieldSource.setLeftPaddingPoints(40)
        textFieldDestination.setLeftPaddingPoints(40)
        
        //mapview
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.isMyLocationEnabled = false
        mapView.delegate = self
        
        viewDurDis.isHidden = true
        textFieldSource.delegate = self
        textFieldDestination.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.selectedLocOnMap), name: NSNotification.Name(rawValue: "setLocation"), object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
    //    selectedLocOnMap()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "getLocation")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = kstoryboard.instantiateViewController(withIdentifier: "SourceViewController") as! SourceViewController
//        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
    if textField == textFieldSource{
        vc.isFrom = "source"
    }else{
        vc.isFrom = "destination"
    }
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
return false
    }
    
    //MARK:- GOOGLE MAPS
    
    @objc func delay(){
        if isMovingMarker{

            if choosen == "source"{
                sourceLocation.lat = setLocationMarker.position.latitude
                sourceLocation.long = setLocationMarker.position.longitude
            }else{
                destinationLocation.lat = setLocationMarker.position.latitude
                destinationLocation.long = setLocationMarker.position.longitude
            }
            getAddress(pdblLatitude: destinationLocation.lat!, withLongitude: destinationLocation.long!)
            
        }

    }
    func getAddress(pdblLatitude:Double,withLongitude pdblLongitude:Double){
        Singleton.shared.getAddressFromLatLon(pdblLatitude: pdblLatitude, withLongitude: pdblLongitude) { (address, error) in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if self.choosen == "source"{
                    self.textFieldSource.text = address
                }else{
                    self.textFieldDestination.text = address
                }
                self.setLocationMarker.map = nil
                isMovingMarker = false
                self.updateLocation()

            }
            
            
        }

    }

    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){

            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(googleApiKey)")!

            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                  
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{

                            guard let routes = json["routes"] as? NSArray else {
                                return
                            }

                            if (routes.count > 0) {
                                let overview_polyline = routes[0] as? NSDictionary
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary

                                let points = dictPolyline?.object(forKey: "points") as? String
                                let path = GMSPath(fromEncodedPath: points!)
                                let distance = GMSGeometryLength(path!)
                                DispatchQueue.main.async {
                                    self.labelDistance.text = String((distance/1000)) + "km"

                                }
                                self.showPath(polyStr: points!)
                               //Distance and time
                                let legs =  overview_polyline!["legs"] as? NSArray
                                let overViewTime = legs![0] as? NSDictionary
                                let dist = overViewTime!["distance"] as? NSDictionary
                                let duration = overViewTime!["duration"] as? NSDictionary

//                                let disValue = dist!["value"]
//                                let durValue = duration!["value"] as! Int / 3600
                                let disValue = dist!["text"]
                                let durValue = duration!["text"]

//                                print("disValue250 \(String(describing: disValue))")
//
//                                print("durValue250 \(durValue)")
                                DispatchQueue.main.async {
                                    self.labelDuration.text = "Duration " + String(describing: durValue!)
                                    self.labelDistance.text = "Distance " +  String(describing: disValue!)

                                }
//                                var calendar = Calendar(identifier: .gregorian)
//                                calendar.timeZone = TimeZone(secondsFromGMT:0)!
//                                let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .second]
//
//                                let nowDate = Date()
//                                let durationDate = Date(timeIntervalSinceNow: TimeInterval(durValue))
//
//
//                                let components = calendar.dateComponents(unitFlags, from: nowDate,  to: durationDate)
//                                print("Comps :: ", components.day, components.hour, components.minute, components.second)
//                                self.timeLabel.text = "\(components.hour!)" + "hrs" + "\(components.minute!)" + "min"
//                                if(durValue != Int(0.0))
//                                {
//                                     let speed = disValue / durValue
//                                }

                               DispatchQueue.main.async {

                                    let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                                    self.mapView!.moveCamera(update)
                                }
                            }
                            else {
                            }
                        }
                    }
                    catch {
                        print("error in JSONSerialization")
                       
                    }
                }
                        if isMovingMarker{
                            isMovingMarker = false
                        }

            })
            task.resume()
        }

    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.red
        polyline.map = mapView // Your map view
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
          return
        }
   
        locationManager.startUpdatingLocation()
          
       // mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        currentLocation = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
       
        marker.map = mapView
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        let pos = marker.position
        if marker == sourceMarker{
            sourceLocation.lat = pos.latitude
            sourceLocation.long = pos.longitude
        }else{
            destinationLocation.lat = pos.latitude
            destinationLocation.long = pos.longitude
        }
        updateLocation()

    }
    func updateLocation(){
        mapView.clear()
        var arrLoc = [Location]()
       
        viewDurDis.isHidden = true
        if (sourceLocation.lat != nil && sourceLocation.long != nil) && (destinationLocation.lat != nil && destinationLocation.long != nil){
//            arrLoc.append(sourceLocation)
//            arrLoc.append(destinationLocation)
            var bounds = GMSCoordinateBounds()

//            for loc in arrLoc{
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: loc.lat!, longitude: loc.long!)
//                marker.map = mapView
//                bounds = bounds.includingCoordinate(marker.position)
//
//            }
            sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLocation.lat!, longitude: sourceLocation.long!)
            sourceMarker.isDraggable = true
            sourceMarker.map = mapView
            
            bounds = bounds.includingCoordinate(sourceMarker.position)
           
            destinationMarker.position = CLLocationCoordinate2D(latitude: destinationLocation.lat!, longitude: destinationLocation.long!)
            destinationMarker.isDraggable = true
            destinationMarker.map = mapView
            
            bounds = bounds.includingCoordinate(destinationMarker.position)

            let update = GMSCameraUpdate.fit(bounds, withPadding: 150)
            mapView.animate(with: update)
            let source = CLLocationCoordinate2D(latitude: sourceLocation.lat!, longitude: sourceLocation.long!)
            let destination = CLLocationCoordinate2D(latitude: destinationLocation.lat!, longitude: destinationLocation.long!)
            viewDurDis.isHidden = false
          getPolylineRoute(from: source, to: destination)
        }
        else if (sourceLocation.lat != nil && sourceLocation.long != nil) {
            var bounds = GMSCoordinateBounds()
            sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLocation.lat as! Double, longitude: sourceLocation.long as! Double)
            sourceMarker.isDraggable = false
            sourceMarker.map = mapView
            bounds = bounds.includingCoordinate(sourceMarker.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 150)
            mapView.animate(with: update)

        }  else if (destinationLocation.lat != nil && destinationLocation.long != nil) {

           
            var bounds = GMSCoordinateBounds()
            destinationMarker.position = CLLocationCoordinate2D(latitude: destinationLocation.lat as! Double, longitude: destinationLocation.long as! Double)
            destinationMarker.isDraggable = false
            destinationMarker.map = mapView
            bounds = bounds.includingCoordinate(destinationMarker.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 150)
            mapView.animate(with: update)

        }

    }
    func convertPlaceIDToPlace(placeID : String,str:String?)  {
        let placesClient = GMSPlacesClient()
        var strAddress = ""
        placesClient.lookUpPlaceID(placeID, callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
               // var dicLocation = [:] as Dictionary<String, AnyObject>
                if str == "source"{
                sourceLocation.lat = place.coordinate.latitude as Double
                sourceLocation.long = place.coordinate.longitude as Double
                }else{
                    destinationLocation.lat = place.coordinate.latitude as Double
                    destinationLocation.long = place.coordinate.longitude as Double

                }
               // dicLocation["fullAddress"] = place.formattedAddress as AnyObject
                
//                var tag = ""
//                if let address = place.addressComponents {
//                    for dict in address {
//                        for dic in dict.types{
//                        if dic == "city" {
//                            dicLocation["city"] = dict.name as AnyObject
//                            strAddress = dict.name
//                            tag = "1"
//                        }
//                        else if dic == "locality" {
//                            dicLocation["city"] = dict.name as AnyObject
//                            strAddress = dict.name
//                            tag = "1"
//                        }
//                        else if tag == "" && dic == "administrative_area_level_1" {
//                            dicLocation["city"] = dict.name as AnyObject
//                            strAddress = dict.name
//                            tag = "1"
//                        }
//
//                        if dic == "state" {
//                            dicLocation["state"] = dict.shortName as AnyObject
//                            strAddress = strAddress  + ", " + dict.shortName!
//                        }
//                        else if dic == "administrative_area_level_1" {
//                             dicLocation["state"] = dict.shortName as AnyObject
//                            strAddress = strAddress  + ", " + dict.shortName!
//                        }
//
//                        if dic == "country" {
//                            dicLocation["countryCode"] = dict.shortName as AnyObject
//                        }
//                        if dic == "country" {
//                            dicLocation["country"] = dict.name as AnyObject
//                        }
//                        if dic == "postal_code_prefix" {
//                            dicLocation["postalCode"] = dict.shortName as AnyObject
//                        }
//                        else if dic == "postal_code" {
//                            dicLocation["postalCode"] = dict.shortName as AnyObject
//                        }
//                    }
//                    }
//
//            }
              //  self.dicSearch = dicLocation
                self.updateLocation()
            }
            else {
                print("No place details for \(placeID)")
            }
        })
}
//MARK:PROTOCOL
    func getLocationAddress(dic: [String : AnyObject], str: String) {
        
        if str == "source"{
        textFieldSource.text = dic["result"] as? String
        }else{
        textFieldDestination.text = dic["result"] as? String
        }
       convertPlaceIDToPlace(placeID: dic["placeId"] as! String, str: str)

        
        
    }
    @objc func selectedLocOnMap() {
        if let val = UserDefaults.standard.value(forKey: "setLocation") as? [String:AnyObject]{
            
            if val.stringValueForKey("str") == "source"{
                textFieldSource.text = val.stringValueForKey("address")
                sourceLocation.lat = Double(val.stringValueForKey("lat"))
                sourceLocation.long = Double(val.stringValueForKey("lng"))
            }else{
                textFieldDestination.text = val.stringValueForKey("address")
                destinationLocation.lat = Double(val.stringValueForKey("lat"))
                destinationLocation.long = Double(val.stringValueForKey("lng"))
                
            }
            updateLocation()

        }
    }

    
    
    
}
