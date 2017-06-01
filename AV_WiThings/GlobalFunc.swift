//
//  GlobalFunc.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func image(fromUrl urlString: String, completionHandler: @escaping (_ result:UIImage?) -> Void) {
        
        guard let url = URL(string:urlString) else {
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data, error == nil else { completionHandler(nil) ; return }
            DispatchQueue.main.async(execute: {
                () -> Void in
                completionHandler(UIImage(data: data))
            })
            }.resume()
    }
}


