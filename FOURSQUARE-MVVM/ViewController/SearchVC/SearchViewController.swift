import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()
        
        //BindViewModel
        bindViewModel()
    }
    
    //Configure searchController
    private func setupUI() {
        navigationItem.title = "Search Places"
        
        //Configure searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        //Configure tableView
        //Delegate & DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        //Register Xib
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        
        //Estimate Row Height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        viewModel.fetchFilterPlace(searchText)
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != nil {
            return viewModel.countFilterPlace()
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != nil {
            let cellVM = viewModel.getCellViewModel(at: indexPath)
            cell.updateCellViewModelWith(cellVM, at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            let item = viewModel.getDetailCellViewModel(at: indexPath)
            let vc = DetailPlaceInfoViewController()
            vc.viewModel.getDetailPlaceCellVM(item)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - SearchViewController: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        viewModel.fetchPlaceNearMe()
    }
}

//MARK: - SearchViewController: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
    }
}


