import UIKit

class PPopularCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = UIDevice.current.is_iPhone ? 205 : 250
    
    var source: [People] = [] {
        didSet {
            if source.count != 0 {
                popularCollectionView.reloadData()
            }
        }
    }
    var seeAllBlock: (() -> Void)?
    var selectItemBlock: ((_ item: People) -> Void)?
    
    fileprivate let padding: CGFloat = UIDevice.current.is_iPhone ? 20 : 20
    fileprivate let columns: CGFloat = UIDevice.current.is_iPhone ? 4 : 8
    
    //MARK: -outlets
    @IBOutlet weak var popularView: UIView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        popularView.backgroundColor = UIColor(rgb: 0x385DD0)
        popularView.layer.cornerRadius = 10
        popularCollectionView.register(UINib(nibName: PPopularItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: PPopularItemCell.cellId)
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func seeMoreAction(_ sender: Any) {
        seeAllBlock?()
    }
    
}

extension PPopularCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PPopularItemCell.cellId, for: indexPath) as! PPopularItemCell
        cell.people = source[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemBlock?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 2 * padding - ((columns - 1) * padding/4))/columns
        let height = UIDevice.current.is_iPhone ? (width * 1.2) : width * 1.4
        return CGSize(width: width, height: height)
    }
    
}
