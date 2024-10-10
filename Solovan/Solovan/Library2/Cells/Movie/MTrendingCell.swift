import UIKit

class MTrendingCell: UITableViewCell {
    //MARK: properties
    static let height: CGFloat = 370
    
    var source: [Movie] = [] {
        didSet {
            if source.count != 0 {
                trendingCollectionView.reloadData()
            }
        }
    }
    var selectItemBlock: ((_ item: Movie) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trendingCollectionView.register(UINib(nibName: TrendingItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: TrendingItemCell.cellId)
        trendingCollectionView.delegate = self
        trendingCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension MTrendingCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingItemCell.cellId, for: indexPath) as! TrendingItemCell
        cell.data = source[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 330)
    }
    
}
