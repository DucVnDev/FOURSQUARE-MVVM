//
//  DetailCellViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 04/05/2022.
//

import Foundation

// MARK: - DetailPlaceCellViewModel
struct DetailPlaceCellViewModel {
    var id: String
    var name: String
    var address: String
    var category: String
    var latidute: Double
    var longitude: Double
    var distance: Double?
    var locality: String?
}
