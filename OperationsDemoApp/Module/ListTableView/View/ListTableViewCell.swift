//
//  ListTableViewCell.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import UIKit

class ListTableViewCell: UITableViewCell, CellReusable {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoTitleLabel: UILabel!
    @IBOutlet private weak var photoActivityIndicator: UIActivityIndicatorView!
    
    func configure(configurator: ListCellViewModelProtocol) {
        photoTitleLabel.text = configurator.photoTitle
        photoImageView.image = configurator.photoImage
        switch configurator.state {
        case .downloaded, .new:
            photoActivityIndicator.startAnimating()
            
        case .filtered, .failed:
            photoActivityIndicator.isHidden = true
        }
    }
}
