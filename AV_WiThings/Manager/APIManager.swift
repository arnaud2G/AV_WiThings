//
//  APIManager.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

protocol APIManagerDelegate:class {
    func returnPixImg(ret:[PixImage])
}

struct APIManager {
    
    weak var delegate:APIManagerDelegate?
    
    let path:String = "https://pixabay.com/api/?key=5511001-7691b591d9508e60ec89b63c4"
    
    func useAPI() {
        
        guard let url = URL(string: "\(path)") else {return}
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, ret, error in
            
            if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any?], let jsonImg = json["hits"] as? [[String:Any]] {
                DispatchQueue.main.async(execute: {
                    () -> Void in
                    self.delegate?.returnPixImg(ret: jsonImg.map{PixImage(json:$0)}.filter{$0 != nil} as! [PixImage])
                })
            }
        }).resume()
    }
}


