import UIKit

class MDetailTopBillCell: UITableViewCell {
    //MARK: properties
    static let height: CGFloat = 250
    
    var source: [Any] = [] {
        didSet {
            if source.count != 0 {
                self.topBillCollectionView.reloadData()
            }
        }
    }
    var selectItemBlock: ((_ item: Any) -> Void)?
    
    //MARK: outlets
    @IBOutlet weak var topBillCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topBillCollectionView.register(UINib(nibName: TopBillCell.cellId, bundle: nil), forCellWithReuseIdentifier: TopBillCell.cellId)
        topBillCollectionView.delegate = self
        topBillCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension MDetailTopBillCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBillCell.cellId, for: indexPath) as! TopBillCell
        
        let data = source[indexPath.row]
        
        if let cast = data as? MovieCast {
            cell.cast = cast
        }
        
        if let tvShowCast = data as? TvShowCast {
            cell.tvShowCast = tvShowCast
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 102, height: 183)
    }
    
}
