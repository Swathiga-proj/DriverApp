//
//  Constants.swift
//  SampleOla
//
//  Created by NanoNino on 10/11/21.
//

import Foundation
import UIKit
struct Location {
    var lat:Double?
    var long:Double?
   
}

let googleApiKey = "AIzaSyDdgUQsZPHrn-qOjNHLq3aIiPluw1eotq8"

let kUrlListApi = "https://project.virtuesense.com/mobile_dev/interview/list.json"

let kstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
var sourceLocation = Location()
var destinationLocation = Location()
var chooseOnMap = Location()
var currentLocation = Location()
var isMovingMarker = false
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
