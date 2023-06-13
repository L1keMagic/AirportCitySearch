//
//  BaseCoordinator.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 13.06.2023.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Chilren should impletent 'start'")
    }
    
    
}
