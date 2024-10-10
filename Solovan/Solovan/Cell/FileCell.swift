

import UIKit

class FileCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbName.setFontSize(size: 18)
        lbSize.setFontSize(size: 10)
    }

}
