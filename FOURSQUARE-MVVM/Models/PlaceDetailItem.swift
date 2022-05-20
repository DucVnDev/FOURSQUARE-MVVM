// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let placeDetailItem = try? newJSONDecoder().decode(PlaceDetailItem.self, from: jsonData)

import Foundation

// MARK: - PlaceDetailItem
struct PlaceDetailItem: Codable {
    let fsqID: String
    let categories: [CategoryA]
    let chains: [JSONAny]
    let geocodes: GeocodesA
    let link: String
    let location: LocationA
    let name: String
    let relatedPlaces: RelatedPlacesA
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case fsqID = "fsq_id"
        case categories, chains, geocodes, link, location, name
        case relatedPlaces = "related_places"
        case timezone
    }
}

// MARK: - Category
struct CategoryA: Codable {
    let id: Int
    let name: String
    let icon: IconA
}

// MARK: - Icon
struct IconA: Codable {
    let iconPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

// MARK: - Geocodes
struct GeocodesA: Codable {
    let main: MainA
}

// MARK: - Main
struct MainA: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct LocationA: Codable {
    let address, country, crossStreet, formattedAddress: String
    let locality, postcode, region: String

    enum CodingKeys: String, CodingKey {
        case address, country
        case crossStreet = "cross_street"
        case formattedAddress = "formatted_address"
        case locality, postcode, region
    }
}

// MARK: - RelatedPlaces
struct RelatedPlacesA: Codable {
}

