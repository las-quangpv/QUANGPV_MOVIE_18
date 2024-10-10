import UIKit

class MCategoryCell: UITableViewCell {
    //MARK: properties
    static let height: CGFloat = 200
    
    
    //MARK: -outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    var source: [Genre] = [] {
        didSet {
            if source.count != 0 {
                categoryCollectionView.reloadData()
            }
        }
    }
    var seeAllBlock: ((_ tab : CategoryTab) -> Void)?
    var selectItemBlock: ((_ item: Genre) -> Void)?
    
    var genreType: GenreType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllButton.setTitleColor(UIColor(rgb: 0x6236FF), for: .normal)
        categoryCollectionView.register(UINib(nibName: MCategoryItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MCategoryItemCell.cellId)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
        seeAllBlock?(.movie)
    }
}

extension MCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MCategoryItemCell.cellId, for: indexPath) as! MCategoryItemCell
        cell.categoryText = source[indexPath.row].name
        cell.genreType = genreType
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 145)
    }
    
}
