//
//  DownloadImageOperation.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import UIKit

class DownloadImageOperation: Operation {
    
    var photoData: ListCellViewModelProtocol
    
    init(photoData: ListCellViewModelProtocol) {
        self.photoData = photoData
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let url = URL(string: photoData.photoUrl) else {
            fatalError("Url not valid")
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            if isCancelled {
                return
            }
            guard !imageData.isEmpty  else {
                photoData.state = .failed
                photoData.photoImage = nil
                return
            }
            photoData.photoImage = UIImage(data: imageData)
            photoData.state = .downloaded
        } catch {
            photoData.photoImage = nil
            photoData.state = .failed
        }
    }
}
