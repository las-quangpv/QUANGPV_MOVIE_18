import UIKit

class MyPlayListCell: UICollectionViewCell {
    //MARK: properties
    var isDataMovie = false
    
    var deleteItemBlock: ((_ item: Any) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        posterImage.layer.cornerRadius = 15
        posterImage.setImageBackground()
        posterImage.clipsToBounds = true
        
        lineView.backgroundColor = UIColor(rgb: 0xD8D8D8)
        releaseLabel.textColor = UIColor(rgb: 0x5B5B5B)
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteItemBlock?(data as Any)
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                isDataMovie = true
                posterImage.sd_setImage(with: movie.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                typeLabel.text = "Movie"
                typeLabel.textColor = UIColor(rgb: 0x049349)
                titleLabel.text = movie.title
                releaseLabel.text = movie.releaseStr
            }
            
            if let tvShow = data as? TvShow {
                isDataMovie = false
                posterImage.sd_setImage(with: tvShow.posterURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
                typeLabel.text = "TV Show"
                typeLabel.textColor = UIColor(rgb: 0x6236FF)
                titleLabel.text = tvShow.name
                releaseLabel.text = tvShow.firstAirStr
            }
        }
    }
}
