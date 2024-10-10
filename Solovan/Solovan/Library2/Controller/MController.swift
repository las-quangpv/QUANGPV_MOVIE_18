import UIKit
import SideMenu
import StoreKit

class MController: BVC {
    
    //MARK: -properties
    var layouts: [String] = [
        MTrendingCell.cellId,
        AdmobNativeAdTableCell.cellId,
        AppLovinNativeAdTableCell.cellId,
        MCategoryCell.cellId,
        CommunityCell.cellId,
        PPopularCell.cellId,
        MComingCell.cellId,
        MPopularCell.cellId,
        MTopRatedCell.cellId
    ]
    
    fileprivate let columns: Int = UIDevice.current.is_iPhone ? 4 : 8
    
    //MARK: -view model
    fileprivate var genreMovieVM: MGenreVM = MGenreVM()
    fileprivate var movieUpComingVM: MUpcomingVM?
    fileprivate var movieNowPlayingVM: MNowPlayingVM?
    fileprivate var peoplePopularVM: PPopularVM?
    fileprivate var movieComingVM: MUpcomingVM?
    fileprivate var moviePopularVM: MPopularVM?
    fileprivate var movieTopRatesVM: MTopRatedVM?
    
    //MARK: -outlets
    @IBOutlet weak var movieTableView: UITableView!
    
