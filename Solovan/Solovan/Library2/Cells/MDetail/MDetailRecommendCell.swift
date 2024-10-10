import UIKit

class MDetailRecommendCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = 330
    
    var source: [Any] = [] {
        didSet {
            if source.count != 0 {
                recommendCollectionView.reloadData()
            }
        }
    }
    
    var selectItemBlock: ((_ item: Any) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(rgb: 0xEDECF8)
        // Initialization code
        recommendCollectionView.register(UINib(nibName: MComingItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MComingItemCell.cellId)
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension MDetailRecommendCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MComingItemCell.cellId, for: indexPath) as! MComingItemCell
        cell.data = source[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 250)
    }
    
}
