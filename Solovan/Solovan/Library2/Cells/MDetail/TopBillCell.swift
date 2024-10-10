import UIKit

class TopBillCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 15
        
    }
    var tvShowCast: TvShowCast! {
        didSet {
            if tvShowCast != nil {
                posterImage.sd_setImage(with: tvShowCast.profileURL, placeholderImage: .original("ic_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = tvShowCast.name
            }
        }
    }
    var cast: MovieCast! {
        didSet {
            if cast != nil {
                posterImage.sd_setImage(with: cast.profileURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = cast.name
            }
        }
    }
}
