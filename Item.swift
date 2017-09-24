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
    let enabled: Bool
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
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: ItemConstant.nameKey) as? String
        name = aName ?? ""
        
        let aUUID = aDecoder.decodeObject(forKey: ItemConstant.uuidKey) as? UUID
        uuid = aUUID ?? UUID()
        
        icon = aDecoder.decodeInteger(forKey: ItemConstant.iconKey)
        majorValue = UInt16(aDecoder.decodeInteger(forKey: ItemConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: ItemConstant.minorKey))
        
        let aEnabled = aDecoder.decodeObject(forKey: ItemConstant.enabled) as? Bool
        enabled = aEnabled ?? false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: ItemConstant.nameKey)
        aCoder.encode(icon, forKey: ItemConstant.iconKey)
        aCoder.encode(uuid, forKey: ItemConstant.uuidKey)
        aCoder.encode(Int(majorValue), forKey: ItemConstant.majorKey)
        aCoder.encode(Int(minorValue), forKey: ItemConstant.minorKey)
        aCoder.encode(enabled, forKey: ItemConstant.enabled)
    }
}

func ==(item: Item, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}
