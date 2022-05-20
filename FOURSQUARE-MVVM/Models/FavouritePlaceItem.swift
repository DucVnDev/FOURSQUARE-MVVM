import Foundation
import RealmSwift

class FavouritePlacesItem: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var category: String = ""
    @Persisted var distance: Double = 0
    @Persisted var locality: String = ""
    @Persisted var address: String = ""
    @Persisted var latitude : Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var desc: String = ""

    convenience init(id: String, name: String, category: String, distance: Double, locality: String, desc: String, latitude: Double, longitude: Double, address: String) {
        self.init()
        self.id = id
        self.name = name
        self.category = category
        self.distance = distance
        self.locality = locality
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}
