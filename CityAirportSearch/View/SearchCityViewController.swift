import UIKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController, Storyboardable {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!
    
    private static let CellId = "CityCellId"
    
    private let bag = DisposeBag()
    
    private lazy var datasource = RxTableViewSectionedReloadDataSource<CityItemsSection>(configureCell: { _, tableView, indexPath, item in
        
        let cityCell = tableView.dequeueReusableCell(withIdentifier: SearchCityViewController.CellId, for: indexPath) as! CityCell
        cityCell.configure(usingViewModel: item)
        return cityCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(),
            citySelect: tableView.rx.modelSelected(CityViewModel.self).asDriver()
        ))
        setupUI()
        setupBinding()
    }
}

private extension SearchCityViewController {
    func setupUI() -> Void {
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: SearchCityViewController.CellId)
        self.title = "Airports"
    }
    
    func setupBinding() -> Void {
        self.viewModel.output.cities
            .drive(tableView.rx.items(dataSource: self.datasource))
            .disposed(by: bag)
    }
}
