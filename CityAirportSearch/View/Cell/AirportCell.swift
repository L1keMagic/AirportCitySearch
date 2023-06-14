//
//  AirportCell.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 14.06.2023.
//

import UIKit

class AirportCell: UITableViewCell {

    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var lenghLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(usingViewModel viewModel: AirportViewPresentable) -> Void {
        airportNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.formattedDistance
        countryLabel.text = viewModel.address
        lenghLabel.text = viewModel.runwayLength
        self.selectionStyle = .none
    }
    
}
