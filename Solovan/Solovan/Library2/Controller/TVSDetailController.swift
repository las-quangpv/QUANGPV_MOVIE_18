import UIKit

class TVSDetailController: BVC {
    //MARK: -properties
    var tvShowId: Int = 0
    fileprivate var layouts: [String] = [
        MDetailPosterCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        TVSDetailSeasonCell.cellId,
        MDetailOverViewCell.cellId,
        MDetailTopBillCell.cellId,
        MDetailMediaCell.cellId,
        MDetailRecommendCell.cellId
    ]
    
    // MARK: - view model
    fileprivate var tvShowDetailVM: TVSDetailVM?
    fileprivate var tvShowRecommendationVM: TVSRecommendationVM?
    
    // MARK: - outlets
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var tvShowTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
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
    
    private func setupUI() {
        headerView.backgroundColor = .clear
        
        
        tvShowTableView.contentInsetAdjustmentBehavior = .never
        
        tvShowTableView.register(UINib(nibName: MDetailPosterCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailPosterCell.cellId)
        tvShowTableView.register(UINib(nibName: TVSDetailSeasonCell.cellId, bundle: nil), forCellReuseIdentifier: TVSDetailSeasonCell.cellId)
        tvShowTableView.register(UINib(nibName: MDetailOverViewCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailOverViewCell.cellId)
        tvShowTableView.register(UINib(nibName: MDetailTopBillCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailTopBillCell.cellId)
        tvShowTableView.register(UINib(nibName: MDetailMediaCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailMediaCell.cellId)
        tvShowTableView.register(UINib(nibName: MDetailRecommendCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailRecommendCell.cellId)
        tvShowTableView.registerItem(cell: AdmobNativeAdTableCell.self)
        tvShowTableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        tvShowTableView.showsVerticalScrollIndicator = false
        tvShowTableView.separatorStyle = .none
        tvShowTableView.delegate = self
        tvShowTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.tvShowTableView.reloadData()
            }
        }
    }
    
    private func loadData() {
        tvShowDetailVM = TVSDetailVM(id: tvShowId)
        tvShowDetailVM?.bindViewModelToController = {
            self.tvShowTableView.reloadData()
        }
        tvShowDetailVM?.loadData()
        
        tvShowRecommendationVM = TVSRecommendationVM(id: tvShowId)
        tvShowRecommendationVM?.bindViewModelToController = {
            self.tvShowTableView.reloadData()
        }
        tvShowRecommendationVM?.loadData()
        
    }
}

extension TVSDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch layouts[indexPath.row] {
        case MDetailPosterCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailPosterCell.cellId) as! MDetailPosterCell
            cell.data = tvShowDetailVM?.data
            cell.addPlayList = { data in
                if let tvshow = data as? TvShow {
                    if BookmarkService.shared.checkIsBookmark(id: tvshow.id, type: .tvShow) {
                        let alert = UIAlertController(title: "Notification", message: "The tv show added to playlist!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        if BookmarkService.shared.addBookmark(data: tvshow, type: .tvShow) {
                            let alert = UIAlertController(title: "Notification", message: "Add playlist success!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            let alert = UIAlertController(title: "Notification", message: "Add playlist failed!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }          
            }
            cell.onShare = {
                let shareText = "Download now https://apps.apple.com/us/app/id\(AppInfor.id)";
                let textToShare = [shareText] as [Any]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            cell.onPlay = { movie in
                let seasons = self.tvShowDetailVM?.data?.seasons ?? []
                if seasons.count > 0 {
                    self.openEpisodes(tvId: self.tvShowId, seasonNumber: seasons[0].season_number!, seasonName: seasons[0].name  ?? not_available, seasons: seasons)
                }
                
            }
            return cell
        case TVSDetailSeasonCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: TVSDetailSeasonCell.cellId) as! TVSDetailSeasonCell
            cell.source = tvShowDetailVM?.data?.seasons ?? []
            cell.onSelectedItem = { item in
                if let season = item as? TvShowSeason {
                    let seasons = self.tvShowDetailVM?.data?.seasons ?? []
                    self.openEpisodes(tvId: self.tvShowId, seasonNumber: season.season_number!, seasonName: season.name  ?? not_available, seasons: seasons)
                }
            }
            return cell
        case MDetailOverViewCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailOverViewCell.cellId) as! MDetailOverViewCell
            cell.data = tvShowDetailVM?.data
            return cell
        case MDetailTopBillCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailTopBillCell.cellId) as! MDetailTopBillCell
            cell.source = tvShowDetailVM?.data?.cast ?? []
            cell.selectItemBlock = { item in
                if let cast = item as? TvShowCast {
                    self.openPeopleDetail(cast.id)
                }
                
            }
            
            return cell
        case MDetailMediaCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailMediaCell.cellId) as! MDetailMediaCell
            cell.sourceTV = tvShowDetailVM?.data?.images?.backdrops ?? []
            return cell
        case MDetailRecommendCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailRecommendCell.cellId) as! MDetailRecommendCell
            cell.source = tvShowRecommendationVM?.data ?? []
            cell.selectItemBlock = { item in
                if let movie = item as? Movie {
                    self.openDetail(movie)
                }
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
        case MDetailPosterCell.cellId:
            return MDetailPosterCell.height
        case TVSDetailSeasonCell.cellId:
            return TVSDetailSeasonCell.height
        case MDetailOverViewCell.cellId:
            return MDetailOverViewCell.height
        case MDetailTopBillCell.cellId:
            return MDetailTopBillCell.height
        case MDetailMediaCell.cellId:
            return tvShowDetailVM?.data?.images?.backdrops.count == 0 ? 0: MDetailMediaCell.height
        case MDetailRecommendCell.cellId:
            return tvShowRecommendationVM?.data.count == 0 ? 0: MDetailRecommendCell.height
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
