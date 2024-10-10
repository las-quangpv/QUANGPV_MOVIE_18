import UIKit

class PListCell: UICollectionViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 9
        posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        
    }
    
    var people: People? {
        didSet {
            posterImage.sd_setImage(with: people?.profileURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
            titleLabel.text = people?.name
        }
    }
}
