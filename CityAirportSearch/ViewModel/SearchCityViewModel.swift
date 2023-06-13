import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

protocol SearchCityViewPresentable {
    typealias Input = (
        searchText: Driver<String>, ()
    )
    typealias Output = (
        cities: Driver<[CityItemsSection]>, ()
    )
    typealias ViewModelBuilder = (SearchCityViewPresentable.Input) -> SearchCityViewPresentable

    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}


class SearchCityViewModel: SearchCityViewPresentable {
    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output
    private let airportService: AirportAPI
    
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    private let state = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())
    
    private let bag = DisposeBag()
    
    init(input: SearchCityViewPresentable.Input, airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input,
                                                 state: self.state)
        self.airportService = airportService
        self.process()
    }
}

private extension SearchCityViewModel {
    static func output(input: SearchCityViewPresentable.Input, state: State) -> SearchCityViewPresentable.Output {
        
        let searchTextObservable = input.searchText
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
            
        
        let airportObservable = state.airports
            .skip(1)
            .asObservable()
        let sections = Observable
            .combineLatest(searchTextObservable, airportObservable)
            .map ({ (searchKey, airports) in
                
                return airports.filter { (airport) -> Bool in
                    !searchKey.isEmpty &&
                    airport
                        .city
                        .lowercased()
                        .replacingOccurrences(of: " ", with: "")
                        .hasPrefix(searchKey.lowercased())
                }
            })
            .map({
                SearchCityViewModel
                    .uniqueElementsFrom(array: $0.compactMap({ CityViewModel(model: $0) }))
            })
            .map({ [CityItemsSection(model: 0, items: $0)] })
            .asDriver(onErrorJustReturn: [])
//            .subscribe()
//            .disposed(by: bag)
        
        return (
            cities: sections, ()
        )
    }
    
    func process() -> Void {
        self.airportService
            .fetchAirports()
            .map({ Set($0) })
            .map({ [state] in state.airports.accept($0) })
            .subscribe()
            .disposed(by: bag)
    }
}

private extension SearchCityViewModel {
    static func uniqueElementsFrom(array: [CityViewModel]) -> [CityViewModel] {
        //Create an empty Set to track unique items
        var set = Set<CityViewModel> ()
        let result = array.filter {
            guard !set.contains ($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert ($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
}
