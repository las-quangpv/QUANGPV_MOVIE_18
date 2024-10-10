import UIKit

class ActingHisItemCell: UITableViewCell {
    //MARK: -outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    
    //MARK: -properties
    var yearStr: String = "" {
        didSet {
            yearLabel.text = yearStr
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundView.layer.cornerRadius = 3.5
        roundView.backgroundColor = UIColor(rgb: 0x302E2E)
        yearLabel.textColor = UIColor(rgb: 0x6236FF)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
