//
//  ViewController.swift
//  BTCApp
//
//  Created by Sahassawat on 5/6/2566 BE.
//


import UIKit

class BtcViewController: UIViewController {
    let viewModel = BtcViewModel()
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
        startAutoUpdate()
        viewModel.didUpdatePrice = { [weak self] in
                   self?.updateUI()
               }
    }
    
    private func startAutoUpdate() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.viewModel.fetchData()
        }
    }
    
    private func updateUI() {
        guard let btcData = viewModel.btcData else {
            return
        }
        
        usdLabel.text = "\(btcData.bpi.usd.symbol) \(btcData.bpi.usd.rate)"
        gbpLabel.text = "\(btcData.bpi.gbp.symbol) \(btcData.bpi.gbp.rate)"
        eurLabel.text = "\(btcData.bpi.eur.symbol) \(btcData.bpi.eur.rate)"
    }
    
    @IBAction func tapViewHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HistoryCurrency", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HistoryCurrencyViewController") as? HistoryCurrencyViewController else { return }
        vc.viewModel.historicalData = viewModel.historicalData
        present(vc, animated: true)
    }
}
