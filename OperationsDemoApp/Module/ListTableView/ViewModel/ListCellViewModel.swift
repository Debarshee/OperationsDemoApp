//
//  ListCellViewModel.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import UIKit

protocol ListCellViewModelProtocol {
    var photoTitle: String { get }
    var photoUrl: String { get }
    var state: PhotoData.PhotoDataState { get set }
    var photoImage: UIImage? { get set }
}

class ListCellViewModel: ListCellViewModelProtocol {
    
    private var photoData: PhotoData
    
    init(photoData: PhotoData) {
        self.photoData = photoData
    }
    
    var photoTitle: String {
        photoData.name
    }
    
    var state: PhotoData.PhotoDataState {
        get {
            photoData.state
        }
        set {
            photoData.state = newValue
        }
    }
    
    var photoUrl: String {
        photoData.url
    }
    
    var photoImage: UIImage? {
        get {
            guard let imageData = photoData.image else { return nil }
            return UIImage(data: imageData)
        }
        set {
            photoData.image = newValue?.pngData()
        }
    }
}
