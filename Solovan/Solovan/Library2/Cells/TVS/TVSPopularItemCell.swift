import UIKit

class TVSPopularItemCell: UICollectionViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 15
        posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        
        voteView.layer.cornerRadius = 11
        voteView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    var data: Any? {
        didSet {
            if let tvShow = data as? TvShow {
                posterImage.sd_setImage(with: tvShow.backdropURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = tvShow.name
                voteLabel.text = tvShow.voteAverageStr
            }
            
        }
    }
}
