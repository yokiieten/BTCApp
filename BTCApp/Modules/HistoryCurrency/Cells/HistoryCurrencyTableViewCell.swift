//
//  HistoryCurrencyTableViewCell.swift
//  BTCApp
//
//  Created by Sahassawat on 6/6/2566 BE.
//

import UIKit

class HistoryCurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        shadowView.addShadow(ofColor: .black.withAlphaComponent(0.25), radius: 5, offset: CGSize(width: 0, height: 4))
    }
    
    func config(bpi: Bpi) {
        usdLabel.text = bpi.usd.rate
        gbpLabel.text = bpi.gbp.rate
        eurLabel.text = bpi.eur.rate
    }
    
}
