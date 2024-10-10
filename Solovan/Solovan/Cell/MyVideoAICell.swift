

import UIKit

class MyVideoAICell: UICollectionViewCell {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    var index = 0
    var itemMoreBlock:((Int) -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionMore(_ sender: Any) {
        itemMoreBlock(index)
    }
}
