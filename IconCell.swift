import UIKit

class IconCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
    }
    
    var icon: Icon? {
        didSet {
            guard let icon = icon else { return }
            iconImage.image = icon.image()
        }
    }
}

