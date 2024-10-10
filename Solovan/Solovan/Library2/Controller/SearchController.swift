import UIKit
import CRRefresh

enum SearchType: Int {
    case movie = 0
    case tvshow = 1
    case actor = 2
}

class SearchController: BVC {
    //MARK: -properties
    var searchType: SearchType = .movie
    fileprivate let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
    fileprivate let padding: CGFloat = UIDevice.current.is_iPhone ? 20 : 20
    fileprivate var historiesMovie: [Movie] = []
    fileprivate var historiesTvShow: [TvShow] = []
    
    
    //MARK: -view models
    fileprivate var movieVM: MSearchVM?
    fileprivate var tvShowVM: TVSSearchVM?
    fileprivate var peopleVM: PSearchVM?
    
    //MARK: -outlets
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search by name...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0xFFFFFF)]
        )
        
        searchCollectionView.cr.addFootRefresh {
            // load more
            self.loadingIfNeed()
        }
        searchCollectionView.register(UINib(nibName: RecentSearchCell.cellId, bundle: nil), forCellWithReuseIdentifier: RecentSearchCell.cellId)
        searchCollectionView.register(UINib(nibName: RecentSearchItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: RecentSearchItemCell.cellId)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        self.view.backgroundColor = .init(rgb: 0x0144C6)
    }
    
    private func loadData() {
        historiesMovie = HistoryService.shared.getListHistory(type: .movie) as! [Movie]
        historiesTvShow = HistoryService.shared.getListHistory(type: .tvShow) as! [TvShow]
    }
    
    fileprivate func startSearch() {
        let term = searchTextField.text!.trimming()
        if term.isEmpty {
            return
        }
        
        searchCollectionView.setContentOffset(.zero, animated: false)   // reset offset
        
        switch self.searchType {
        case .movie:
            movieVM = MSearchVM(term: term)
            movieVM?.bindViewModelToController = {
                self.searchCollectionView.cr.endLoadingMore()   // ensure endloading if need
                self.searchCollectionView.reloadData()
            }
            movieVM?.loadData()
        case .tvshow:
            tvShowVM = TVSSearchVM(term: term)
            tvShowVM?.bindViewModelToController = {
                self.searchCollectionView.cr.endLoadingMore()   // ensure endloading if need
                self.searchCollectionView.reloadData()
            }
            tvShowVM?.loadData()
        case .actor:
            peopleVM = PSearchVM(term: term)
            peopleVM?.bindViewModelToController = {
                self.searchCollectionView.cr.endLoadingMore()   // ensure endloading if need
                self.searchCollectionView.reloadData()
            }
            peopleVM?.loadData()
        }
    }
    
    fileprivate func loadingIfNeed() {
        switch self.searchType {
        case .movie:
            if movieVM?.isLoading ?? false { return }

            movieVM?.loadData()
        case .tvshow:
            if tvShowVM?.isLoading ?? false { return }
            
            tvShowVM?.loadData()
        case .actor:
            if movieVM?.isLoading ?? false { return }
            
            peopleVM?.loadData()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchController { }

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        startSearch()
        return true
    }
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let term = searchTextField.text!.trimming()
        if term.isEmpty && searchType != .actor {
            return 1
        }
        else {
            switch searchType {
            case .movie:
                return movieVM?.data.count ?? 0
            case .tvshow:
                return tvShowVM?.data.count ?? 0
            case .actor:
                return peopleVM?.data.count ?? 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let term = searchTextField.text!.trimming()
        if term.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.cellId, for: indexPath) as! RecentSearchCell
            switch searchType {
            case .movie:
                cell.source = historiesMovie
                cell.selectItemBlock = { data in
                    if let movie = data as? Movie {
                        self.openDetail(movie)
                    }
                }
            case .tvshow:
                cell.source = historiesTvShow
                cell.selectItemBlock = { data in
                    if let tvShow = data as? TvShow {
                        self.openDetail(tvShow)
                    }
                }
            case .actor:
                break
            }
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchItemCell.cellId, for: indexPath) as! RecentSearchItemCell
            switch searchType {
                
            case .movie:
                if movieVM != nil && movieVM?.data.count != 0 {
                    cell.imageURL = movieVM?.data[indexPath.row] .posterURL
                }
            case .tvshow:
                if tvShowVM != nil && tvShowVM?.data.count != 0 {
                    cell.imageURL = tvShowVM?.data[indexPath.row].posterURL
                }
            case .actor:
                if peopleVM != nil && peopleVM?.data.count != 0 {
                    cell.imageURL = peopleVM?.data[indexPath.row].profileURL
                }
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch searchType {
        case .movie:
            if let movie = movieVM?.data[indexPath.row] {
                self.openDetail(movie)
                HistoryService.shared.addHistory(data: movie, type: .movie)
            }
        case .tvshow:
            if let tvShow = tvShowVM?.data[indexPath.row] {
                self.openDetail(tvShow)
                HistoryService.shared.addHistory(data: tvShow, type: .tvShow)
            }
        case .actor:
            if let people = peopleVM?.data[indexPath.row] {
                self.openPeopleDetail(people.id)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let term = searchTextField.text!.trimming()
        if term.isEmpty {
            return .init(width: collectionView.bounds.size.width - 2 * padding , height: 215)
        }
        else {
            let w: CGFloat = CGFloat(Int((collectionView.bounds.size.width - 2 * padding - ((columns - 1) * padding)) / columns))
            let h: CGFloat = w * 1.6
            return .init(width: w, height: h)
        }
    }
}
