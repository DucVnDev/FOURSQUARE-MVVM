//
//  FavouriteViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 23/03/2022.
//
import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var rightButton = UIBarButtonItem()

    var viewModel = FavouriteViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()

        //Bind ViewModel
        bindViewModel()

        //Fetch Data
        fetchData ()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        let isEnabled = viewModel.isEnabledButtonItem()
        //print("RightBarButton: \(isEnabled)")
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        if isEnabled {
            navigationItem.rightBarButtonItem = rightButton
            navigationItem.rightBarButtonItem?.title = "Delete All"
        } else {
            navigationItem.rightBarButtonItem?.title = ""
        }
    }

    // MARK: -Private Methods
    private func setupUI() {
        navigationItem.title = "Favourite"

        //navigationBar
        rightButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(rightAction))

        //Check Bool RightBarButtonItem

        let isEnabled = viewModel.isEnabledButtonItem()
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        if isEnabled {
            navigationItem.rightBarButtonItem = rightButton
        }

        //TableView
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
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

    private func fetchData() {
        viewModel.fetchData()
    }

    @objc func rightAction() {
        //Realm Delete All Data
        viewModel.deleteAllData()
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
    }
}
//MARK: -FavouriteViewController: UITableViewDelegate, UITableViewDataSource
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countFavouritePlace()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let cellVM = viewModel.getFavouritePlace(at: indexPath)
        cell.updateCellViewModelWith(cellVM, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getDetailCellVM(at: indexPath)
        let vc = DetailPlaceInfoViewController()
        vc.viewModel.getDetailPlaceCellVM(item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
