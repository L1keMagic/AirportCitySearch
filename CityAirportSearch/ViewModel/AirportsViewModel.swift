//
//  AirportsViewModel.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 14.06.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias AirportItemsSection = SectionModel<Int, AirportViewPresentable>

protocol AirportsViewPresentable {
    
    typealias Output = (
        title: Driver<String>,
        airports: Driver<[AirportItemsSection]>
    )
    typealias Input = ()
    
    typealias Dependencies = (
        title: String,
        models: Set<AirportModel>
    )
    typealias ViewModelBuilder = (AirportsViewPresentable.Input) -> AirportsViewPresentable
    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
    
}

struct AirportsViewModel: AirportsViewPresentable {

    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input
    
    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
    }
}

private extension AirportsViewModel {
    static func output(dependencies: AirportsViewPresentable.Dependencies) ->
    AirportsViewPresentable.Output {
        
        let sections = Driver.just(dependencies.models)
            .map { $0.compactMap({ AirportViewModel(usingModel: $0) }) }
            .map({ [AirportItemsSection(model: 0, items: $0)] })
        
        return (
            title: Driver.just(dependencies.title),
            airports: sections
        )
    }
}
