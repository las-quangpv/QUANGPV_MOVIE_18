

import UIKit

class MovieDbCell: UICollectionViewCell {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
    }

}
