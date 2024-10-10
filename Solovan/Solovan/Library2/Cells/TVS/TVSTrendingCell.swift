import UIKit

class TVSTrendingCell: UITableViewCell {
    //MARK: -properties
    static let height: CGFloat = 270
    static let heightPad: CGFloat = 450
    fileprivate let padding: CGFloat = 20
    
    var source: [TvShow] = [] {
        didSet {
            pagerTVShow.reloadData()
        }
    }
    
    var onSelectItem: ((_ item: TvShow) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trendingView: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pagerTVShow: FSPagerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.pagerTVShow.dataSource = self
        self.pagerTVShow.delegate = self
        self.pagerTVShow.automaticSlidingInterval = 2.0
        if isPad() {
            self.pagerTVShow.itemSize = CGSize(width: 300, height: 390)
        } else {
            self.pagerTVShow.itemSize = CGSize(width: 141, height: 205)
        }
        
        self.pagerTVShow.transformer = FSPagerViewTransformer(type: .overlap)
        self.pagerTVShow.register(UINib(nibName: TVSTrendingItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: TVSTrendingItemCell.cellId)
        self.pagerTVShow.isInfinite = true
        if isPad() {
            leadingConstraint.constant = -((UIScreen.main.bounds.size.width - padding*3 - CGFloat(300)))
        } else {
            leadingConstraint.constant = -((UIScreen.main.bounds.size.width - padding*3 - CGFloat(141)))
        }
        
        // leadingConstraint.constant = 0
        trailingConstraint.constant = 20
        
        trendingView.layer.cornerRadius = 10
        trendingView.backgroundColor = UIColor(rgb: 0x6056D0)
        trendingView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension TVSTrendingCell: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.source.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: TVSTrendingItemCell.cellId, at: index) as! TVSTrendingItemCell
        cell.tvShow = source[index]
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        onSelectItem?(source[index])
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        
    }
    
}
