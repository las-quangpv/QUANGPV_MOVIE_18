import UIKit

class SeasonItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 15
        posterImage.clipsToBounds = true
        posterImage.setImageBackground()
    }
    
    var data: TvShowSeason! {
        didSet {
            posterImage.sd_setImage(with: data.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
            titleLabel.text = data.name
            detailLabel.text = "\(data.episode_count ?? 0) Episodes"
            
        }
    }
    
}
