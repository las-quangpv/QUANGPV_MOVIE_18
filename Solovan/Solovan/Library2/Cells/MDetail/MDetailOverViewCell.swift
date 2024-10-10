import UIKit

class MDetailOverViewCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = UITableView.automaticDimension
    
    
    //MARK: -outlets
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overViewLabel.text = ""
        overViewLabel.numberOfLines = 0
        overViewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        overViewLabel.sizeToFit()
        
        directorLabel.labelTwoColor(title: "Director: ",
                                 colorTitle: .init(rgb: 0x5B5B5B),
                                   fontTitle: UIFont.lexendRegular(16),
                                 detail: "",
                                 colorDetail: .init(rgb: 0x000000),
                                 fontDetail: UIFont.lexendRegular(16))
        
        categoryLabel.labelTwoColor(title: "Category: ",
                                 colorTitle: .init(rgb: 0x5B5B5B),
                                 fontTitle: UIFont.lexendRegular(16),
                                 detail: "",
                                 colorDetail: .init(rgb: 0x000000),
                                 fontDetail: UIFont.lexendRegular(16))
        durationLabel.labelTwoColor(title: "Duration: ",
                                 colorTitle: .init(rgb: 0x5B5B5B),
                                 fontTitle: UIFont.lexendRegular(16),
                                 detail: "",
                                 colorDetail: .init(rgb: 0x000000),
                                 fontDetail: UIFont.lexendRegular(16))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: Any? {
        didSet {
            if let movie = data as? Movie {
                overViewLabel.text = movie.overview
                directorLabel.labelTwoColor(title: "Director: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                           fontTitle: UIFont.lexendRegular(16),
                                            detail: movie.directors?[0].name ?? not_available,
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                
                categoryLabel.labelTwoColor(title: "Category: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                         fontTitle: UIFont.lexendRegular(16),
                                            detail: movie.genreStr,
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                durationLabel.labelTwoColor(title: "Duration: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                         fontTitle: UIFont.lexendRegular(16),
                                            detail: movie.durationStr,
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                
            }
            
            if let tvShow = data as? TvShow {
                
                var director: String = not_available
                if tvShow.directors?.count != 0 {
                    director = tvShow.directors![0].name
                }
                
                overViewLabel.text = tvShow.overview
                
                directorLabel.labelTwoColor(title: "Director: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                           fontTitle: UIFont.lexendRegular(16),
                                            detail: director ,
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                
                categoryLabel.labelTwoColor(title: "Category: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                         fontTitle: UIFont.lexendRegular(16),
                                            detail: tvShow.genreStr,
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                durationLabel.labelTwoColor(title: "Duration: ",
                                         colorTitle: .init(rgb: 0x5B5B5B),
                                         fontTitle: UIFont.lexendRegular(16),
                                            detail: "\(tvShow.seasonList.count) Seasons",
                                         colorDetail: .init(rgb: 0x000000),
                                         fontDetail: UIFont.lexendRegular(16))
                
            }
        }
    }
    
}
