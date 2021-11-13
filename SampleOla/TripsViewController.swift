//
//  TripsViewController.swift
//  SampleOla
//
//  Created by NanoNino on 13/11/21.
//

import UIKit
struct List {
    var id = ""
    var booking_id = ""
    var invoice_no = ""
    var category_id = ""
    var vehicle_type_id = ""
    var vehicle_type_name = ""
    var booking_status = ""
    var s_name = ""
    var s_address = ""
    var s_latitude = ""
    var s_longitude = ""
    var d_name = ""
    var d_address = ""
    var d_latitude = ""
    var d_longitude = ""
    var map_root = ""
    var country_short_name = ""
    var actual_s_address = ""
    var actual_s_latitude = ""
    var actual_s_longitude = ""
    var actual_d_address = ""
    var actual_d_latitude = ""
    var actual_d_longitude = ""
    var actual_map_root = ""
    var otp = ""
    var ride_type = ""
    var create_time = ""
    var booking_time = ""
    var fare = ""
}
class TripsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    
    @IBOutlet var buttonMenu: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    var arrList = [List]()
    var total = 0
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TripsViewController.handleRefresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    @objc func handleRefresh() {
            
            
            arrList.removeAll()

        self.getList()
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
        
        let target = revealViewController()
        buttonMenu.target(forAction: #selector(target?.revealSideMenu), withSender: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getList()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row<arrList.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let labelRental = cell.viewWithTag(1) as! UILabel

            let labelPrice = cell.viewWithTag(2) as! UILabel
            let labelDate = cell.viewWithTag(3) as! UILabel

            let labelDotwithColor = cell.viewWithTag(4) as! UILabel
            let labelDotWithBorder = cell.viewWithTag(5) as! UILabel

            let labelSourceAddress = cell.viewWithTag(6) as! UILabel
            let labelDestinationAddress = cell.viewWithTag(7) as! UILabel

            let labelTime = cell.viewWithTag(8) as! UILabel
            let labelVehicleType = cell.viewWithTag(9) as! UILabel
            let labelCancel = cell.viewWithTag(10) as! UILabel
            let viewContent = cell.viewWithTag(100)! as! UIView
     
        viewContent.layer.shadowColor = UIColor.lightGray.cgColor
        viewContent.layer.shadowRadius = 10.0
        viewContent.layer.shadowOpacity = 0.3
        viewContent.layer.shadowOffset = CGSize.zero
        viewContent.layer.masksToBounds = false
        if indexPath.row<arrList.count{
            let dic = arrList[indexPath.row]
            labelRental.text = dic.ride_type
            labelPrice.text = "₹" + dic.fare
            labelDotwithColor.layer.cornerRadius = labelDotwithColor.frame.height/2
            labelDotWithBorder.layer.borderColor = UIColor.black.cgColor
            labelDotWithBorder.layer.borderWidth = 1
            labelSourceAddress.text = dic.s_address
            labelDestinationAddress.text = dic.d_address
            labelVehicleType.text = dic.vehicle_type_name
            labelCancel.text = dic.booking_status
            let dateFormatter = DateFormatter()
        if dic.s_address == "" {
            labelSourceAddress.text = "Not mentioned"

        }else if dic.d_address == ""{
            labelDestinationAddress.text = "Not mentioned"

        }
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: dic.booking_time) {
//                dateFormatter.timeZone = TimeZone.current
//                dateFormatter.calendar = .current
                dateFormatter.dateFormat = "dd MMM yyyy"
                labelDate.text = dateFormatter.string(from: date)
                
                dateFormatter.dateFormat = "E, hh:mm a"
                labelTime.text = dateFormatter.string(from: date)

            }
        }
         return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
//
//            return cell
//
//        }
    }

    func getList(){
        
        
        ApiManager.shared.APICall(params: [:], url: kUrlListApi) { (dic, response, error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            print("dic:",dic!)
            self.total = Int(dic!.stringValueForKey("totalPages"))!
            if let res = dic!["result"] as? Array<Dictionary<String,AnyObject>>{
                if res.count>0{
                    for dict in res{
                        var list = List()
                        list.id = dict.stringValueForKey("id")
                        list.booking_id = dict.stringValueForKey("booking_id")
                        list.invoice_no = dict.stringValueForKey("invoice_no")
                        list.category_id = dict.stringValueForKey("category_id")
                        list.vehicle_type_id = dict.stringValueForKey("vehicle_type_id")
                        list.vehicle_type_name = dict.stringValueForKey("vehicle_type_name")
                        list.booking_status = dict.stringValueForKey("booking_status")
                        list.s_name = dict.stringValueForKey("s_name")
                        list.s_address = dict.stringValueForKey("s_address")
                        list.s_latitude = dict.stringValueForKey("s_latitude")
                        list.s_longitude = dict.stringValueForKey("s_longitude")
                        list.d_name = dict.stringValueForKey("d_name")
                        list.d_address = dict.stringValueForKey("d_address")
                        list.d_latitude = dict.stringValueForKey("d_latitude")
                        list.d_longitude = dict.stringValueForKey("d_longitude")
                        list.map_root = dict.stringValueForKey("map_root")
                        list.country_short_name = dict.stringValueForKey("country_short_name")
                        list.actual_s_address = dict.stringValueForKey("actual_s_address")
                        list.actual_s_latitude = dict.stringValueForKey("actual_s_latitude")
                        list.actual_s_longitude = dict.stringValueForKey("actual_s_longitude")
                        list.actual_d_address = dict.stringValueForKey("actual_d_address")
                        list.actual_d_latitude = dict.stringValueForKey("actual_d_latitude")
                        list.actual_d_longitude = dict.stringValueForKey("actual_d_longitude")
                        list.actual_map_root = dict.stringValueForKey("actual_map_root")
                        list.otp = dict.stringValueForKey("otp")

                        list.otp = dict.stringValueForKey("otp")
                        list.ride_type = dict.stringValueForKey("ride_type")
                        list.create_time = dict.stringValueForKey("create_time")
                        list.booking_time = dict.stringValueForKey("booking_time")
                        list.fare = dict.stringValueForKey("fare")
                        self.arrList.append(list)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                   
                }
                
            }
        }
    }

}
