import UIKit


class MCategoryItemCell: UICollectionViewCell {
    
    //MARK: -outlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    var genreType: GenreType? {
        didSet {
            switch genreType {
            case .movie:
                if categoryText == "Action" {
                    categoryImage.image = UIImage(named: "mv_action")
                } else
                if categoryText == "Adventure" {
                    categoryImage.image = UIImage(named: "mv_adventure")
                } else
                if categoryText == "Animation" {
                    categoryImage.image = UIImage(named: "mv_animation")
                } else
                if categoryText == "Comedy" {
                    categoryImage.image = UIImage(named: "mv_comedy")
                } else
                if categoryText == "Crime" {
                    categoryImage.image = UIImage(named: "mv_crime")
                } else
                if categoryText == "Documentary" {
                    categoryImage.image = UIImage(named: "mv_documentary")
                } else
                if categoryText == "Drama" {
                    categoryImage.image = UIImage(named: "mv_drama")
                } else
                if categoryText == "Family" {
                    categoryImage.image = UIImage(named: "mv_family")
                } else
                if categoryText == "Fantasy" {
                    categoryImage.image = UIImage(named: "mv_fantasy")
                } else
                if categoryText == "History" {
                    categoryImage.image = UIImage(named: "mv_history")
                } else
                if categoryText == "Horror" {
                    categoryImage.image = UIImage(named: "mv_horror")
                } else
                if categoryText == "Music" {
                    categoryImage.image = UIImage(named: "mv_music")
                } else
                if categoryText == "Mystery" {
                    categoryImage.image = UIImage(named: "mv_mystery")
                } else
                if categoryText == "Romance" {
                    categoryImage.image = UIImage(named: "mv_romance")
                } else
                if categoryText == "Science Fiction" {
                    categoryImage.image = UIImage(named: "mv_science")
                } else
                if categoryText == "TV Movie" {
                    categoryImage.image = UIImage(named: "mv_tvmovie")
                } else
                if categoryText == "Thriller" {
                    categoryImage.image = UIImage(named: "mv_thriller")
                } else
                if categoryText == "War" {
                    categoryImage.image = UIImage(named: "mv_war")
                } else
                if categoryText == "Western" {
                    categoryImage.image = UIImage(named: "mv_western")
                }
                else {
                    categoryImage.image = UIImage(named: "image_thumb")
                }
            case .television:
                if categoryText == "Action & Adventure" {
                    categoryImage.image = UIImage(named: "tv_action")
                } else
                if categoryText == "Animation" {
                    categoryImage.image = UIImage(named: "tv_animation")
                } else
                if categoryText == "Comedy" {
                    categoryImage.image = UIImage(named: "tv_comedy")
                } else
                if categoryText == "Crime" {
                    categoryImage.image = UIImage(named: "tv_crime")
                } else
                if categoryText == "Documentary" {
                    categoryImage.image = UIImage(named: "tv_documentary")
                } else
                if categoryText == "Drama" {
                    categoryImage.image = UIImage(named: "tv_drama")
                } else
                if categoryText == "Family" {
                    categoryImage.image = UIImage(named: "tv_family")
                } else
                if categoryText == "Kids" {
                    categoryImage.image = UIImage(named: "tv_kid")
                } else
                if categoryText == "Mystery" {
                    categoryImage.image = UIImage(named: "tv_mystery")
                } else
                if categoryText == "News" {
                    categoryImage.image = UIImage(named: "tv_news")
                } else
                if categoryText == "Reality" {
                    categoryImage.image = UIImage(named: "tv_reality")
                } else
                if categoryText == "Sci-Fi & Fantasy" {
                    categoryImage.image = UIImage(named: "tv_fantasy")
                } else
                if categoryText == "Soap" {
                    categoryImage.image = UIImage(named: "tv_soap")
                } else
                if categoryText == "Talk" {
                    categoryImage.image = UIImage(named: "tv_talk")
                } else
                if categoryText == "War & Politics" {
                    categoryImage.image = UIImage(named: "tv_war")
                } else
                if categoryText == "Western" {
                    categoryImage.image = UIImage(named: "tv_western")
                }
                else {
                    categoryImage.image = UIImage(named: "image_thumb")
                }
                
            case .none:
                categoryImage.image = UIImage(named: "image_thumb")
            }
        }
    }
    
    var categoryText: String = "" {
        didSet {
            categoryName.text = categoryText
            categoryImage.layer.cornerRadius = 10
            // categoryImage.setImageBackground()
            categoryImage.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
