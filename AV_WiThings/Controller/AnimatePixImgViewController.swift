//
//  AnimatePixImgViewController.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class AnimatePixImgViewController:UIViewController {
    
    @IBOutlet weak var imgPix: UIImageView!
    var pixImgs:[PixImage]!
    var pixImgages:[UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: pixImgs.first!.webformatURL)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.imgPix.image = UIImage(data: data)
            })
            }.resume()
        
        imgPix.animationImages = pixImgages
        imgPix.animationDuration = 4.0
        imgPix.startAnimating()
    }
}
