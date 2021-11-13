//
//  SourceViewController.swift
//  SampleOla
//
//  Created by NanoNino on 11/11/21.
//

import UIKit
import GooglePlaces

protocol Getlocation {
    func getLocationAddress(dic:[String:AnyObject],str:String)
    
}

class SourceViewController: UIViewController,GMSAutocompleteResultsViewControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func getCurrentPlaceAddress(){
        let placesClient = GMSPlacesClient()
        placesClient.currentPlace { (placeLikelihoods, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            if let plcaLikelihood = placeLikelihoods?.likelihoods.first{
                let place = plcaLikelihood.place
                print(place)
             
                let dic = ["result":place.formattedAddress,"placeId":place.placeID] as [String:AnyObject]
                self.delegate?.getLocationAddress(dic: dic, str: self.isFrom)
                self.dismiss()
            }
        }
    }
    
    @IBOutlet var currentLoc: UIButton!
    @IBOutlet var textFieldSearch: UITextField!
    @IBOutlet var viewChoosePoints: UIView!
    @IBOutlet var tableView: UITableView!

    var placesClient: GMSPlacesClient!
    var resultsViewController: GMSAutocompleteResultsViewController?
    let filter = GMSAutocompleteFilter()
    let token = GMSAutocompleteSessionToken.init()
    var destinationArray = [[String:AnyObject]]()
     var delegate:Getlocation?
    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        textFieldSearch.delegate = self
        placesClient = GMSPlacesClient.shared()
        textFieldSearch.setLeftPaddingPoints(40)
        
    }
    
    @objc func googleSearch() {
        
        placesClient?.findAutocompletePredictions(fromQuery: textFieldSearch.text!, filter: filter, sessionToken: token) { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            self.destinationArray.removeAll()
            if let results = results {
              print(results)
                
                for result in results{
                    var dic = [String:AnyObject]()
                    dic["result"] = result.attributedFullText.string as AnyObject
                    dic["placeId"] = result.placeID as AnyObject
                    self.destinationArray.append(dic)
                    
                }
                print(self.destinationArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    //MARK:- textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        filter.type = .address
        filter.country = Locale.current.regionCode
        tableView.reloadData()
        googleSearch()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            destinationArray.removeAll()
            tableView.reloadData()
        }
    }
    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        let dic = destinationArray[indexPath.row]
        label.text = dic["result"] as? String
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = destinationArray[indexPath.row]
        textFieldSearch.text = dic["result"] as? String
        dismiss()

        delegate?.getLocationAddress(dic: dic, str: isFrom)
        textFieldSearch.resignFirstResponder()
        
    }
    //MARK:- button
    @IBAction func chooseCurrentLocation(_ sender: Any) {
//        locationManager.startUpdatingLocation()
        
        getCurrentPlaceAddress()
    }
    
    @IBAction func chooseLocationOnMap(_ sender: Any) {
        let vc = kstoryboard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as! ChooseLocationViewController
//        vc.modalPresentationStyle = .fullScreen
        vc.isFrom = isFrom
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func dismiss(){
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonBack(_ sender: Any) {
        textFieldSearch.resignFirstResponder()
        dismiss()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
