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
    let myPendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration du cache
        
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
        switch pixImgs[indexPath.row].state {
        case .failed: break
            // TODO: Gestion de l'erreur de telechargement
        case .downloaded:
            cell.imgPix.image = pixImgs[indexPath.row].previewImg
        case .none:
            startDownloadSmallImage(indexPath: indexPath)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if pixImgs[indexPath.row].previewImg == nil {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        if pixImgs[indexPath.row].webformatImg == nil {
            startDownloadImage(indexPath: indexPath)
        }
        navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems!.count >= 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems!.count >= 2
    }
    
    // Gestion du telechargement des images
    func startDownloadSmallImage(indexPath: IndexPath) {
        
        // Cas des plus grandes listes (si scroll)
        if myPendingOperations.smallDownloadsInProgress[indexPath] != nil {
            return
        }
        
        // On défini l'opération
        let downloader = SmallImageDownloader(pixImage: pixImgs[indexPath.row])
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.myPendingOperations.smallDownloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView?.reloadItems(at: [indexPath])
            })
        }
        
        // On ajoute l'opération
        myPendingOperations.smallDownloadsInProgress[indexPath] = downloader
        myPendingOperations.downloadQueue.addOperation(downloader)
    }
    func startDownloadImage(indexPath: IndexPath) {
        
        // Cas des plus grandes listes (si scroll)
        if myPendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        // On défini l'opération
        let downloader = ImageDownloader(pixImage: pixImgs[indexPath.row])
        downloader.completionBlock = {
            self.myPendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        // On ajoute l'opération
        myPendingOperations.downloadsInProgress[indexPath] = downloader
        myPendingOperations.downloadQueue.addOperation(downloader)
    }
}

class PixCell:UICollectionViewCell {
    
    @IBOutlet weak var imgPix: UIImageView!
    
    func setSmallImage(withStringUrl url:String) {
        
        UIImage.image(fromUrl: url, completionHandler: {
            image in
            if let image = image {
                self.imgPix.image = image
            }
        })
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
