//
//  RequiredOperations.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import Foundation

class RequiredOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    lazy var filterInProgress: [IndexPath: Operation] = [:]
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Filter queue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    // MARK: - Add download operations to the Download Queue
    func addDownload(operation: Operation, at indexPath: IndexPath) {
        downloadsInProgress[indexPath] = operation
        downloadQueue.addOperation(operation)
    }
    
    // MARK: - Remove download operations from the Download Queue
    func removeDownloadOperation(at indexPath: IndexPath) {
        downloadsInProgress.removeValue(forKey: indexPath)
    }
    
    // MARK: - Add filter operations to the Filtration Queue
    func addFilter(operation: Operation, at indexPath: IndexPath) {
        filterInProgress[indexPath] = operation
        filtrationQueue.addOperation(operation)
    }
    
    // MARK: - Remove filter operations from the Filtration Queue
    func removeFilterOperation(at indexPath: IndexPath) {
        filterInProgress.removeValue(forKey: indexPath)
    }
    
    // MARK: - Get the download operations in Download Queue
    func downloadOperation(at indexPath: IndexPath) -> Operation? {
        downloadsInProgress[indexPath]
    }
    
    // MARK: - Get the filter operations in Filtration Queue
    func filterOperation(at indexPath: IndexPath) -> Operation? {
        filterInProgress[indexPath]
    }
}
