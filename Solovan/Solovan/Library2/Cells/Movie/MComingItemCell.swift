import UIKit

class MComingItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var comingLabel: UILabel!
    @IBOutlet weak var comingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        comingImage.layer.cornerRadius = 15
        comingImage.setImageBackground()
        comingImage.clipsToBounds = true
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                comingImage.sd_setImage(with: movie.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                comingLabel.text = movie.title
            }
            if let tvShow = data as? TvShow {
                comingImage.sd_setImage(with: tvShow.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                comingLabel.text = tvShow.name
            }
            if let people = data as? People {
                comingImage.sd_setImage(with: people.profileURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                comingLabel.text = people.name
            }
        }
    }

}
