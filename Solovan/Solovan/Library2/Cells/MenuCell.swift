import UIKit

import SideMenu
class MenuCell: UITableViewCell {
    
    //MARK: -properties
    var menuItemText: String = "" {
        didSet {
            menuLabel.text = menuItemText
        }
    }
    //MARK: -outlets
    @IBOutlet weak var menuLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
