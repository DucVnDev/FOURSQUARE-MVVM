//
//  DetailPlaceViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 03/05/2022.
//

import Foundation
import RealmSwift

class DetailPlaceViewMode {
    var reloadCollectionView: (() -> Void)?

    private var detailPlaceCellVM = DetailPlaceCellViewModel(id: "", name: "", address: "", category: "", latidute: 0, longitude: 0, distance: 0, locality: "") {
        didSet {
            reloadCollectionView?()
        }
    }

    private var imgsUrlString = [String]() {
        didSet {
            reloadCollectionView?()
        }
    }

    private var tipsDetailPlace = [String]() {
        didSet {
            reloadCollectionView?()
        }
    }

    //Realm
    var realm = try! Realm()

    var isLike: Bool = false
    var iconRightBarButton: String = ""


    private var networkingAPI : NetworkingService
    init(networkingAPI: NetworkingService = NetworkingAPI()) {
        self.networkingAPI = networkingAPI
    }

    //MARK: - Public Method
    func checkDb() -> String {
        let placeDb = try! Realm().objects(FavouritePlacesItem.self)
        let checkDB = placeDb.where {
            $0.id == detailPlaceCellVM.id
        }.first
        if let _ = checkDB {
            self.iconRightBarButton = "heart.fill"
            //print("Database has data")
            self.isLike = true
            return self.iconRightBarButton
        } else {
            self.isLike = false
            self.iconRightBarButton = "heart"
            //print("Database is Empty")
            //print("\(self.iconRightBarButton) + \(self.isLike)")
            return self.iconRightBarButton
        }
    }

    func favouriteAction() -> String {
        if isLike {
            let place = try! Realm().objects(FavouritePlacesItem.self).first!
            try! self.realm.write({
                self.realm.delete(place)
                //print("Data is Delete")
            })
            self.iconRightBarButton = "heart"
            isLike = !isLike //false
            return self.iconRightBarButton
        } else {
            let id = self.detailPlaceCellVM.id
            let name =  self.detailPlaceCellVM.name
            let category = self.detailPlaceCellVM.category
            let distance = self.detailPlaceCellVM.distance ?? 0
            let locality = self.detailPlaceCellVM.locality ?? ""
            let latitude =  self.detailPlaceCellVM.latidute
            let longitude =  self.detailPlaceCellVM.longitude
            let address =  self.detailPlaceCellVM.address
            let newPlace = FavouritePlacesItem(id: id, name: name, category: category, distance: distance, locality: locality, desc: "", latitude: latitude, longitude: longitude, address: address)
            try! self.realm.write({
                self.realm.add(newPlace)
                //print("Data is Add")
            })
            self.iconRightBarButton = "heart.fill"
            isLike = !isLike //false
            return self.iconRightBarButton
        }
    }

    //Fetch Photos Place
    func fetchPhotoPlace(_ fsqID: String) {
        networkingAPI.fetchPhotoWith(fsqID: fsqID) { [weak self] data in
            if data.count != 0 {
                var imgsURLString : [String] = []
                for i in 0...(data.count-1) {
                    let prefix = data[i].placePhotoPrefix
                    let suffix = data[i].suffix
                    let imgURLString = "\(prefix)600x600\(suffix)"
                    imgsURLString.append(imgURLString)
                }
                self?.imgsUrlString = imgsURLString
            }
        }
    }

    //Fetch Tips Place
    func fetchTipPlace(_ fsqID: String) {
        networkingAPI.fetchTipsWith(fsqID: fsqID) { [weak self] data in
            if data.count != 0 {
                var tips: [String] = []
                for i in 0...(data.count-1) {
                    let tip = data[i].text
                    tips.append(tip)
                }
                self?.tipsDetailPlace = tips
            }
        }
    }

    //Get Detail Place from ListVC and FavoriteVC
    func getDetailPlaceCellVM (_ viewModel: DetailPlaceCellViewModel) {
        self.detailPlaceCellVM = viewModel
        print(self.detailPlaceCellVM)
    }

    //Count Photo
    func countPhotosPlace() -> Int {
        return self.imgsUrlString.count
    }

    //Count Tip
    func countTipsPlace() -> Int {
        return self.tipsDetailPlace.count
    }

    //Get Cell Photos Place
    func getPhotoCellViewModel(at indexPath: IndexPath) -> String {
        return self.imgsUrlString[indexPath.row]
    }

    //Get Cell Tips Place
    func getTipCellViewModel(at indexPath: IndexPath) -> String {
        return self.tipsDetailPlace[indexPath.row]
    }

    //Fetch Detail Cell View Model
    func fetchDetailCellVM() -> DetailPlaceCellViewModel {
        return self.detailPlaceCellVM
    }
}
