import UIKit

class RecentSearchItemCell: UICollectionViewCell {
    
    //MARK: -properties
    var imageURL: URL! {
        didSet {
            searchImage.sd_setImage(with: imageURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
        }
    }
    
    //MARK: -outlets
    @IBOutlet weak var searchImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchImage.layer.cornerRadius = 15
        searchImage.setImageBackground()
        searchImage.clipsToBounds = true
        
    }
    
}
