import UIKit

class PPopularItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var popularImage: UIImageView!
    
    var people: People? {
        didSet {
            popularImage.sd_setImage(with: people!.profileURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        popularImage.layer.cornerRadius = 9
        popularImage.setImageBackground()
        //popularImage.clipsToBounds = true
    }

}
