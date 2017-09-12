import UIKit
import Foundation

extension BeaconListViewController {
    func displayEmptyData(message:String, on viewController: UIViewController) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        
        self.beaconTableView.backgroundView = messageLabel
        self.beaconTableView.separatorStyle = .none
    }
    
    
    
    func isDataEmpty(data: [Item]) -> Bool {
        if data.isEmpty {
            return true
        } else {
            return false
        }
    }
}
