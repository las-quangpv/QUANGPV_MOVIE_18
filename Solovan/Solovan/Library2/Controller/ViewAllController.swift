import UIKit
import CRRefresh

enum ListMovieType: Int {
    case moviePopular = 0
    case movieUpComing
    case tvshowPopular
}

class ViewAllController: BVC {
    //MARK: -properties
    var typeSelected: ListMovieType = .moviePopular
    
    
    //MARK: -view models
    fileprivate var moviePopularVM: MPopularVM?
    fileprivate var movieUpcomingVM: MUpcomingVM?
    fileprivate var tvShowPopularVM: TVSPopularVM?
    
    //MARK: -outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewAllCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setTitleName()
        loadData()
    }

    private func setupUI() {
        viewAllCollectionView.cr.addFootRefresh {
            // load more
            switch self.typeSelected {
            case .moviePopular:
                if self.moviePopularVM?.isLoading ?? false { return }
                self.moviePopularVM?.loadData()
            case .movieUpComing:
                if self.movieUpcomingVM?.isLoading ?? false  { return }
                self.movieUpcomingVM?.loadData()
            case .tvshowPopular:
                if self.tvShowPopularVM?.isLoading ?? false { return }
                self.tvShowPopularVM?.loadData()
            }
            
        }
        
        viewAllCollectionView.register(UINib(nibName: MTopRatedItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MTopRatedItemCell.cellId)
        viewAllCollectionView.delegate = self
        viewAllCollectionView.dataSource = self
    }
    
    private func setTitleName(){
        switch typeSelected {
        case .moviePopular:
            self.titleLabel.text = "Popular movies"
        case .movieUpComing:
            self.titleLabel.text = "Coming soon"
        case .tvshowPopular:
            self.titleLabel.text = "Popular TV Shows"
        
        }
    }
    
    private func loadData() {
        switch typeSelected {
        case .moviePopular:
            moviePopularVM = MPopularVM()
            moviePopularVM?.bindViewModelToController = {
                self.viewAllCollectionView.cr.endLoadingMore()
                self.viewAllCollectionView.reloadData()
            }
            moviePopularVM?.loadData()
        case .movieUpComing:
            movieUpcomingVM = MUpcomingVM()
            movieUpcomingVM?.bindViewModelToController = {
                self.viewAllCollectionView.cr.endLoadingMore()
                self.viewAllCollectionView.reloadData()
            }
            movieUpcomingVM?.loadData()
        case .tvshowPopular:
            tvShowPopularVM = TVSPopularVM()
            tvShowPopularVM?.bindViewModelToController = {
                self.viewAllCollectionView.cr.endLoadingMore()
                self.viewAllCollectionView.reloadData()
            }
            tvShowPopularVM?.loadData()
        }
        
    }

    @IBAction func backAction(_ sender: Any) {
        if DataCommonModel.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ViewAllController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeSelected {
        case .moviePopular:
            return moviePopularVM?.data.count ?? 0
        case .movieUpComing:
            return movieUpcomingVM?.data.count ?? 0
        case .tvshowPopular:
            return tvShowPopularVM?.data.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MTopRatedItemCell.cellId, for: indexPath) as! MTopRatedItemCell
        switch typeSelected {
            
        case .moviePopular:
            cell.data = moviePopularVM?.data[indexPath.row]
        case .movieUpComing:
            cell.data = movieUpcomingVM?.data[indexPath.row]
        case .tvshowPopular:
            cell.data = tvShowPopularVM?.data[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch typeSelected {
            
        case .moviePopular:
            if let movie = moviePopularVM?.data[indexPath.row] {
                self.openDetail(movie)
            }
        case .movieUpComing:
            if let movie = movieUpcomingVM?.data[indexPath.row] {
                self.openDetail(movie)
            }
        case .tvshowPopular:
            if let tvShow = tvShowPopularVM?.data[indexPath.row] {
                self.openDetail(tvShow)
            }
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
        
        return CGSize(width: UIScreen.main.bounds.width , height: 161)
    }
}
