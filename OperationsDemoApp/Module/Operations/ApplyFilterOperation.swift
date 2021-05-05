//
//  ApplyFilterOperation.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import CoreImage
import Foundation
import UIKit

class ApplyFilterOperation: Operation {
    
    var photoData: ListCellViewModelProtocol
      
    init(photoData: ListCellViewModelProtocol) {
        self.photoData = photoData
    }
      
    override func main () {
        if isCancelled {
            return
        }
          
        guard photoData.state == .downloaded else { return }
        guard let image = photoData.photoImage,
              let filterApplied = CIFilter(name: "CISepiaTone"),
              let filteredImage = filter(image: image, option: filterApplied)
              else {
            return
        }
        photoData.photoImage = filteredImage
        photoData.state = .filtered
    }
    
    func filter(image: UIImage, option: CIFilter) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        let imageToFilter = CIImage(data: data)
        
        if isCancelled {
            return nil
        }
        let context = CIContext(options: nil) // image Analysis
        option.setValue(imageToFilter, forKey: kCIInputImageKey)
        option.setValue(0.8, forKey: kCIInputIntensityKey)
        
        if isCancelled {
            return nil
        }
        
        guard let outputImage = option.outputImage, let finalImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: finalImage)
    }
}

func logAllFilters() {
    let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
    print(properties)
}
