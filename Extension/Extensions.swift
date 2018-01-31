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

//
//  Extension for TableView to display
//  A message if data is empty.
//

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
}

//
//  Dismiss keyboard when tapped
//

extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
