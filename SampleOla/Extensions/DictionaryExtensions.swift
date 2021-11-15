//
//  StringExtensions.swift
//  SwiftTest
//
//  Created by Saktheeswaran on 16/09/16.
//  Copyright © 2016 NanoNino. All rights reserved.
//
import UIKit

extension UserDefaults {
    
    /// A dictionary of properties representing a cookie.
    typealias CookieProperties = [HTTPCookiePropertyKey: Any]
    
    /// The `UserDefaults` key for accessing cookies.
    private static let cookieKey = "cookies"
    
    /// Saves all cookies currently in the shared `HTTPCookieStorage` to the shared `UserDefaults`.
    func saveCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        let cookiePropertiesArray = cookies.compactMap { $0.properties }
        set(cookiePropertiesArray, forKey: UserDefaults.cookieKey)
        synchronize()
    }
    
    /// Loads all cookies stored in the shared `UserDefaults` and adds them to the current shared `HTTPCookieStorage`.
    func loadCoookies() {
        let cookiePropertiesArray = value(forKey: UserDefaults.cookieKey) as? [CookieProperties]
        cookiePropertiesArray?.forEach {
            if let cookie = HTTPCookie(properties: $0) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
}


extension Dictionary {
    
    func hasValueForKey(_ key:Key) -> Bool{
        
        if let value = self[key] {
            if value is NSNull {
                return false
            }
            else {
                return true
            }
            
        }
        else {
            return false
        }
    }
    func hasStringForKey(_ key:Key) -> Bool{
        
        if let value = self[key] {
            if value is NSNull {
                return false
            }
            else {
                var strValue = ""
                if let object = self[key] {
                    if object is String {
                        strValue = object as! String
                    }
                    else if object is NSNumber || object is Float || object is Int || object is Double {
                        strValue = String(describing: object)
                    }
                }
                strValue = strValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if strValue.count > 0 {
                    return true
                }
                else {
                    return false
                }
                
            }
            
        }
        else {
            return false
        }
    }
    
    func stringValueForKey(_ key:Key) -> String {
        var strValue = ""
        
        if let object = self[key] {
            if object is String {
                strValue = object as! String
            }
            else if object is NSNumber || object is Float || object is Int || object is Double {
                strValue = String(describing: object)
            }
        }
        strValue = strValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strValue
    }
    
    
    var jsonString: String
    {
        if let dict = (self as AnyObject) as? Dictionary<String, AnyObject>
        {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let string = String(data: data, encoding: String.Encoding.utf8)
                {
                    return string
                }
            }
            catch
            {
            }
        }
        return ""
    }
}

 
