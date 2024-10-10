import UIKit
import SideMenu
import GoogleMobileAds
import AppLovinSDK
import AppTrackingTransparency

enum GenreType {
    case movie
    case television
}

class BVC: UIViewController {
    
    
    
    // MARK: - Config screen present landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    var nativeIndex: Int = 0
    var loadedNative: Bool = false
    
    fileprivate var admobNative: AdmobNative?
    fileprivate var applovinNative: ApplovinNative?
    var admobAd: GADNativeAd?
    var applovinAdView: MANativeAdView?
    
    // MARK: - life cycle viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func hasRequestTrackingIDFA() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    func loadNativeAd(_ completion: @escaping () -> Void) {
        if hasRequestTrackingIDFA() == false {
            return
        }
        
        let nativesAvailable = DataCommonModel.shared.adsAvailableFor(.native)
        if nativeIndex >= nativesAvailable.count {
            return
        }
        
        let name = nativesAvailable[nativeIndex].name
        nativeIndex += 1
        
        switch name {
        case .admob:
            if admobNative != nil { return }
            
            admobNative = AdmobNative(numberOfAds: 1, nativeDidReceive: { [weak self] natives in
                if natives.first != nil {
                    self?.loadedNative = true
                    self?.admobAd = natives.first
                    completion()
                }
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            admobNative?.preloadAd(controller: self)
            
        case .applovin:
            if applovinNative != nil { return }
            
            applovinNative = ApplovinNative(nativeDidReceive: { [weak self] (nativeAdView, nativeAd) in
                self?.loadedNative = true
                self?.applovinAdView = nativeAdView
                completion()
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            applovinNative?.preloadAd(controller: self)
            
        }
    }
    
    func numberOfNatives() -> Int {
        return admobAd != nil || applovinAdView != nil ? 1 : 0
    }

}
extension BVC {
    func openCategory(type: CategoryTab) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            let category: CategoryController  = CategoryController()
            category.tabSelected = type
            navi.pushViewController(category, animated: true)
        }
    }
    
    func openCategoryDetail(type: GenreType, data: Genre){
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }

            let categoryDetail: CategoryDetailController = CategoryDetailController()
            categoryDetail.type = type
            categoryDetail.genres = data
            navi.pushViewController(categoryDetail, animated: true)
        }
    }
    
    func openPeople() {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            let people: PController = PController()
            navi.pushViewController(people, animated: true)
        }
    }
    
    func openPeopleDetail(_ peopleId: Int) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let peopleDetail: PDetailController = PDetailController()
            peopleDetail.peopleId = peopleId
            navi.pushViewController(peopleDetail, animated: true)
        }
    }
    
    func openDetail(_ movie: Movie) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let movieDetail: MDetailController = MDetailController()
            movieDetail.movieId = movie.id
            navi.pushViewController(movieDetail, animated: true)
        }
    }
    
    func openDetail(_ tele: TvShow) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let teleDetail: TVSDetailController = TVSDetailController()
            teleDetail.tvShowId = tele.id
            navi.pushViewController(teleDetail, animated: true)
        }
    }
    
    func openEpisodes(tvId: Int, seasonNumber: Int, seasonName: String) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let season: SeasonDetailController = SeasonDetailController()
            season.tvId = tvId
            season.seasonNumber = seasonNumber
            season.seasonName = seasonName
            navi.pushViewController(season, animated: true)
        }
    }
    
    func openViewAll(type: ListMovieType){
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let viewAll: ViewAllController = ViewAllController()
            viewAll.typeSelected = type
            navi.pushViewController(viewAll, animated: true)
        }
    }
    
    func openSearch(type: SearchType){
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let search: SearchController = SearchController()
            search.searchType = type
            navi.pushViewController(search, animated: true)
        }
    }
    
}
