import UIKit
import Eureka
import MapKit
import CoreLocation

class DetailsViewController: FormViewController {

    var item: Item!
    var delegate: detailsViewDelegate?
    var index: IndexPath!
    
    var enabledInfo: Bool = false
    var didChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        configForm()
    }
    
    func configForm() {
        
        form
            +++ Section("Name"){
                $0.header?.height = { 50 }
            }
            <<< LabelRow(){ nameRow in
                nameRow.value = item.name
                nameRow.tag = "nameRow"
                }.cellSetup{ cell, row in
                    cell.detailTextLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
            
            +++ Section("UUID"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ uuid in
                uuid.value = item.uuid.uuidString
                uuid.tag = "uuidRow"
                }.cellSetup{ (cell, row) in
                    cell.detailTextLabel?.font = .italicSystemFont(ofSize: 16.0)
                    cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            }
            
            // CHECK INPUT FOR MAJOR & MINOR
            +++ Section("Major"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ majorRow in
                majorRow.value = "\(item.majorValue)"
                majorRow.tag = "majorRow"
                }.cellUpdate{ cell, row in
                    cell.detailTextLabel?.font = .italicSystemFont(ofSize: 16.0)
            }
            
            +++ Section("Minor"){
                $0.header?.height = { 15 }
            }
            <<< LabelRow(){ minorRow in
                minorRow.value = "\(item.minorValue)"
                minorRow.tag = "minorRow"
                }.cellUpdate{ cell, row in
                    cell.detailTextLabel?.font = .italicSystemFont(ofSize: 16.0)
                }
        
            +++ Section() {
                $0.header?.height = { 50 }
            }
            <<< SwitchRow("switchRow"){
                $0.title = "Tracking"
                $0.value = item.enabled
                }.onChange{
                    self.enabledInfo = $0.value!
                    self.didChange = true
                 }
        
            +++ Section("Last location"){
                $0.header?.height = { 50 }
            }
            
            <<< ViewRow<MKMapView>().cellSetup{ (cell, row) in
                if let coord = CLLocationCoordinate2D(propertyListRepresentation: self.item.lastLoc) {
                    let centerCoordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)

                    cell.view = MKMapView()
                    cell.contentView.addSubview(cell.view!)
                    cell.viewLeftMargin = 5.0
                    cell.viewRightMargin = 5.0
                    cell.height = { return CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 280 : 210) }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = centerCoordinate
                    annotation.title = self.item.name
                    let span = MKCoordinateSpanMake(0.1, 0.1)
                    let region = MKCoordinateRegionMake(centerCoordinate, span)
                    cell.view?.addAnnotation(annotation)
                    cell.view?.region = region

                    cell.view?.mapType = MKMapType.standard
                    cell.view?.isZoomEnabled = true
                    cell.view?.isScrollEnabled = true
                } else {
                    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 5.0, height: 5.0))
                    messageLabel.text = "No data"
                    messageLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                    messageLabel.numberOfLines = 0;
                    messageLabel.textAlignment = .center;
                    messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
                    messageLabel.sizeToFit()
                    
                    cell.backgroundView = messageLabel
                }
            }
        }
}

extension DetailsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if didChange {
            (viewController as? BeaconListViewController)?.items[index.row].enabled = enabledInfo
            delegate?.didChangeEnabled(indexPath: index, tracking: enabledInfo)
        }
    }
}
