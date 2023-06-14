import UIKit
import RxSwift
import RxDataSources

class AirportsViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: AirportsViewPresentable!
    var viewModelBuilder: AirportsViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    private static let CellId = "AirportCellId"
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AirportItemsSection>(configureCell: { (_, tableView, indexPath, item) in
        let airportCell = tableView.dequeueReusableCell(withIdentifier: AirportsViewController.CellId, for: indexPath) as! AirportCell
        airportCell.configure(usingViewModel: item)
        return airportCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = viewModelBuilder(())
        self.setupUI()
        self.setupBinding()
    }
}

private extension AirportsViewController {
    func setupUI() -> Void {
        tableView.register(UINib(nibName: "AirportCell", bundle: nil),
                           forCellReuseIdentifier: AirportsViewController.CellId)
    }
    func setupBinding() -> Void {
        
        self.viewModel.output.airports
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: bag)
    }
}
