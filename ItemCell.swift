import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var beaconStatusView: UIView!
    @IBOutlet weak var cellView: UIView!
    
  
    var item: Item? = nil {
        didSet {
            if let item = item {
                imgIcon.image = Icon(rawValue: item.icon)?.image()
                imgIcon.layer.cornerRadius = 10
                imgIcon.layer.masksToBounds = true
                lblName.font = .italicSystemFont(ofSize: 16.0)
                lblName.text = item.name
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

        super.awakeFromNib()
    }
    
    func disableCellColor() {
        cellView.backgroundColor = UIColor.groupTableViewBackground
        lblName.alpha = 0.5
        lblLocation.alpha = 0.5
        beaconStatusView.backgroundColor = .red
    }
    
    func enableCellColor() {
        cellView.backgroundColor = .white
        lblName.alpha = 1.0
        lblLocation.alpha = 1.0
        
        beaconStatusView.backgroundColor = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1.0)
    }
    
    func refreshLocation() {
        lblLocation.text = item?.locationString() ?? ""
    }
}
