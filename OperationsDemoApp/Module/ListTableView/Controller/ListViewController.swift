//
//  ListViewController.swift
//  OperationsDemoApp
//
//  Created by Debarshee on 5/3/21.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet private weak var listTableView: UITableView! {
        didSet {
            self.listTableView.dataSource = self
            self.listTableView.delegate = self
        }
    }
    lazy var listViewModel = ListViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewModel.fetchData()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listViewModel.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellIdentifier, for: indexPath) as? ListTableViewCell else {
            fatalError("Failed to dequeue the cell")
        }
        let data = self.listViewModel.listData(at: indexPath.row)
        cell.configure(configurator: data)
        self.listViewModel.check(for: data, at: indexPath, in: tableView)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.listViewModel.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.listViewModel.resumeAllOperations()
            self.listViewModel.performOperationForOnscreenCells(in: self.listTableView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.listViewModel.resumeAllOperations()
        self.listViewModel.performOperationForOnscreenCells(in: self.listTableView)
    }
}

extension ListViewController: ListViewModelDelegate {
    func reloadData() {
        self.listTableView.reloadData()
    }
}
