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

class PendingOperations {
    lazy var smallDownloadsInProgress = [IndexPath:Operation]()
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class SmallImageDownloader: Operation {
    
    let pixImage: PixImage
    init(pixImage: PixImage) {
        self.pixImage = pixImage
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        do {
            let imageData = try Data(contentsOf: URL(string:self.pixImage.previewURL)!)
            self.pixImage.previewImg = UIImage(data:imageData)
            self.pixImage.state = .downloaded
        } catch {
            self.pixImage.state = .failed
        }
    }
}

class ImageDownloader: Operation {
    
    let pixImage: PixImage
    init(pixImage: PixImage) {
        self.pixImage = pixImage
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        do {
            let imageData = try Data(contentsOf: URL(string:self.pixImage.webformatURL)!)
            self.pixImage.webformatImg = UIImage(data:imageData)
            self.pixImage.state = .downloaded
        } catch {
            self.pixImage.state = .failed
        }
    }
}



