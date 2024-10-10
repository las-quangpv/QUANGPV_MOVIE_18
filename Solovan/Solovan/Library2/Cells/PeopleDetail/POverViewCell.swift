import UIKit

class POverViewCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = UITableView.automaticDimension
    
    var people: People? {
        didSet {
            if let people = people {
                overViewLabel.text = people.biography
                knowForLabel.labelTwoColor(title: "Known For: ",
                                           colorTitle: .init(rgb: 0x5B5B5B),
                                           fontTitle: UIFont.lexendRegular(16),
                                           detail: people.knowForDepartmentText ,
                                           colorDetail: .black,
                                           fontDetail: UIFont.lexendRegular(16))
                
                creditLabel.labelTwoColor(title: "Known Credits: ",
                                          colorTitle: .init(rgb: 0x5B5B5B),
                                          fontTitle: UIFont.lexendRegular(16),
                                          detail: people.yearOld ,
                                          colorDetail: .black,
                                          fontDetail: UIFont.lexendRegular(16))
                
            }
        }
    }
    
    //MARK: -outlets
    @IBOutlet weak var knowForLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        overViewLabel.numberOfLines = 0
        overViewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        overViewLabel.sizeToFit()
        
        knowForLabel.labelTwoColor(title: "Known For: ",
                                   colorTitle: .init(rgb: 0x5B5B5B),
                                   fontTitle: UIFont.lexendRegular(16),
                                   detail: "",
                                   colorDetail: .init(rgb: 0x000000),
                                   fontDetail: UIFont.lexendRegular(16))
        
        creditLabel.labelTwoColor(title: "Known Credits: ",
                                  colorTitle: .init(rgb: 0x5B5B5B),
                                  fontTitle: UIFont.lexendRegular(16),
                                  detail: "",
                                  colorDetail: .init(rgb: 0x000000),
                                  fontDetail: UIFont.lexendRegular(16))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}
