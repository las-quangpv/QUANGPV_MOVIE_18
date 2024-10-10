import UIKit
import GoogleMobileAds

class AdmobReward: NSObject {
    
    // MARK: - properties
  @objc public static let shared = AdmobReward()
  private var _rewardedAd: GADRewardedAd?
  private var _closeHandler: (() -> Void)?
  
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: private
    
    // MARK: -
    var canShowAds: Bool {
        if DataCommonModel.shared.admob_reward.isEmpty {
            return false
        }
        return true
    }
    
    var isReady: Bool {
        return _rewardedAd != nil
    }
    
    // MARK: - public
    func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        self._rewardedAd = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = DataCommonModel.shared.admob_reward
        GADRewardedAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            if ad != nil {
                self._rewardedAd = ad
                self._rewardedAd?.fullScreenContentDelegate = self
                completion(true)
            }
            else if error != nil {
                self._rewardedAd = nil
                completion(false)
            }
        }
    }
    
    func tryToPresentDidEarnReward(with handler: @escaping () -> Void) {
      let loadView = LoadingView()
      loadView.setMessage("Loading ads...")
      loadView.show()
      self.preloadAd { success in
        loadView.dismiss()
        if success {
          guard let rootController = UIWindow.keyWindow?.topMost else {
              handler()
              return
          }
          
          if let presented = rootController.presentedViewController {
            self._closeHandler = handler
            self._rewardedAd?.present(fromRootViewController: presented, userDidEarnRewardHandler: {})
          } else {
            self._closeHandler = handler
            self._rewardedAd?.present(fromRootViewController: rootController, userDidEarnRewardHandler: {})
          }
        } else {
            ApplovinReward.shared.tryToPresentDidEarnReward {
                handler()
            }
        }
      }
    }
}

extension AdmobReward: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      if let handler = self._closeHandler {
          handler()
          self._closeHandler = nil
      }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      if let handler = self._closeHandler {
          handler()
          self._closeHandler = nil
      }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
