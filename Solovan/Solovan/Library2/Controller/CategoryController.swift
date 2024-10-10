import UIKit

enum CategoryTab: Int {
    case movie = 0
    case tvshow = 1
}

class CategoryController: BVC {
    //MARK: -properties
    var tabSelected: CategoryTab = .movie
    fileprivate let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
    fileprivate let padding: CGFloat = UIDevice.current.is_iPhone ? 20 : 20
    
    //MARK: -view model
    var genreMovieVM: MGenreVM?
    var genreTvShowVM: TVSGenreVM?
    
    //MARK: -outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var buttonView: UIStackView!
    @IBOutlet weak var tvShowButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
        setupTabActive()
    }
    
    private func setupUI() {
        buttonView.layer.cornerRadius = 10
        buttonView.layer.borderColor = UIColor(rgb: 0xD8D8D8).cgColor
        buttonView.layer.borderWidth = 1.0
        
        movieButton.tag = 0
        movieButton.setTitleColor(UIColor(rgb: 0x050505), for: .normal)
        movieButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .selected)
        
        
        tvShowButton.tag = 1
        tvShowButton.setTitleColor(UIColor(rgb: 0x050505), for: .normal)
        tvShowButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .selected)
        
        categoryCollectionView.register(UINib(nibName: MCategoryItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MCategoryItemCell.cellId)
        categoryCollectionView.register(UINib(nibName: CategoryTVSItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: CategoryTVSItemCell.cellId)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    private func loadData() {
        genreMovieVM = MGenreVM()
        genreMovieVM?.bindViewModelToController = {
            self.categoryCollectionView.reloadData()
        }
        genreMovieVM?.loadData()
        
        genreTvShowVM = TVSGenreVM()
        genreTvShowVM?.bindViewModelToController = {
            self.categoryCollectionView.reloadData()
        }
        genreTvShowVM?.loadData()
        
    }
    
    private func setupTabActive(_ animation: Bool = false) {
        movieButton.isSelected = false
        tvShowButton.isSelected = false
        
        UIView.animate(withDuration: animation ? 0.3 : 0) {
            switch self.tabSelected {
            case .movie:
                self.movieButton.isSelected = true
                self.movieButton.backgroundColor = UIColor(rgb: 0x6236FF)
                self.tvShowButton.backgroundColor = UIColor(rgb: 0xFFFFFF)
                self.movieButton.roundLeftTopBottom(radius: 10, color: .shadow, offset: .zero)
            case .tvshow:
                self.tvShowButton.isSelected = true
                self.tvShowButton.backgroundColor = UIColor(rgb: 0x6236FF)
                self.movieButton.backgroundColor = UIColor(rgb: 0xFFFFFF)
                self.tvShowButton.roundRightTopBottom(radius: 10, color: .shadow, offset: .zero)
            }
            
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
    
    @IBAction func movieAction(_ sender: Any) {
        if tabSelected == .movie { return }
        tabSelected = .movie
        setupTabActive(true)
        self.loadData()
    }
    
    @IBAction func tvShowAction(_ sender: Any) {
        if tabSelected == .tvshow { return }
        tabSelected = .tvshow
        setupTabActive(true)
        self.loadData()
    }
}

extension CategoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabSelected {
        case .movie:
            return genreMovieVM?.data.count ?? 0
            
        case .tvshow:
            return genreTvShowVM?.data.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch tabSelected {
        case .movie:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MCategoryItemCell.cellId, for: indexPath) as! MCategoryItemCell
            cell.categoryText = genreMovieVM?.data[indexPath.row].name ?? ""
            cell.genreType = .movie
            return cell
            
        case .tvshow:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryTVSItemCell.cellId, for: indexPath) as! CategoryTVSItemCell
            cell.categoryText = genreTvShowVM?.data[indexPath.row].name ?? ""
            cell.genreType = .television
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch tabSelected {
            
        case .movie:
            if let movie = genreMovieVM?.data[indexPath.row] {
                openCategoryDetail(type: .movie, data: movie)
            }
        case .tvshow:
            if let tvShow = genreTvShowVM?.data[indexPath.row] {
                openCategoryDetail(type: .television, data: tvShow)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch tabSelected {
        case .movie:
            return padding/2
        case .tvshow:
            return padding
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch tabSelected {
        case .movie:
            return padding/2
        case .tvshow:
            return padding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch tabSelected {
        case .movie:
            let width = (UIScreen.main.bounds.width - 2 * padding - ((columns - 1) * (padding)))/columns
            let height = width * 1.4
            return CGSize(width: width, height: height)
        case .tvshow:
            let width = UIScreen.main.bounds.width - 2 * padding
            return CGSize(width: width, height: 86)
        }
        
    }
    
}
