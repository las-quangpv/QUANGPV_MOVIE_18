import UIKit

class MDetailMediaCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = 246
    
    var source: [MovieImageItem] = [] {
        didSet {
            if mediaCollectionView != nil {
                mediaCollectionView.reloadData()
            }
        }
    }
    
    var sourceTV: [TvShowImageItem] = [] {
        didSet {
            if mediaCollectionView != nil {
                mediaCollectionView.reloadData()
            }
        }
    }
    
    //MARK: -outlets
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mediaCollectionView.register(UINib(nibName: MediaItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MediaItemCell.cellId)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension MDetailMediaCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if source.count > 0 {
            return self.source.count
        }
        else if sourceTV.count > 0 {
            return self.sourceTV.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCell.cellId, for: indexPath) as! MediaItemCell
        if source.count > 0 {
            cell.imageURL = source[indexPath.row].filePathURL
        }
        else if sourceTV.count > 0{
            cell.imageURL = sourceTV[indexPath.row].filePathURL
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // selectItemBlock?(source[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 318, height: 179)
    }
}

