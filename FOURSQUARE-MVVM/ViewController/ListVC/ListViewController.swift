//
//  ListSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var manager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?

    let viewModel = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()

        //Get Current Location
        getCurrentLocation()

        //BindViewModel
        bindViewModel()

        //Fetch Place Near Me
        fetchViewModel()
    }


    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }

    // MARK: - Private Methods
    private func fetchViewModel() {
        viewModel.fetchPlaceNearMe(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)
    }

    private func setupUI() {
        navigationItem.title = "List Places"
        //Delegate & DataSource
        tableView.delegate = self
        tableView.dataSource = self

        //Register Xib
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")

        //Estimate Row Height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func getCurrentLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest //Battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        guard let sourceCoordinate = manager.location?.coordinate
        else {
            print("Error Source Coordinate")
            return
        }
        self.latitude = Double(sourceCoordinate.latitude)
        self.longitude = Double(sourceCoordinate.longitude)
    }

    private func bindViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countPlaceNearMe()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
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

//MARK: -ListSearchViewController: CLLocationManagerDelegate
extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("mylocation: \(location.coordinate)")
            manager.stopUpdatingLocation()
        }
    }
}
