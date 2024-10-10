import UIKit
import CRRefresh

class CategoryDetailController: BVC {
    //MARK: -propertires
    var type: GenreType = .movie
    var genres: Genre!
    
    //MARK: -view models
    var genreMovieVM: MByGenreVM = MByGenreVM()
    var genreTelevisonVM: TVSByGenreVM = TVSByGenreVM()
    
    //MARK: -outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        titleLabel.text = genres!.name
        
        categoryCollectionView.register(UINib(nibName: MTopRatedItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: MTopRatedItemCell.cellId)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.cr.addFootRefresh {
            // load more
            switch self.type {
            case .movie:
                if self.genreMovieVM.isLoading { return }
                self.genreMovieVM.loadData()
            case .television:
                if self.genreTelevisonVM.isLoading { return }
                self.genreTelevisonVM.loadData()
                break
            }
        }
    }
    private func loadData() {
        if type == .movie {
            genreMovieVM = MByGenreVM(id: genres.id)
            genreMovieVM.bindViewModelToController = {
                self.categoryCollectionView.cr.endLoadingMore()
                self.categoryCollectionView.reloadData()
            }
            genreMovieVM.loadData()
        } else {
            genreTelevisonVM = TVSByGenreVM(id: genres.id)
            genreTelevisonVM.bindViewModelToController = {
                self.categoryCollectionView.cr.endLoadingMore()
                self.categoryCollectionView.reloadData()
            }
            genreTelevisonVM.loadData()
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

extension CategoryDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
            
        case .movie:
            return genreMovieVM.data.count
        case .television:
            return genreTelevisonVM.data.count
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
        return CGSize(width: UIScreen.main.bounds.size.width , height: 161)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if type == .movie {
            self.openDetail(self.genreMovieVM.data[indexPath.row])
        } else {
            self.openDetail(self.genreTelevisonVM.data[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MTopRatedItemCell.cellId, for: indexPath) as! MTopRatedItemCell
        if type == .movie {
            cell.data = self.genreMovieVM.data[indexPath.row]
        } else {
            cell.data = self.genreTelevisonVM.data[indexPath.row]
        }
        return cell
    }
    
}
