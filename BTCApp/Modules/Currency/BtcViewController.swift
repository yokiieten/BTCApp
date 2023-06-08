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
    @IBOutlet weak var currencyValueTextField: UITextField!
    @IBOutlet weak var convertVauleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var convertBTCshadowView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
        startAutoUpdate()
        viewModel.didUpdatePrice = { [weak self] in
                   self?.updateUI()
               }
        setupView()
    }
    
    private func setupView() {
        convertBTCshadowView.addShadow(ofColor: .black.withAlphaComponent(0.25), radius: 5, offset: CGSize(width: 0, height: 4))
        shadowView.addShadow(ofColor: .black.withAlphaComponent(0.25), radius: 5, offset: CGSize(width: 0, height: 4))
        currencyValueTextField.delegate = self
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
        
        usdLabel.text = "\(btcData.bpi.usd.rate)"
        gbpLabel.text = "\(btcData.bpi.gbp.rate)"
        eurLabel.text = "\(btcData.bpi.eur.rate)"
    }
    
    @IBAction func tapViewHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HistoryCurrency", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HistoryCurrencyViewController") as? HistoryCurrencyViewController else { return }
        vc.viewModel.historicalData = viewModel.historicalData
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
    
    @IBAction func ConvertCurrency(_ sender: UIButton) {
        guard let convertValueLabel = currencyValueTextField.text else { return }
        let amount = Double(convertValueLabel)
        guard let amount = amount else { return }
        guard let currency = CurrencySortOption(rawValue: viewModel.currentSelect), viewModel.currentSelect != -1 else { return }
        let btcAmount = viewModel.convertToBTC(amount: amount, currency: currency )
        self.convertVauleLabel.text = "\(btcAmount)"
    }
    
}

extension BtcViewController: BottomSheetViewControllerDelegate {


    func didSelectOption(atIndex index: Int) {
        viewModel.currentSelect = index
        let currencySortOption = CurrencySortOption(rawValue: index)
        switch currencySortOption {
        case .usd:
            selectCurrencyButton.setTitle("USD", for: .normal)

        case .gbp: selectCurrencyButton.setTitle("GBP", for: .normal)
        case .eur: selectCurrencyButton.setTitle("EUR", for: .normal)
        case .none: break
        }
        viewModel.currentSelect = index
        errorLabel.isHidden = true
    }


}

extension BtcViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        guard viewModel.currentSelect != -1 else {
            errorLabel.isHidden = false
            return false
        }
        errorLabel.isHidden = true
        let amount = Double(updatedString)
        guard let amount = amount else { return true }
        guard let currency = CurrencySortOption(rawValue: viewModel.currentSelect), viewModel.currentSelect != -1 else { return true }
        let btcAmount = viewModel.convertToBTC(amount: amount, currency: currency )
        self.convertVauleLabel.text = "\(btcAmount)"
        return true
    }
}
