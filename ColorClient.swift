//
//  ColorClient.swift
//  ColorBox
//
//  Created by Connor Fitzpatrick on 3/29/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import Foundation

class ColorClient {

    static let sharedClient = ColorClient()
    
    func getColors(_ completion: @escaping ([ColorBox]) -> ()) {
        get(clientURLRequest("videosrc/colors.json")) { (success, object) in
            var colors: [ColorBox] = []
            
            if let object = object as? Dictionary<String, AnyObject> {
                if let results = object["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        if let color = ColorBox(json: result) {
                            colors.append(color)
                        }
                    }
                }
            }
            
            completion(colors)
        }
    }
    
    fileprivate func get(_ request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    fileprivate func clientURLRequest(_ path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: "https://thatthinginswift.com/"+path)!)

        return request
    }
    
    fileprivate func dataTask(_ request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                        completion(true, json as AnyObject?)
                    } else {
                        completion(false, json as AnyObject?)
                    }
                }
            })  .resume()
        }
    }
