//
//  PlaceTableViewCellViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 02/05/2022.
//

import Foundation

typealias PlacesTableViewCellViewModel = [PlaceTableViewCellViewModel]

//MARK: -PlaceTableViewCellViewModel
struct PlaceTableViewCellViewModel {
    var fsqID: String
    //var indexPath: String
    var title: String
    var subtitle: String
    var distance: Double
    var locality: String
    var desc: String
    var imgURL: String?
}
