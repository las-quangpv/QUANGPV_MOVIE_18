import UIKit

class MDetailPosterCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = 430
    
    var addPlayList: ((_ item: Any) -> Void)?
    var onPlay: ((_ data: Any) -> Void)?
    var onShare: (() -> Void)?
    
    
    
    //MARK: -outlets
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var addPlayListImage: UIImageView!
    @IBOutlet weak var addPlayListLabel: UILabel!
    
    @IBOutlet weak var addPlayListView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 15
        
        addPlayListView.layer.borderColor = UIColor(rgb: 0xEDECF8).cgColor
        addPlayListView.layer.borderWidth = 1.0
        
        shareView.layer.borderColor = UIColor(rgb: 0xEDECF8).cgColor
        shareView.layer.borderWidth = 1.0
        headerView.backgroundColor = .clear
        // headerView.roundTopLeftRight(radius: 30, color: .white, offset: .init(width: 0, height: -60))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addPlayListAction(_ sender: Any) {
        addPlayList?(data)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        onShare?()
    }
    @IBAction func playAction(_ sender: Any) {
        onPlay?(data)
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                backdropImage.sd_setImage(with: movie.backdropURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                posterImage.sd_setImage(with: movie.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = movie.title
                rateLabel.attributedText = movie.ratingStar //+ " " +  movie.voteAverageStr
                releaseLabel.text = movie.releaseCompany
            }
            if let tvShow = data as? TvShow {
                backdropImage.sd_setImage(with: tvShow.backdropURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                posterImage.sd_setImage(with: tvShow.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                titleLabel.text = tvShow.name
                rateLabel.attributedText = tvShow.ratingStar
                releaseLabel.text = tvShow.releaseCompany
            }
        }
    }
}
