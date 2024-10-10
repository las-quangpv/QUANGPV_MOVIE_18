import UIKit

class MPopularCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = 320
    
    var source: [Any] = [] {
        didSet {
            if source.count != 0 {
                popularCollectionView.reloadData()
            }
        }
    }
    
    var seeAllBlock: (() -> Void)?
    var selectItemBlock: ((_ item: Any) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllButton.setTitleColor(UIColor(rgb: 0x6236FF), for: .normal)
        popularCollectionView.register(UINib(nibName: MComingItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MComingItemCell.cellId)
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
        seeAllBlock?()
    }
}

extension MPopularCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return .init(top: 0, left: 20, bottom: 0, right: 20)
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
