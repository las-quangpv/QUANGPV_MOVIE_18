import UIKit
import SideMenu

class TVSController: BVC {
    //MARK: -properties
    var layouts: [String] = [
        TVSTrendingCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        TVSPopularCell.cellId,
        MCategoryCell.cellId,
        TVSTopRatedCell.cellId
    ]
    
    //MARK: -view models
    fileprivate var tvshowGenreVM: TVSGenreVM?
    fileprivate var tvShowAiringTodayVM: TVSAiringTodayVM?
    fileprivate var tvShowPopularVM: TVSPopularVM?
    fileprivate var tvShowTopRatedVM: TVSTopRatedVM?
    
    //MARK: -outlets
    @IBOutlet weak var tvShowCollectionView: UICollectionView!
    @IBOutlet weak var tvshowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    
    private func setupUI() {
        
        tvshowTableView.register(UINib(nibName: TVSTrendingCell.cellId, bundle: nil), forCellReuseIdentifier: TVSTrendingCell.cellId)
        tvshowTableView.register(UINib(nibName: TVSPopularCell.cellId, bundle: nil), forCellReuseIdentifier: TVSPopularCell.cellId)
        tvshowTableView.register(UINib(nibName: MCategoryCell.cellId, bundle: nil), forCellReuseIdentifier: MCategoryCell.cellId)
        tvshowTableView.register(UINib(nibName: TVSTopRatedCell.cellId, bundle: nil), forCellReuseIdentifier: TVSTopRatedCell.cellId)
        tvshowTableView.registerItem(cell: AdmobNativeAdTableCell.self)
        tvshowTableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        tvshowTableView.delegate = self
        tvshowTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.tvshowTableView.reloadData()
            }
        }
    }
    
    private func loadData() {
        
        tvShowAiringTodayVM = TVSAiringTodayVM()
        tvShowAiringTodayVM?.bindViewModelToController = {
            self.tvshowTableView.reloadData()
        }
        tvShowAiringTodayVM?.loadData()
        
        tvShowPopularVM = TVSPopularVM()
        tvShowPopularVM?.bindViewModelToController = {
            self.tvshowTableView.reloadData()
        }
        tvShowPopularVM?.loadData()
        
        tvshowGenreVM = TVSGenreVM()
        tvshowGenreVM?.bindViewModelToController = {
            self.tvshowTableView.reloadData()
        }
        tvshowGenreVM?.loadData()
        
        tvShowTopRatedVM = TVSTopRatedVM()
        tvShowTopRatedVM?.bindViewModelToController = {
            self.tvshowTableView.reloadData()
        }
        tvShowTopRatedVM?.loadData()
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
    
    @IBAction func searchAction(_ sender: Any) {
        self.openSearch(type: .tvshow)
    }
    
}

extension TVSController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch layouts[indexPath.row] {
        case TVSTrendingCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: TVSTrendingCell.cellId) as! TVSTrendingCell
            cell.source = tvShowAiringTodayVM?.data ?? []
            cell.onSelectItem = { item  in
                self.openDetail(item)
                
            }
            return cell
        case MCategoryCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MCategoryCell.cellId) as! MCategoryCell
            cell.source = tvshowGenreVM?.data ?? []
            cell.genreType = .television
            cell.seeAllBlock = { movie in
                self.openCategory(type: .tvshow)
            }
            cell.selectItemBlock = { item in
                self.openCategoryDetail(type: .television, data: item)
            }
            
            return cell
        case TVSPopularCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: TVSPopularCell.cellId) as! TVSPopularCell
            cell.source = tvShowPopularVM?.data ?? []
            cell.selectItemBlock = { item  in
                if let tvShow = item as? TvShow {
                    self.openDetail(tvShow)
                }
            }
            cell.seeAllBlock = {
                self.openViewAll(type: .tvshowPopular)
            }
            return cell
        case TVSTopRatedCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: TVSTopRatedCell.cellId) as! TVSTopRatedCell
            cell.source = tvShowTopRatedVM?.headerData ?? []
            cell.selectItemBlock = { item in
                if let tvshow = item as? TvShow {
                    self.openDetail(tvshow)
                }
            }
            return cell
        case AppLovinNativeAdTableCell.cellId:
            let cell: AppLovinNativeAdTableCell = tableView.dequeueReusableCell()
            cell.nativeAd = super.applovinAdView
            return cell
        case AdmobNativeAdTableCell.cellId:
            let cell: AdmobNativeAdTableCell = tableView.dequeueReusableCell()
            cell.nativeAd = super.admobAd
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch layouts[indexPath.row] {
        case TVSTrendingCell.cellId:
            if isPad() {
                return TVSTrendingCell.heightPad
                
            } else {
                return TVSTrendingCell.height
            }
        case TVSPopularCell.cellId:
            return TVSPopularCell.height
        case MCategoryCell.cellId:
            return MCategoryCell.height
        case TVSTopRatedCell.cellId:
            return TVSTopRatedCell.height * 5 + 55
        case AdmobNativeAdTableCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.admobAd != nil {
                    return AdmobNativeAdTableCell.height
                } else {
                    return 0
                }
            } else {
                return 0
            }
        case AppLovinNativeAdTableCell.cellId:
            if super.numberOfNatives() > 0 {
                if super.applovinAdView != nil {
                    return AppLovinNativeAdTableCell.height
                } else {
                    return 0
                }
            } else {
                return 0
            }
        default:
            return 0
        }
    }
}
