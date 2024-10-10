import UIKit

class MediaItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var backDropImage: UIImageView!
    
    var imageURL: URL! {
        didSet {
            backDropImage.sd_setImage(with: imageURL, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
