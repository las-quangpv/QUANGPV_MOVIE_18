import UIKit

class MDetailController: BVC {
    //MARK: -properties
    var movieId: Int = 0
    fileprivate var layouts: [String] = [
        MDetailPosterCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        MDetailOverViewCell.cellId,
        MDetailTopBillCell.cellId,
        MDetailMediaCell.cellId,
        MDetailRecommendCell.cellId
    ]
    
    // MARK: - view model
    fileprivate var movieDetailVM: MDetailVM?
    fileprivate var movieRecommendationVM: MRecommendationVM?
    
    // MARK: - outlets
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var movieDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        headerView.backgroundColor = .clear
        
        movieDetailTableView.contentInsetAdjustmentBehavior = .never
        
        movieDetailTableView.register(UINib(nibName: MDetailPosterCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailPosterCell.cellId)
        movieDetailTableView.register(UINib(nibName: MDetailOverViewCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailOverViewCell.cellId)
        movieDetailTableView.register(UINib(nibName: MDetailTopBillCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailTopBillCell.cellId)
        movieDetailTableView.register(UINib(nibName: MDetailMediaCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailMediaCell.cellId)
        movieDetailTableView.register(UINib(nibName: MDetailRecommendCell.cellId, bundle: nil), forCellReuseIdentifier: MDetailRecommendCell.cellId)
        movieDetailTableView.registerItem(cell: AdmobNativeAdTableCell.self)
        movieDetailTableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        movieDetailTableView.showsVerticalScrollIndicator = false
        movieDetailTableView.separatorStyle = .none
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.movieDetailTableView.reloadData()
            }
        }
    }
    
    private func loadData() {
        movieDetailVM = MDetailVM(id: movieId)
        movieDetailVM?.bindViewModelToController = {
            self.movieDetailTableView.reloadData()
        }
        movieDetailVM?.loadData()
        
        movieRecommendationVM = MRecommendationVM(id: movieId)
        movieRecommendationVM?.bindViewModelToController = {
            self.movieDetailTableView.reloadData()
        }
        movieRecommendationVM?.loadData()
        
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

extension MDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch layouts[indexPath.row] {
        case MDetailPosterCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailPosterCell.cellId) as! MDetailPosterCell
            cell.data = movieDetailVM?.data
            cell.addPlayList = { data in
                if let movie = data as? Movie {
                    if BookmarkService.shared.checkIsBookmark(id: movie.id, type: .movie) {
                        let alert = UIAlertController(title: "Notification", message: "The movie added to playlist!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        if BookmarkService.shared.addBookmark(data: movie, type: .movie) {
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
                self.watchNowClick()
            }
            return cell
        case MDetailOverViewCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailOverViewCell.cellId) as! MDetailOverViewCell
            cell.data = movieDetailVM?.data
            return cell
        case MDetailTopBillCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailTopBillCell.cellId) as! MDetailTopBillCell
            cell.source = movieDetailVM?.data?.cast ?? []
            cell.selectItemBlock = { item in
                if let cast = item as? MovieCast {
                    self.openPeopleDetail(cast.id)
                }
            }
            return cell
        case MDetailMediaCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailMediaCell.cellId) as! MDetailMediaCell
            cell.source = movieDetailVM?.data?.images?.backdrops ?? []
            return cell
        case MDetailRecommendCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MDetailRecommendCell.cellId) as! MDetailRecommendCell
            cell.source = movieRecommendationVM?.data ?? []
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
        case MDetailOverViewCell.cellId:
            return MDetailOverViewCell.height
        case MDetailTopBillCell.cellId:
            return MDetailTopBillCell.height
        case MDetailMediaCell.cellId:
            return MDetailMediaCell.height
        case MDetailRecommendCell.cellId:
            return movieRecommendationVM?.data.count == 0 ? 0: MDetailRecommendCell.height
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
    
    private func watchNowClick() {
        let isShowReward: Bool? = DataCommonModel.shared.extraFind("is_detail_reward")
        if isShowReward == nil {
            InterstitialHandle.shared.present() {
            self.watchMo()
          }
        } else {
            if isShowReward! {
                let alert = UIAlertController(title: title, message: "Watching an ad to watch movie", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Watch ads", style: .default, handler: { _ in
                    AdmobReward.shared.tryToPresentDidEarnReward {
                      self.watchMo()
                    }
                }))
                self.present(alert, animated: true)
            } else {
                InterstitialHandle.shared.present() {
                self.watchMo()
              }
            }
        }
    }
    
    
    private func watchMo(){
        guard let detail = self.movieDetailVM?.data else { return }
        NetworkHelper.shared.loadM(detail.title, year: detail.yearInt, imdb: detail.imdb) { [weak self] data in
            if data.count == 0 {
                self?.alertNotLink {
                    NetworkHelper.shared.rport(name: detail.title,
                                               type: MediaType.movie.rawValue,
                                               year: detail.yearInt,
                                               imdb: detail.imdb,
                                               content: emptylink)
                }
                return
            }
            
            let player = ZemPlayerController.makeController()
            player.type = .movie
            player.name = detail.title
            player.data = data
            player.imdbid = detail.imdb
            player.year = detail.yearInt
            self?.present(player, animated: true)
        }
    }
    
}
