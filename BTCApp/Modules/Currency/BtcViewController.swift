//
//  ViewController.swift
//  BTCApp
//
//  Created by Sahassawat on 5/6/2566 BE.
//


import UIKit

enum CurrencySortOption: Int, CaseIterable {
    case usd = 0
    case gbp = 1
    case eur = 2
    
    var title: String {
        switch self {
        case .usd:
            return "USD"

        case .gbp:
            return "GBP"

        case .eur:
            return "EUR"
        }
    }
    
}

class BtcViewController: UIViewController {
    let viewModel = BtcViewModel()
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var selectCurrencyButton: UIButton!
    
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
//        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    @IBAction func showBottomSheet(_ sender: Any) {
        let transitionDelegate = BottomSheetTransitioningDelegate()
        transitionDelegate.isDisabledDismiss = false
        let allSortOption = CurrencySortOption.allCases.map {
            $0.title
        }
        let viewModel = BottomSheetViewModel(options: allSortOption, selectedIndex: viewModel.currentSelect)
        let sortViewController = BottomSheetViewController(viewModel: viewModel)
        sortViewController.transitioningDelegate = transitionDelegate
        sortViewController.delegate = self
        sortViewController.modalPresentationStyle = .custom
        navigationController?.present(sortViewController, animated: true)
    }
    
}

extension BtcViewController: BottomSheetViewControllerDelegate {
    
    
    func didSelectOption(atIndex index: Int) {
        viewModel.currentSelect = index
        let currencySortOption = CurrencySortOption(rawValue: index)
        switch currencySortOption {
        case .usd: selectCurrencyButton.setTitle("USD", for: .normal)
        case .gbp: selectCurrencyButton.setTitle("GBP", for: .normal)
        case .eur: selectCurrencyButton.setTitle("EUR", for: .normal)
        case .none: break
        }
      
    }
    
    
}
