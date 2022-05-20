//
//  SearchViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 04/05/2022.
//

import Foundation
import CoreLocation

class SearchViewModel {

    var reloadTableView:  (() -> Void)?

    private var manager = CLLocationManager()

    private var placesCellViewModel = [PlaceTableViewCellViewModel]() {
        didSet{
            reloadTableView?()
        }
    }
    private var filterPlacesViewModel = [PlaceTableViewCellViewModel]() {
        didSet{
            reloadTableView?()
        }
    }

    //DetailPlace
    private var detailCellsVM = [DetailPlaceCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    private var networkingAPI : NetworkingService

    init(networkingAPI: NetworkingService = NetworkingAPI()){
        self.networkingAPI = networkingAPI
    }

    //MARK: - Public Method
    func fetchPlaceNearMe() {
        guard let sourceCoordinate = manager.location?.coordinate else { return }

        networkingAPI.fetchNearByPlaces(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude) { [weak self] places in
            guard let self = self else { return }

            //Places
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
        }
    }

    func fetchFilterPlace(_ searchText: String) {
        guard let sourceCoordinate = manager.location?.coordinate else { return }
        networkingAPI.fetchNearByPlaces(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude) { [weak self] places in
            guard let self = self else { return }
            //FilterPlace
            let filterPlaces = places.filter ({ result in
                return result.name.lowercased().contains(searchText.lowercased())
            })
            var fvms = [PlaceTableViewCellViewModel]()
            for place in filterPlaces {
                let fsqID = place.fsqID
                let title = place.name
                let subtitle = place.categories.first?.name ?? ""
                let distance = Double(place.distance)
                let locality = place.location.locality ?? ""
                let desc = ""
                let vm = PlaceTableViewCellViewModel(fsqID: fsqID, title: title, subtitle: subtitle, distance: distance, locality: locality, desc: desc, imgURL: nil)
                fvms.append(vm)
            }
            self.filterPlacesViewModel = fvms

            //PlaceDetailVM
            var dpvm = [DetailPlaceCellViewModel]()
            for place in filterPlaces {
                let id = place.fsqID
                let name = place.name
                let address = place.location.formattedAddress
                let category = place.categories.first?.name
                let latitude = place.geocodes.main.latitude
                let longtitude = place.geocodes.main.longitude
                let detailPlaceCell = DetailPlaceCellViewModel(id: id, name: name, address: address, category: category ?? "", latidute: latitude, longitude: longtitude)
                dpvm.append(detailPlaceCell)
            }
            self.detailCellsVM = dpvm
        }
    }

    //Count Place Near Me
    func countFilterPlace() -> Int {
        return filterPlacesViewModel.count
    }

    func countPlaceNearMe() -> Int {
        return placesCellViewModel.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> PlaceTableViewCellViewModel {
        return filterPlacesViewModel[indexPath.row]
    }

    func getDetailCellViewModel(at indexPath: IndexPath) -> DetailPlaceCellViewModel {
        return detailCellsVM[indexPath.row]
    }
}


