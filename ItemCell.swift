import UIKit

enum BeaconStatus {
    case on
    case off
    case unknown
}

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
       
    @IBOutlet weak var beaconStatusView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    var beaconStatus = BeaconStatus.on
    
    var item: Item? = nil {
        didSet {
            if let item = item {
                imgIcon.image = Icon(rawValue: item.icon)?.image()
                imgIcon.layer.cornerRadius = 10
                imgIcon.layer.masksToBounds = true
                lblName.text = item.name
                lblLocation.font = .italicSystemFont(ofSize: 16.0)
                lblLocation.text = item.locationString()
            } else {
                imgIcon.image = nil
                lblName.text = ""
                lblLocation.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        cellView.layer.cornerRadius = 3
        cellView.layer.masksToBounds = true
        refreshLocation()

        super.awakeFromNib()
    }
    
    func updateCellColor(enabled: Bool) {
        if enabled {
            cellView.backgroundColor = .white
            lblName.alpha = 1.0
            lblLocation.alpha = 1.0
            if lblLocation.text == "Cannot find beacon" {
                beaconStatus = .unknown
            } else {
                beaconStatus = .on
            }
            
        } else {
            cellView.backgroundColor = UIColor.groupTableViewBackground
            lblName.alpha = 0.5
            lblLocation.alpha = 0.5
            beaconStatus = .off
        }
        updateStatusColor()
    }

    func updateStatusColor() {
        switch beaconStatus {
        case .on:
            beaconStatusView.backgroundColor = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1.0)
        case .off:
            beaconStatusView.backgroundColor = .red
        case .unknown:
            beaconStatusView.backgroundColor = .yellow
        }
    }
    
    func refreshLocation() {
        lblLocation.text = item?.locationString() ?? ""
        
        if lblLocation.text == "Cannot find beacon" {
            beaconStatus = .unknown
        } else {
            beaconStatus = .on
        }
        
        if item?.enabled == false {
            lblLocation.text = "Off"
            beaconStatus = .off
        }
        updateStatusColor()
    }
}
