import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    var item: Item? = nil {
        didSet {
            if let item = item {
                //imgIcon.image = Icon(rawValue: item.icon)?.image()
                
                //imgIcon.layer.cornerRadius = 10
                //imgIcon.layer.masksToBounds = true
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
    /*
    override func awakeFromNib() {
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    */
    
    func refreshLocation() {
        lblLocation.text = item?.locationString() ?? ""
    }
}
