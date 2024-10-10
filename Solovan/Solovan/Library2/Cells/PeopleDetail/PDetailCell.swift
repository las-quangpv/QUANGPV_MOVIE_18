import UIKit

class PDetailCell: UITableViewCell {
    //MARK: -properties
    
    static let height: CGFloat = 156
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        posterImage.layer.cornerRadius = 9
        posterImage.clipsToBounds = true
        posterImage.setImageBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var people: People! {
        didSet {
            if people != nil {
                posterImage.sd_setImage(with: people.profileURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = people.name
                birthdayLabel.text = people.birthdayStr + "(" + people.yearOld + " years old)"
            }
        }
    }
    
}
