import UIKit
import AppLovinSDK
import AdSupport

public class ApplovinHandle: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        return _isReady
    }
    
    // MARK: - initial
    @objc public static let shared = ApplovinHandle()
    
    // MARK: private
    
    // MARK: public
    @objc public func awake(completion: @escaping () -> Void) {
        
        let initConfig = ALSdkInitializationConfiguration(sdkKey: DataCommonModel.shared.APPLOVIN_SDK_KEY) { builder in
            builder.mediationProvider = ALMediationProviderMAX
            if let currentIDFV = UIDevice.current.identifierForVendor?.uuidString {
                #if DEBUG
                    builder.testDeviceAdvertisingIdentifiers = [currentIDFV]
                #endif
            }
        }
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
            self._isReady = true
            completion()
        }
    }
}