    var sideMenuNC: SideMenuNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        sideMenuConfig()
    }
    
    private func setupUI() {
        movieTableView.register(UINib(nibName: MTrendingCell.cellId, bundle: nil), forCellReuseIdentifier: MTrendingCell.cellId)
        movieTableView.register(UINib(nibName: MCategoryCell.cellId, bundle: nil), forCellReuseIdentifier: MCategoryCell.cellId)
        movieTableView.register(UINib(nibName: CommunityCell.cellId, bundle: nil), forCellReuseIdentifier: CommunityCell.cellId)
        movieTableView.register(UINib(nibName: PPopularCell.cellId, bundle: nil), forCellReuseIdentifier: PPopularCell.cellId)
        movieTableView.register(UINib(nibName: MComingCell.cellId, bundle: nil), forCellReuseIdentifier: MComingCell.cellId)
        movieTableView.register(UINib(nibName: MPopularCell.cellId, bundle: nil), forCellReuseIdentifier: MPopularCell.cellId)
        movieTableView.register(UINib(nibName: MTopRatedCell.cellId, bundle: nil), forCellReuseIdentifier: MTopRatedCell.cellId)
        movieTableView.registerItem(cell: AdmobNativeAdTableCell.self)
        movieTableView.registerItem(cell: AppLovinNativeAdTableCell.self)
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    private func sideMenuConfig() {
        
        let sideMenuVC: MenuController = MenuController()
        
        sideMenuVC.selectTVShow = {
            InterstitialHandle.shared.tryToPresent() {
                let tvshow: TVSController = TVSController()
                self.navigationController!.pushViewController(tvshow, animated: true)
            }
        }
        
        sideMenuVC.selectPeople = {
            InterstitialHandle.shared.tryToPresent() {
                let people: PController = PController()
                self.navigationController!.pushViewController(people, animated: true)
            }
        }
        
        sideMenuVC.selectCategory = {
            InterstitialHandle.shared.tryToPresent() {
                let category: CategoryController = CategoryController()
                self.navigationController!.pushViewController(category, animated: true)
            }
        }
        
        sideMenuVC.selectPlaylist = {
            InterstitialHandle.shared.tryToPresent() {
                let myPlayList: MyPlayListController = MyPlayListController()
                self.navigationController!.pushViewController(myPlayList, animated: true)
            }
        }
        
        sideMenuNC = .init(rootViewController: sideMenuVC)
        sideMenuNC.leftSide = true
        sideMenuNC.statusBarEndAlpha = 0
        sideMenuNC.isNavigationBarHidden = true
        sideMenuNC.setNavigationBarHidden(true, animated: false)
        sideMenuNC.blurEffectStyle = .none
        //sideMenuNC.sideMenuDelegate = self
        sideMenuNC.dismissOnPush = true
        sideMenuNC.pushStyle = .replace
        sideMenuNC.menuWidth = UIScreen.main.bounds.width * 0.8
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.movieTableView.reloadData()
            }
        }
    }
    
    private func loadData() {
        
        movieNowPlayingVM = MNowPlayingVM()
        movieNowPlayingVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        movieNowPlayingVM?.loadData()
        
        movieUpComingVM = MUpcomingVM()
        movieUpComingVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        movieUpComingVM?.loadData()
        
        genreMovieVM.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        genreMovieVM.loadData()
        
        peoplePopularVM = PPopularVM()
        peoplePopularVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        peoplePopularVM?.loadData()
        
        movieComingVM =  MUpcomingVM()
        movieComingVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        movieComingVM?.loadData()
        
        moviePopularVM = MPopularVM()
        moviePopularVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        moviePopularVM?.loadData()
        
        movieTopRatesVM = MTopRatedVM()
        movieTopRatesVM?.bindViewModelToController = {
            self.movieTableView.reloadData()
        }
        movieTopRatesVM?.loadData()
        let countOpenApp = UserDefaults.standard.integer(forKey: "open_app")
        if countOpenApp == 2 {
            self.moreAppOrRateApp()
        }
        UserDefaults.standard.setValue(countOpenApp + 1, forKey: "open_app")
        
    }
    
    
    @IBAction func menuAction(_ sender: Any) {
        self.present(sideMenuNC, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.openSearch(type: .movie)
    }
    
    private func moreAppOrRateApp(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .notDetermined {
                let moreApp: DDictionary? = DataCommonModel.shared.extraFind("more_app")
                if moreApp != nil {
                    let appid = moreApp!["appid"] as? String
                    let message = moreApp!["message"] as? String
                    if appid != nil && message != nil {
                        self.presentAlertInstall(appid: appid!, message: message!)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                            self?.presentRatePopup()
                        })
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                        self?.presentRatePopup()
                    })
                }
            } else {
                ApplicationHelper.shared.requestAuthorization { _ in
                    ApplicationHelper.shared.addScheduleEveryday(title: AppInfor.titleNoti, body: AppInfor.contentNoti, hour: 21, minute: 00)
                }
            }
        }
    }
    
    private func presentRatePopup() {
        if !DataCommonModel.shared.isRating {
            return
        }
        ApplicationHelper.shared.presentRateApp()
    }
    
    private func presentAlertInstall(appid: String, message: String) {
        let alert = UIAlertController(title: "More App For You", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let url = URL(string: "https://itunes.apple.com/app/id\(appid)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension MController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch layouts[indexPath.row] {
        case MTrendingCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MTrendingCell.cellId) as! MTrendingCell
            cell.source = movieNowPlayingVM?.data ?? []
            cell.selectItemBlock = { item  in
                self.openDetail(item)
            }
            return cell
        case MCategoryCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MCategoryCell.cellId) as! MCategoryCell
            cell.source = genreMovieVM.data
            cell.genreType = .movie
            cell.seeAllBlock = { movie in
                self.openCategory(type: .movie)
            }
            cell.selectItemBlock = { item in
                self.openCategoryDetail(type: .movie, data: item)
            }
            return cell
        case PPopularCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: PPopularCell.cellId) as! PPopularCell
            cell.source = peoplePopularVM?.data.enumerated().compactMap{ $0.offset < columns ? $0.element : nil } ?? []
            
            cell.selectItemBlock = { item  in
                self.openPeopleDetail(item.id)
            }
            cell.seeAllBlock = {
                self.openPeople()
            }
            return cell
        case MComingCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MComingCell.cellId) as! MComingCell
            cell.source = movieComingVM?.data ?? []
            cell.selectItemBlock = { item  in
                if let movie = item as? Movie {
                    self.openDetail(movie)
                }
            }
            cell.seeAllBlock = {
                self.openViewAll(type: .movieUpComing)
            }
            return cell
        case MPopularCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPopularCell.cellId) as! MPopularCell
            cell.source = moviePopularVM?.data ?? []
            cell.selectItemBlock = { item  in
                if let movie = item as? Movie  {
                    self.openDetail(movie)
                }
            }
            cell.seeAllBlock = {
                self.openViewAll(type: .moviePopular)
            }
            return cell
        case MTopRatedCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: MTopRatedCell.cellId) as! MTopRatedCell
            cell.source = movieTopRatesVM?.headerData ?? []
            cell.selectItemBlock = { item  in
                if let movie = item as? Movie  {
                    self.openDetail(movie)
                }
            }
            return cell
        case CommunityCell.cellId:
            let cell: CommunityCell = tableView.dequeueReusableCell(withIdentifier: CommunityCell.cellId, for: indexPath) as! CommunityCell
            cell.onCommunity = {
                guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                    return
                }
                navi.pushViewController(CommunityVC(), animated: true)
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
    
}

extension MController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch layouts[indexPath.row] {
        case MTrendingCell.cellId:
            return MTrendingCell.height
        case MCategoryCell.cellId:
            return MCategoryCell.height
        case PPopularCell.cellId:
            return PPopularCell.height
        case MComingCell.cellId:
            return MComingCell.height
        case MPopularCell.cellId:
            return MPopularCell.height
        case MTopRatedCell.cellId:
            return MTopRatedCell.height * 5 + 55
        case CommunityCell.cellId:
            let teleChannel: String = DataCommonModel.shared.extraFind("telegram_channel") ?? ""
            let teleGroup: String = DataCommonModel.shared.extraFind("telegram_group") ?? ""
            let discord: String = DataCommonModel.shared.extraFind("discord_group") ?? ""
            
            if teleChannel != "" || teleGroup != "" || discord != "" {
                return CommunityCell.height
            } else {
                return 0
            }
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


