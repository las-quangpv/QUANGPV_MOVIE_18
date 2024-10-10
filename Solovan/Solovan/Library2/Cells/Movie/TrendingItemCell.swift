import UIKit
import SDWebImage
class TrendingItemCell: UICollectionViewCell {
    
    
    // MARK: -outlets
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        posterImage.layer.cornerRadius = 15
        posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        
        voteView.layer.cornerRadius = 11
        voteView.backgroundColor = UIColor.black.withAlphaComponent(0.64)
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                posterImage.sd_setImage(with: movie.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                voteLabel.text = movie.voteAverageStr
            }
        }
    }
    
}
