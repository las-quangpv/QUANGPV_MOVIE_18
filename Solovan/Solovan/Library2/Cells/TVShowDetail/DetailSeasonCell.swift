import UIKit

class DetailSeasonCell: UITableViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seasonImage.layer.cornerRadius = 10
        releaseLabel.textColor = UIColor(rgb: 0x5B5B5B)
    }
    var selectItemBlock: ((_ item: TvShowEpisode) -> Void)?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func selectSeason(_ sender: Any) {
        selectItemBlock?(data!)
    }
    
    var data: TvShowEpisode? {
        didSet {
            seasonImage.sd_setImage(with: data?.backdropURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
            titleLabel.text = data?.name
            releaseLabel.text = data?.airDateStr
        }
    }
}
