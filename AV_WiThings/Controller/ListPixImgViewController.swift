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
        
        // Configuration du navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.startAnimationPressed(sender:)))
        navigationItem.rightBarButtonItem?.isEnabled = pixImgs.count >= 2

        
        // Configuration de la collectionView
        collectionView?.allowsMultipleSelection = true
        
        // Cofiguration de l'API
        apiManager.delegate = self
        apiManager.useAPI()
    }
    
    func startAnimationPressed(sender:UIButton) {
        performSegue(withIdentifier: "SegueToPlay", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? AnimatePixImgViewController {
            dvc.pixImgs = collectionView?.indexPathsForSelectedItems!.map{pixImgs[$0.row]}
            dvc.pixImgages = collectionView?.indexPathsForSelectedItems!.map{(collectionView?.cellForItem(at: $0) as! PixCell).imgPix.image!}
        }
    }
    
    // MARK: delegate de l'API Manager
    func returnPixImg(ret: [PixImage]) {
        self.pixImgs = ret
        collectionView?.reloadData()
    }
    
    
    // MARK: delegate de la collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixImgs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixCell", for: indexPath) as! PixCell
        cell.setSmallImage(withUrl: pixImgs[indexPath.row].previewURL)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems!.count >= 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems!.count >= 2
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
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                self.backgroundColor = .blue
            } else {
                self.backgroundColor = .white
            }
        }
    }
}
