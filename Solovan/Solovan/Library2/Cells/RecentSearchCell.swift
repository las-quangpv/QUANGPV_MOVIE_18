import UIKit

class RecentSearchCell: UICollectionViewCell {
    //MARK: -properties
    fileprivate let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
    fileprivate let padding: CGFloat = UIDevice.current.is_iPhone ? 20 : 20
    
    var source: [Any] = [] {
        didSet {
            if source.count != 0 {
                self.recentCollectionView.reloadData()
            }
        }
    }
    var selectItemBlock: ((_ item: Any) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recentCollectionView.register(UINib(nibName: RecentSearchItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: RecentSearchItemCell.cellId)
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        
    }
    
}

extension RecentSearchCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchItemCell.cellId, for: indexPath) as! RecentSearchItemCell
        if let movie = source[indexPath.row] as? Movie {
            cell.imageURL = movie.posterURL
        }
        else if let tvShow = source[indexPath.row] as? TvShow {
            cell.imageURL = tvShow.posterURL
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 111, height: 167)
    }
    
}
