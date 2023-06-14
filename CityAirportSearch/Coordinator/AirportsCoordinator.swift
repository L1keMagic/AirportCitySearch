//
//  AirportsCoordinator.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 14.06.2023.
//

import Foundation
import UIKit

class AirportsCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let models: Set<AirportModel>
    
    init(models: Set<AirportModel>,
         navigationController: UINavigationController) {
        self.models = models
        self.navigationController = navigationController
    }
    
    override func start() {
        let view = AirportsViewController.instantiate()
        
        view.viewModelBuilder = { [models] in
            let title = models.first?.city ?? ""
            return AirportsViewModel(input: $0, dependencies: (title: title, models: models))
        }
        
        self.navigationController.pushViewController(view, animated: true)
    }
}
