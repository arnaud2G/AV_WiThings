//
//  PixImage.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

struct PicImage {
    
    let previewURL:String
    let webformatURL:String
    
    init?(json:[String:Any?]) {
        guard
            let previewURL = json["previewURL"] as? String,
            let webformatURL = json["webformatURL"] as? String
            else {return nil}
        
        self.previewURL = previewURL
        self.webformatURL = webformatURL
    }
}
