import UIKit

class InterstitialHandle: NSObject {
    
    // MARK: - properties
    private var _admobHandle = AdmobInterstitial()
    private var _applovinHandle = ApplovinInterstitial()
    var timeShowAds = 0
    // MARK: - initial
    static let shared = InterstitialHandle()
    
    func tryToPresent(_ block: @escaping () -> Void) {
        var timeBeetweenInter: Int = 15
        if DataCommonModel.shared.extraFind("time_beetween_inter") == nil {
            timeBeetweenInter = 15
        } else {
            timeBeetweenInter = DataCommonModel.shared.extraFind("time_beetween_inter")!!
        }
        
        if Int(Date().timeIntervalSince1970) > timeBeetweenInter + timeShowAds {
            _admobHandle.tryToPresent { success in
                if success {
                    self.timeShowAds = Int(Date().timeIntervalSince1970)
                    block()
                } else {
                    self._applovinHandle.tryToPresent {
                        self.timeShowAds = Int(Date().timeIntervalSince1970)
                        block()
                    }
                }
            }
        } else {
            block()
        }
    }
    
    func present(_ block: @escaping () -> Void) {
        _admobHandle.tryToPresent { success in
            if success {
                self.timeShowAds = Int(Date().timeIntervalSince1970)
                block()
            } else {
                self._applovinHandle.tryToPresent {
                    self.timeShowAds = Int(Date().timeIntervalSince1970)
                    block()
                }
            }
        }
    }
}
