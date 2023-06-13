import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol SearchCityViewPresentable {
    typealias Input = (
        searchText: Driver<String>, ()
    )
    typealias Output = ()
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
                                                 state: self.state,
                                                 bag: self.bag)
        self.airportService = airportService
        self.process()
    }
}

private extension SearchCityViewModel {
    static func output(input: SearchCityViewPresentable.Input, state: State, bag: DisposeBag) -> SearchCityViewPresentable.Output {
        
        let searchTextObservable = input.searchText
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
            
        
        let airportObservable = state.airports
            .skip(1)
            .asObservable()
        
        Observable
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
            .map {
                print($0)
            }
            .subscribe()
            .disposed(by: bag)
        
        return ()
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
