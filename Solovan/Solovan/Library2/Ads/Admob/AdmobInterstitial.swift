import UIKit
import GoogleMobileAds

class AdmobInterstitial: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitial: GADInterstitialAd?
    private var _closeHandler: ((Bool) -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - override from supper
    override var canShowAds: Bool {
        if DataCommonModel.shared.admob_inter.isEmpty {
            return false
        }
        
        return true
    }
    
    override func preloadAd(completion: @escaping (Bool) -> Void) {
        self._interstitial = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = DataCommonModel.shared.admob_inter
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            if ad != nil {
                self._interstitial = ad
                self._interstitial?.fullScreenContentDelegate = self
                completion(true)
            }
            else {
                self._interstitial = nil
                if error != nil {
                }
                completion(false)
            }
        }
    }
    
    func tryToPresent(with closeHandler: @escaping (Bool) -> Void) {
        self._closeHandler = nil
        
        guard let rootController = UIWindow.keyWindow?.topMost else {
            closeHandler(false)
            return
        }
        
        let loadView = LoadingView()
        loadView.setMessage("Loading ads...")
        loadView.show()
        
        self.preloadAd { isSuccess in
            loadView.dismiss()
            if isSuccess {
                self._closeHandler = closeHandler
                if let presented = rootController.presentedViewController {
                    self._interstitial?.present(fromRootViewController: presented)
                } else {
                    self._interstitial?.present(fromRootViewController: rootController)
                }
            } else {
                closeHandler(false)
            }
        }
    }
}

extension AdmobInterstitial: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let handler = self._closeHandler {
            handler(true)
            self._closeHandler = nil
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if let handler = self._closeHandler {
            handler(true)
            self._closeHandler = nil
        }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
