//
//  FavouriteViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 14/05/2022.
//

import Foundation
import RealmSwift

class FavouriteViewModel {
    var reloadTableView: (() -> Void)?
    
    let latitude = 16.047079
    let longitude = 108.206230
    
    //ListPlace
    private var placesCellViewModel = [PlaceTableViewCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //FavouritePlace
    private var placesFavouriteCellViewModel = [PlaceTableViewCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //DetailPlace
    private var detailCellsVM = [DetailPlaceCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //Farourite
    private var placeFavouriteCellViewModel = PlaceTableViewCellViewModel(fsqID: "", title: "", subtitle: "", distance: 0, locality: "", desc: "")
    
    private var imgURLString : String = ""
    
    //DetailPlace
    private var detailCellVM = DetailPlaceCellViewModel(id: "", name: "", address: "", category: "", latidute: 0, longitude: 0)
    
    //Realm Database
    private var realm = try! Realm()
    
    private var networkingAPI : NetworkingService
    
    init(networkingAPI: NetworkingService = NetworkingAPI()){
        self.networkingAPI = networkingAPI
    }
    
    //MARK: - Public Method
    //Check Bool RightBarButtonItem
    func isEnabledButtonItem() -> Bool {
        var isEnabled : Bool = true
        if realm.isEmpty {
            isEnabled = false
        }
        return isEnabled
    }
    
    //Realm Delete All Data
    func deleteAllData() {
        try! realm.write({
            realm.deleteAll()
        })
        self.placesFavouriteCellViewModel = []
    }
    
    //Count Place Near Me
    func countPlaceNearMe() -> Int {
        return placesCellViewModel.count
    }
    
    //Get Cell ViewModel
    func getCellViewModel(at indexPath: IndexPath) -> PlaceTableViewCellViewModel {
        return placesCellViewModel[indexPath.row]
    }
    
    //Get Cell DetailVM
    func getDetailCellViewModel(at indexPath: IndexPath) -> DetailPlaceCellViewModel {
        networkingAPI.fetchNearByPlaces(latitude: self.latitude, longitude: self.longitude) { [weak self] places in
            guard let self = self else { return }
            let place = places[indexPath.row]
            let detailPlaceCell = DetailPlaceCellViewModel(
                id: place.fsqID,
                name: place.name,
                address: place.location.formattedAddress,
                category: place.categories.first?.name ?? "",
                latidute: place.geocodes.main.latitude,
                longitude: place.geocodes.main.longitude)
            self.detailCellVM = detailPlaceCell
        }
        return self.detailCellVM
    }
    
    
    func fetchData() {
        let realmDB = try! Realm().objects(FavouritePlacesItem.self)
        let placeDb = Array(realmDB)
        //print("Count placeDb = \(placeDb.count)")
        var vms = [PlaceTableViewCellViewModel]()
        placeDb.forEach { place in
            let fsqID = place.id
            let title = place.name
            let subtitle = place.category
            let distance = place.distance
            let locality = place.locality
            let desc = place.desc
            let vm = PlaceTableViewCellViewModel(fsqID: fsqID, title: title, subtitle: subtitle, distance: distance, locality: locality, desc: desc)
            vms.append(vm)
        }
        self.placesFavouriteCellViewModel = vms
        //print("Count Cell: \(placesFavouriteCellViewModel)")
        
        //PlaceDetailVM
        var dpvm = [DetailPlaceCellViewModel]()
        placeDb.forEach { place in
            let id = place.id
            let name = place.name
            let address = place.locality
            let category = place.category
            let distance = place.distance
            let locality = place.locality
            let latitude = place.latitude
            let longitude = place.longitude
            //let desc = place.desc
            let detailPlaceCell = DetailPlaceCellViewModel(id: id, name: name, address: address, category: category , latidute: latitude, longitude: longitude, distance: distance, locality: locality)
            dpvm.append(detailPlaceCell)
        }
        detailCellsVM = dpvm
        //print("Count Detail Cells VM: \(detailCellsVM)")
        
    }
    
    func getFavouritePlace(at indexPath: IndexPath) -> PlaceTableViewCellViewModel {
        return placesFavouriteCellViewModel[indexPath.row]
    }
    
    func countFavouritePlace() -> Int {
        return placesFavouriteCellViewModel.count
    }
    
    func getDetailCellVM(at indexPath: IndexPath) -> DetailPlaceCellViewModel {
        return self.detailCellsVM[indexPath.row]
    }
    
}

