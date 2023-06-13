//
//  CityCell.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 14.06.2023.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(usingViewModel viewModel: CityViewPresentable) {
        self.cityLabel.text = viewModel.city
        self.LocationLabel.text = viewModel.location
    }
}
