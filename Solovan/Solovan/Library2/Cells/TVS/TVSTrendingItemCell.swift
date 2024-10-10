import UIKit

class TVSTrendingItemCell: UICollectionViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    
    var tvShow: TvShow! {
        didSet {
            posterImage.sd_setImage(with: tvShow.backdropURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = .clear
        
        layer.borderColor = UIColor(rgb: 0x6056D0).cgColor
        layer.borderWidth = 0
        clipsToBounds = true
        
        posterImage.setImageBackground()
        posterImage.layer.cornerRadius = 8
        posterImage.clipsToBounds = true
    }

}
