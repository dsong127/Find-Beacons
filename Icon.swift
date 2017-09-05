import UIKit


enum Icon: Int {
    case bag = 0
    case cat
    case key
    case wallet
    case customItem
    
    func image() -> UIImage? {
        return UIImage(named: "\(self.name())")
    }
    
    func name() -> String {
        switch self {
        case .bag:
            return "Icon_Bag"
        case .cat:
            return "Icon_Cat"
        case .key:
            return "Icon_Key"
        case .wallet:
            return "Icon_Wallet"
        case .customItem:
            return "Icon_CustomItem"
        }
    }
    
    static func icon(forTag tag: Int) -> Icon {
        return Icon(rawValue: tag) ?? .customItem
    }
    
    static let allIcons: [Icon] = {
        var all = [Icon]()
        var index: Int = 0
        while let icon = Icon(rawValue: index) {
            all += [icon]
            index += 1
        }
        
        return all.sorted { $0.rawValue < $1.rawValue }
    }()
}

