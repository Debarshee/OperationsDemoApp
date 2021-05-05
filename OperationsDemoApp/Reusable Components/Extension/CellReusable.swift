//
//  CellReusable.swift
//  OperationsDemoApp
//  Extension for Cell Identifier
//
//  Created by Debarshee on 5/4/21.
//

import Foundation
import UIKit

protocol CellReusable {
    static var cellIdentifier: String { get }
}

extension CellReusable where Self: UIView {
    static var cellIdentifier: String {
        String(describing: self)
    }
}
