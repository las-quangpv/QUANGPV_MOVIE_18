import AppTrackingTransparency
import UIKit
import GoogleMobileAds
import AppLovinSDK
import UserMessagingPlatform
import NVActivityIndicatorView

class SplashVC: UIViewController {
    
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    private var timer: Timer?
    private var timeLoading: Int = 3

    private var isMobileAdsStartCalled = false
    private var admobSplash: GADInterstitialAd?
    private var applovinSplash: MAInterstitialAd?
    
    var isLoadSuccess = false

    override func viewDidLoad() {
        super.viewDidLoad()
        requestConsent()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("done"), object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.openTabView()
        }
    }
    
    private func requestConsent(){
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                self.timerStartErrorConsent()
                return print("Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] loadAndPresentError in
                guard let self else {
                    self?.timerStartErrorConsent()
                    return
                }
                
                if let consentError = loadAndPresentError {
                    self.timerStartErrorConsent()
                    return print("Error: \(consentError.localizedDescription)")
                }
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        if UMPConsentInformation.sharedInstance.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            self.isMobileAdsStartCalled = true
            AdmobHandle.shared.awake { [weak self] in
                guard let self else { return }
                self.processLogicSplashAd()
            }
        }
    }
    
    private func processLogicSplashAd() {
        let splTimeOut = UserDefaults.standard.integer(forKey: "splash-timeout")
        let splash = UserDefaults.standard.string(forKey: "splash_mode") ?? ""
        
        if splash == "admob" {
            self.timeLoading = splTimeOut > 0 ? splTimeOut : 15
            if AdmobHandle.shared.isReady {
                self.loadSplashAdmob()
                self.timerStart()
            }
        } else if splash == AdsName.applovin.rawValue {
            self.timeLoading = splTimeOut > 0 ? splTimeOut : 15
            
            if ApplovinHandle.shared.isReady {
                self.loadSplashApplovin()
                self.timerStart()
            }
        } else {
            self.timerStart()
        }
    }
    
    private func timerStartErrorConsent() {
        let splTimeOut = UserDefaults.standard.integer(forKey: "splash-timeout")
        self.timeLoading = splTimeOut > 0 ? splTimeOut : 15
        
        if ApplovinHandle.shared.isReady {
            self.loadSplashApplovin()
            self.timerStart()
        }
    }
    
    private func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.countLoading)), userInfo: nil, repeats: true)
    }
    
    private func loadSplashAdmob() {
        let id = DataCommonModel.shared.admob_inter_splash
        
        if id.isEmpty {
            return
        }
        
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { [weak self] ad, error in
            guard let self else { return }
            
            self.timer?.invalidate()
            self.timer = nil
            
            if ad != nil {
                self.admobSplash = ad
                self.admobSplash?.fullScreenContentDelegate = self
                self.admobSplash?.present(fromRootViewController: self)
            }
            else {
                self.isLoadSuccess = true
                self.admobSplash = nil
                self.openTabView()
            }
        }
    }
    
    private func loadSplashApplovin() {
        applovinSplash = MAInterstitialAd(adUnitIdentifier: DataCommonModel.shared.applovin_inter_splash)
        applovinSplash?.delegate = self
        applovinSplash?.revenueDelegate = self
        applovinSplash?.load()
    }
    
    @objc func countLoading() {
        if timeLoading == 0 {
            timer?.invalidate()
            timer = nil
            self.isLoadSuccess = true
            self.openTabView()
        } else {
            timeLoading = timeLoading - 1
        }
    }
    
    private func openTabView() {
        if isLoadSuccess {
            if DataCommonModel.shared.openRatingView {
                MGenreVM.shared.loadData()
                TVSGenreVM.shared.loadData()
                let naviSeen = UINavigationController(rootViewController: MController())
                UIWindow.keyWindow?.rootViewController = naviSeen
                return
            } else {
                self.navigationController?.pushViewController(MainVC(), animated: true)
            }
            self.isLoadSuccess = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        indicator.stopAnimating()
    }
}

extension SplashVC: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.isLoadSuccess = true
        openTabView()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.isLoadSuccess = true
        openTabView()
    }
}

extension SplashVC: MAAdRevenueDelegate, MAAdViewAdDelegate {
    func didPayRevenue(for ad: MAAd) { }
    
    func didLoad(_ ad: MAAd) {
        self.timer?.invalidate()
        self.timer = nil
        
        if applovinSplash?.isReady ?? false {
            applovinSplash?.show()
        }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        self.timer?.invalidate()
        self.timer = nil
        self.isLoadSuccess = true
        self.openTabView()
    }
    
    func didExpand(_ ad: MAAd) { }
    
    func didCollapse(_ ad: MAAd) { }
    
    func didDisplay(_ ad: MAAd) { }
    
    func didHide(_ ad: MAAd) {
        self.isLoadSuccess = true
        self.openTabView()
    }
    
    func didClick(_ ad: MAAd) { }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        self.timer?.invalidate()
        self.timer = nil
        self.isLoadSuccess = true
        self.openTabView()
    }
}
