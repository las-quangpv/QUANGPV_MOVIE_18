import UIKit

class TVSAiringCell: UICollectionViewCell {
    //MARK: -properties
    static let height: CGFloat = 270
    
    var source: [TvShow] = [] {
        didSet {
            tvShowPager.reloadData()
        }
    }
    
    var onSelectItem: ((_ item: TvShow) -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var tvshowView: UIView!
    @IBOutlet weak var tvShowPager: FSPagerView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tvShowPager.dataSource = self
        self.tvShowPager.delegate = self
        self.tvShowPager.automaticSlidingInterval = 2.0
        self.tvShowPager.itemSize = CGSize(width: 141, height: 209)
        self.tvShowPager.transformer = FSPagerViewTransformer(type: .linear)
        self.tvShowPager.register(UINib(nibName: TVSTrendingItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: TVSTrendingItemCell.cellId)
        self.tvShowPager.isInfinite = true
        //leadingConstraint.constant = -((UIScreen.main.bounds.size.width - CGFloat(141)))
        //leadingConstraint.constant = -(tvShowPager.bounds.width - CGFloat(161))
        tvshowView.layer.cornerRadius = 10
        tvshowView.backgroundColor = UIColor(rgb: 0x6056D0)
        tvshowView.clipsToBounds = true
    }
    
}

extension TVSAiringCell: FSPagerViewDataSource,FSPagerViewDelegate {
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
