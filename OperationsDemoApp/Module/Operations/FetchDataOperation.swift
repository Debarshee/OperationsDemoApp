//
//  FetchDataOperation.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import Foundation

class FetchDataOperation<T: Decodable>: Operation {
    
    private let endPoint: EndPoint
    private let networkRouter: NetworkRouter
    
    var result: Result<T, AppError>?
    
    init(endPoint: EndPoint, networkRouter: NetworkRouter) {
        self.endPoint = endPoint
        self.networkRouter = networkRouter
    }
    
    override func main() {
        print("main called")
    }
    
    override func start() {
        if isCancelled {
            return
        }
        networkRouter.request(endPoint) { (result: Result<T, AppError>) in
            if self.isCancelled {
                return
            }
            self.result = result
            self.completionBlock?()
        }
    }
}
