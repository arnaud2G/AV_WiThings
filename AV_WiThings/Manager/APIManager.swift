//
//  APIManager.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

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
            
            /*if let ret = ret as? HTTPURLResponse, let error = action.error(statuCode: ret.statusCode) {
                self.delegate?.retError(error: error)
            } else if let data = data {
                self.prepareRet(action:action, data: data)
            } else if let error = error {
                self.delegate?.retFatalError(error: error)
            }*/
        }).resume()
    }
}

// MARK: - APIEnum : tools to request (url + method + body + header) and convert json
/*enum APIEnum {
    case me, getItems(id:String), postItems(id:String, name:String), deleteItems(id:String)
    
    var endOfUrl:String {
        switch self {
        case .me:
            return "/me"
        case .getItems(let id), .deleteItems(let id), .postItems(let id, _):
            return "/items/\(id)"
        }
    }
    
    var httpMethod:String {
        switch self {
        case .me, .getItems:
            return "GET"
        case .postItems(_):
            return "POST"
        case .deleteItems(_):
            return "DELETE"
        }
    }
    
    var httpBody:Data? {
        switch self {
        case .postItems(_, let name):
            let json: [String: Any] = ["name": String(format: "forlder_%@", name)]
            return try? JSONSerialization.data(withJSONObject: json)
        default:
            return nil
        }
    }
    
    var httpHeader:[String:String]? {
        switch self {
        case .postItems(_,_):
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    func convertJSON(data:Data) -> Any? {
        switch self {
        case .me:
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return nil}
            return User(json: json)
        case .getItems(_):
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {return nil}
            return json.map{Item(json:$0)}.filter{$0 != nil}
        case .postItems(_,_):
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return nil}
            return Item(json:json)
        case .deleteItems(let id):
            return id
        }
    }
}

// MARK: - APIEnum+Error
extension APIEnum {
    
    func error(statuCode:Int) -> Error? {
        if statuCodeError.contains(statuCode) {
            return APIError.apiError(apiEnum: self, statuCode: statuCode)
        } else {
            return nil
        }
    }
    
    var statuCodeError:[Int] {
        return [400,404]
    }
    
    enum APIError: Error, LocalizedError {
        case apiError(apiEnum:APIEnum,statuCode:Int)
        
        var errorDescription: String? {
            switch self {
            case .apiError(let apiEnum, let statuCode):
                switch statuCode {
                case 400:
                    switch apiEnum {
                    case .postItems(_):
                        return NSLocalizedString("Invalid name or an item with this name already exists.", comment: "POST - Error 400")
                    default:
                        return nil
                    }
                case 404:
                    switch apiEnum {
                    case .getItems(_):
                        return NSLocalizedString("The item doesn’t exist", comment: "GET - Error 404")
                    case .postItems(_):
                        return NSLocalizedString("The parent item doesn’t exist.", comment: "POST - Error 404")
                    case .deleteItems(_):
                        return NSLocalizedString("The item doesn’t exist.", comment: "DELETE - Error 404")
                    default:
                        return nil
                    }
                default:
                    return nil
                }
            }
        }
    }
}*/

