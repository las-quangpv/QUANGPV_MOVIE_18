import UIKit

class MTopRatedItemCell: UICollectionViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var topRatedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topRatedLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topRatedImage.layer.cornerRadius = 15
        topRatedImage.setImageBackground()
        topRatedImage.clipsToBounds = true
        
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                topRatedImage.sd_setImage(with: movie.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                
                titleLabel.text = movie.title
                topRatedLabel.attributedText = movie.ratingStar
                topRatedLabel.textColor = UIColor(rgb: 0x5B5B5B)
                releaseDateLabel.text = movie.releaseStr
                releaseDateLabel.textColor = UIColor(rgb: 0x5B5B5B)
            }
            if let tvShow = data as? TvShow {
                topRatedImage.sd_setImage(with: tvShow.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                
                titleLabel.text = tvShow.name
                topRatedLabel.attributedText = tvShow.ratingStar
                topRatedLabel.textColor = UIColor(rgb: 0x5B5B5B)
                releaseDateLabel.text = tvShow.firstAirStr
                releaseDateLabel.textColor = UIColor(rgb: 0x5B5B5B)
            }
        }
    }
    
}
