//
//  ListViewModel.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/4/21.
//

import Foundation
import UIKit

protocol ListViewModelDelegate: AnyObject {
    func reloadData()
}

class ListViewModel {
    
    weak var delegate: ListViewModelDelegate?
    
    private var dataSource: [ListCellViewModelProtocol] {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
    let router = Router<PhotoApi>()
    var requiredOperations: RequiredOperations
    
    // MARK: - Initializer
    init(delegate: ListViewModelDelegate, operations: RequiredOperations = RequiredOperations()) {
        self.delegate = delegate
        self.requiredOperations = operations
        self.dataSource = []
    }
    
    // MARK: - Start each operation based on the photo state
    private func startOperations(for photo: ListCellViewModelProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        switch photo.state {
        case .new:
            self.startDownload(for: photo, at: indexPath, in: tableView)
            
        case .downloaded:
            self.startFiltration(for: photo, at: indexPath, in: tableView)
            
        default:
            break
        }
    }
    
    // MARK: - Execute Download operation
    private func startDownload(for photo: ListCellViewModelProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        guard requiredOperations.downloadOperation(at: indexPath) == nil else { return }
        let downloader = DownloadImageOperation(photoData: photo)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.requiredOperations.removeDownloadOperation(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        requiredOperations.addDownload(operation: downloader, at: indexPath)
    }
    
    // MARK: - Execute Filtration operation
    private func startFiltration(for photo: ListCellViewModelProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        guard requiredOperations.filterOperation(at: indexPath) == nil else { return }
        let downloader = ApplyFilterOperation(photoData: photo)
        downloader.completionBlock = {
            if downloader.isCancelled { // check if operation is cancelled then return
                return
            }
            DispatchQueue.main.async { // if not cancelled then implement the operation and remove from queue
                self.requiredOperations.removeFilterOperation(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        requiredOperations.addFilter(operation: downloader, at: indexPath)
    }
    
    // MARK: - Public Function
    func fetchData() {
        let fetchOperation = FetchDataOperation<[Photo]>(endPoint: PhotoApi.photoCollection, networkRouter: router)
        fetchOperation.completionBlock = {
            switch fetchOperation.result {
            case .success(let data):
                for items in data {
                    let filteredData = items.tags?.filter { item -> Bool in
                       item.source != nil
                    }
                    guard let newFilteredData = filteredData else { return }
                    
                    // Configuring Photo object to PhotoData Object within ListCellViewModel
                    self.dataSource.append(contentsOf: newFilteredData.compactMap({ item -> ListCellViewModel? in
                        let photoName = item.title ?? ""
                        let photoUrl = item.source?.coverPhoto?.urls?.thumb ?? ""
                        let photoData = PhotoData(name: photoName, url: photoUrl)
                        return ListCellViewModel(photoData: photoData)
                    }))
                }
                
            case .failure(let error):
                print(error)
                
            case .none:
                print("Custom Error")
            }
        }
        fetchOperation.start()
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        self.dataSource.count
    }
    
    func listData(at index: Int) -> ListCellViewModelProtocol {
        self.dataSource[index]
    }
    
    // MARK: - Check the photo state to start operations
    func check(for photo: ListCellViewModelProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        switch photo.state {
        case .new, .downloaded:
            self.startOperations(for: photo, at: indexPath, in: tableView)
            
        case .failed:
            break
            
        case .filtered:
            break
        }
    }
    
    // MARK: - Suspend the operation queues
    func suspendAllOperations() {
        requiredOperations.downloadQueue.isSuspended = true
        requiredOperations.filtrationQueue.isSuspended = true
    }
    
    // MARK: - Resume the operation queues
    func resumeAllOperations() {
        requiredOperations.downloadQueue.isSuspended = false
        requiredOperations.filtrationQueue.isSuspended = false
    }
    
    // MARK: - Perform operations such that only Visible cells are using the operations
    func performOperationForOnscreenCells(in tableView: UITableView) {
        
        if let visibleIndexPathArray = tableView.indexPathsForVisibleRows {
            var allPendingOperations = Set(requiredOperations.downloadsInProgress.keys)
            allPendingOperations.formUnion(requiredOperations.filterInProgress.keys)
            
            // Removing visible operations from the pending operations
            var operationToCancel = allPendingOperations
            let visibleCells = Set(visibleIndexPathArray)
            operationToCancel.subtract(visibleCells)
            
            // Determining operations to be started
            var operationsToBeStarted = visibleCells
            operationsToBeStarted.subtract(allPendingOperations)
            
            operationToCancel.forEach { indexPath in
                requiredOperations.downloadOperation(at: indexPath)?.cancel()
                requiredOperations.removeDownloadOperation(at: indexPath)
                
                requiredOperations.filterOperation(at: indexPath)?.cancel()
                requiredOperations.removeFilterOperation(at: indexPath)
            }
            
            // resuming operations
            operationsToBeStarted.forEach { indexPath in
                let photo = self.listData(at: indexPath.row)
                self.check(for: photo, at: indexPath, in: tableView)
            }
        }
    }
}
