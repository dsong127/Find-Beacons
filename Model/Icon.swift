import UIKit

enum Icon: Int {
    case bag = 0
    case wallet
    case key
    case cat
    case dog
    
    func image() -> UIImage? {
        return UIImage(named: "\(self.name())")
    }
    
    func name() -> String {
        switch self {
        case .bag:
            return "Icon_Bag"
        case .cat:
            return "Icon_Cat"
        case .dog:
            return "Icon_Dog"
        case .key:
            return "Icon_Key"
        case .wallet:
            return "Icon_Wallet"
        }
    }
    
    static func icon(forTag tag: Int) -> Icon {
        return Icon(rawValue: tag) ?? .bag
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
