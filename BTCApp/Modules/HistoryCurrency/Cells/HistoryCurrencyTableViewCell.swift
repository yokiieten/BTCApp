//
//  HistoryCurrencyTableViewCell.swift
//  BTCApp
//
//  Created by Sahassawat on 5/6/2566 BE.
//

import UIKit

class HistoryCurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(bpi: Bpi) {
        usdLabel.text = bpi.usd.rate
        gbpLabel.text = bpi.gbp.rate
        eurLabel.text = bpi.eur.rate
    }
    
}
