//
//  DLPhotoManager.swift
//  AV_WiThings
//
//  Created by 2Gather Arnaud Verrier on 01/06/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

// On utilise le même PendingOperations pour les petites et grandes images
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

// state est déterminé à partir de la petite image seulement
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

// la réussite du téléchargement de la grande image est optionnelle pour le bon fonctionnement de l'apps
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
        } catch {
            print("ce n'est pas grave on utilise la petite image")
        }
    }
}


