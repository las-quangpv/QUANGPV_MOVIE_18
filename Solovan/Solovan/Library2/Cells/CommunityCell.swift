import UIKit

class CommunityCell: UITableViewCell {

    static let height: CGFloat = 154
    
    var onCommunity: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectJoin(_ sender: Any) {
        onCommunity?()
    }
}
