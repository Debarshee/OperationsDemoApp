//
//  PhotoData.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import UIKit

class PhotoData {
    enum PhotoDataState {
      case new, downloaded, filtered, failed
    }
    
    let name: String
    let url: String
    var state = PhotoDataState.new
    var image: Data?
  
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
