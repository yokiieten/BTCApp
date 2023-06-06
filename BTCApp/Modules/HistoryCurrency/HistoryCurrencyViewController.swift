//
//  HistoryCurrencyViewController.swift
//  BTCApp
//
//  Created by Sahassawat on 5/6/2566 BE.
//

import UIKit

class HistoryCurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HistoryCurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerCells(classNames: [HistoryCurrencyTableViewCell.reuseIdentifer])
    }

}

extension HistoryCurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historicalData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCurrencyTableViewCell", for: indexPath) as? HistoryCurrencyTableViewCell else { return UITableViewCell() }
        cell.config(bpi: viewModel.historicalData[indexPath.row].bpi)
        return cell
    }
    
    
}

extension HistoryCurrencyViewController: UITableViewDelegate {
}
