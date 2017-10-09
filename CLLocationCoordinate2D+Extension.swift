//
//  Converts CLLocationCoordinate2D into dictionary
//  for NSCoding compatibility.
//  

import UIKit
import CoreLocation

extension CLLocationCoordinate2D: PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary {
        let representation:[String:CLLocationDegrees] = ["lat":self.latitude, "long":self.longitude]
        return representation as NSDictionary
    }
    
    init?(propertyListRepresentation: NSDictionary?) {
        guard let values = propertyListRepresentation else { return nil }
        if let latCoord = values["lat"] as? CLLocationDegrees,
            let longCoord = values["long"] as? CLLocationDegrees {
                self.latitude = latCoord
                self.longitude = longCoord
        } else {
            return nil
        }
    }
}
