//
//  ListPixImgViewController.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class ListPixImgViewController: UICollectionViewController, APIManagerDelegate {
    
    var apiManager = APIManager()
    var pixImgs = [PixImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        apiManager.useAPI()
    }
    
    func returnPixImg(ret: [PixImage]) {
        self.pixImgs = ret
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixImgs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixCell", for: indexPath) as! PixCell
        cell.setSmallImage(withUrl: pixImgs[indexPath.row].previewURL)
        return cell
    }
}

class PixCell:UICollectionViewCell {
    @IBOutlet weak var imgPix: UIImageView!
    func setSmallImage(withUrl url:String) {
        
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.imgPix.image = UIImage(data: data)
            })
        }.resume()
    }
}
