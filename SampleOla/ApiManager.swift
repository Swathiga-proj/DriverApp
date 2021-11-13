//
//  ApiManager.swift
//  SampleOla
//
//  Created by NanoNino on 13/11/21.
//

import UIKit

typealias Result = ((_ dataObject:[String:AnyObject]?,_ Response:URLResponse,_ Error:Error?) -> (Void))
class ApiManager: NSObject {
static let shared = ApiManager()
    
    
    func APICall(params:Dictionary<String,AnyObject>,url:String, completion: @escaping Result){
        let Url = URL(string: url)
        var request = URLRequest(url: Url!)
        request.httpMethod = "GET"
//        request.setValue("Application/jason", forHTTPHeaderField: "Content-Type")
//        let body = try? JSONSerialization.data(withJSONObject: params, options: [])
//        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
//            if let response = response{
//                print(response)
//            }
                        if error != nil{
                            print(error?.localizedDescription)
                            completion(nil,response!,error)
                        }

            if let data = data{
                do{
                    let jason = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]

                    if let data = jason["data"] as? [String:AnyObject]{
                        
                        completion(data,response!,nil)

//                        var arr = [Person]()
//                        var person=Person()
//                        for dat in data{
//                            person.id = dat["id"] as! Int
//                            person.name = dat["name"] as! String
//                            arr.append(person)
//                        }
//                        print(person)
                    }
                    print(jason)
                }catch{
                    print(error)
                }
            }
        }.resume()
    }

}
