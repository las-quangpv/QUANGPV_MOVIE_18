import UIKit

class MyPlayListController: BVC {
    //MARK: -properties
    var movies: [Movie] = []
    var tvShow: [TvShow] = []
    
    var data: [Any] {
        return movies + tvShow
    }
    
    //MARK: -outlets
    @IBOutlet weak var playListCollectionView: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI(){
        
        playListCollectionView.register(UINib(nibName: MyPlayListCell.cellId, bundle: nil), forCellWithReuseIdentifier: MyPlayListCell.cellId)
        playListCollectionView.delegate = self
        playListCollectionView.dataSource = self
        
        
    }
    
    private func loadData() {
        self.movies = BookmarkService.shared.getListBookmark(type: .movie) as! [Movie]
        self.tvShow = BookmarkService.shared.getListBookmark(type: .tvShow) as! [TvShow]
        self.playListCollectionView.reloadData()
        if self.movies.count + self.tvShow.count > 0 {
            self.viewEmpty.isHidden = true
        } else {
            self.viewEmpty.isHidden = false
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
        if DataCommonModel.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension MyPlayListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPlayListCell.cellId, for: indexPath) as! MyPlayListCell
        cell.data = data[indexPath.row]
        cell.deleteItemBlock = { item in
            if let movie = item as? Movie {
                BookmarkService.shared.deleteBookmark(item: movie, type: .movie)
                self.movies = BookmarkService.shared.getListBookmark(type: .movie) as! [Movie]
                if self.movies.count + self.tvShow.count > 0 {
                    self.viewEmpty.isHidden = true
                } else {
                    self.viewEmpty.isHidden = false
                }
                self.playListCollectionView.reloadData()
            }
            if let tvShow = item as? TvShow {
                BookmarkService.shared.deleteBookmark(item: tvShow, type: .tvShow)
                self.tvShow = BookmarkService.shared.getListBookmark(type: .tvShow) as! [TvShow]
                if self.movies.count + self.tvShow.count > 0 {
                    self.viewEmpty.isHidden = true
                } else {
                    self.viewEmpty.isHidden = false
                }
                self.playListCollectionView.reloadData()
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = data[indexPath.row] as? Movie {
            openDetail(movie)
        }
        else if let tvShow = data[indexPath.row] as? TvShow {
            openDetail(tvShow)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 161)
    }
    
}
