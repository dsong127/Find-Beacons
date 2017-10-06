import Foundation
import CoreLocation

struct ItemConstant {
    static let nameKey = "name"
    static let iconKey = "icon"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
    static let enabled = "enabled"
}

class Item: NSObject, NSCoding {
    let name: String
    let icon: Int
    let uuid: UUID
    let minorValue: CLBeaconMinorValue
    let majorValue: CLBeaconMajorValue
    var enabled: Bool
    var beacon: CLBeacon?
    
    init(name: String, icon: Int, uuid: UUID, majorValue: Int, minorValue: Int, enabled: Bool) {
        self.name = name
        self.icon = icon
        self.uuid = uuid
        self.minorValue = CLBeaconMinorValue(minorValue)
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.enabled = enabled
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid, major: majorValue, minor: minorValue, identifier: name)
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Cannot find beacon" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
            
        var location = "Location: \(proximity)"
        
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        return location
    }
        
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
        
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: ItemConstant.nameKey) as? String,
                let uuid = aDecoder.decodeObject(forKey: ItemConstant.uuidKey) as? UUID
        else { return nil }

        self.init(
            name: name,
            icon: aDecoder.decodeInteger(forKey: ItemConstant.iconKey),
            uuid: uuid,
            majorValue: aDecoder.decodeInteger(forKey: ItemConstant.majorKey),
            minorValue: aDecoder.decodeInteger(forKey: ItemConstant.minorKey),
            enabled: aDecoder.decodeBool(forKey: ItemConstant.enabled)
        )
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: ItemConstant.nameKey)
        aCoder.encode(self.icon, forKey: ItemConstant.iconKey)
        aCoder.encode(self.uuid, forKey: ItemConstant.uuidKey)
        aCoder.encode(Int(self.majorValue), forKey: ItemConstant.majorKey)
        aCoder.encode(Int(self.minorValue), forKey: ItemConstant.minorKey)
        //aCoder.encode(enabled, forKey: ItemConstant.enabled)
        aCoder.encode(self.enabled, forKey: ItemConstant.enabled)
        
    }
}

func ==(item: Item, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
    
}
