//
//  ListViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 18/04/2022.
//

import Foundation

class ListViewModel {

    var reloadTableView: (() -> Void)?

    //ListPlace
    private var placesCellViewModel = [PlaceTableViewCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    //DetailPlace
    private var detailCellsVM = [DetailPlaceCellViewModel]()

    private var networkingAPI : NetworkingService
    init(networkingAPI: NetworkingService = NetworkingAPI()){
        self.networkingAPI = networkingAPI
    }

    //MARK: - Public Method
    //Fetch Place Near Me
    func fetchPlaceNearMe(latitude: Double, longitude: Double) {
        networkingAPI.fetchNearByPlaces(latitude: latitude , longitude: longitude ) { [weak self] places in
            guard let self = self else { return }

            //PlaceTableViewCellViewModel
            var vms = [PlaceTableViewCellViewModel]()
            for place in places {
                let fsqID = place.fsqID
                let title = place.name
                let subtitle = place.categories.first?.name ?? ""
                let distance = Double(place.distance)
                let locality = place.location.locality ?? ""
                let desc = ""
                let vm = PlaceTableViewCellViewModel(fsqID: fsqID, title: title, subtitle: subtitle, distance: distance, locality: locality, desc: desc, imgURL: nil)
                vms.append(vm)
            }
            self.placesCellViewModel = vms

            //PlaceDetailVM
            var dpvm = [DetailPlaceCellViewModel]()
            for place in places {
                let id = place.fsqID
                let name = place.name
                let address = place.location.formattedAddress
                let category = place.categories.first?.name
                let latitude = place.geocodes.main.latitude
                let longtitude = place.geocodes.main.longitude
                let distance = Double(place.distance)
                let locality = place.location.locality
                let detailPlaceCell = DetailPlaceCellViewModel(id: id, name: name, address: address, category: category ?? "", latidute: latitude, longitude: longtitude, distance: distance  , locality: locality ?? "")
                dpvm.append(detailPlaceCell)
            }
            self.detailCellsVM = dpvm
        }
    }

    //Count Place Near Me
    func countPlaceNearMe() -> Int {
        return placesCellViewModel.count
    }

    //Get Detail CellVM
    func getDetailCellVM(at indexPath: IndexPath) -> DetailPlaceCellViewModel {
        return self.detailCellsVM[indexPath.row]
    }

    //Get Cell ViewModel
    func getCellViewModel(at indexPath: IndexPath) -> PlaceTableViewCellViewModel {
        return self.placesCellViewModel[indexPath.row]
    }
}
