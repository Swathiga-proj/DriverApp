//
//  SideMenuViewController.swift
//  SampleOla
//
//  Created by NanoNino on 11/11/21.
//

import UIKit
struct Menu {
    var menu:String?
    var icon:UIImage?
}

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}
class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet var tableView: UITableView!
    
    var arrList = [Menu]() //["Map","List","Details"]
    var delegate: SideMenuViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        arrList = [Menu(menu: "Map",icon: UIImage(named: "car")),Menu(menu: "List",icon: UIImage(named: "list")),Menu(menu: "Details",icon: UIImage(named: "detail"))]
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView

        let label = cell.viewWithTag(2) as! UILabel
        let dic = arrList[indexPath.row]
        label.text = dic.menu?.uppercased()
        image.image = dic.icon
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
