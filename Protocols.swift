import Foundation

protocol detailsViewDelegate {
    func didChangeEnabled(indexPath: IndexPath, tracking: Bool)
}

protocol AddItem {
    func addItem(item: Item)
}

protocol PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary
    init?(propertyListRepresentation:NSDictionary?)
}


