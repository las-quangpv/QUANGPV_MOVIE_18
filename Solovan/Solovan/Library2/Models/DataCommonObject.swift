import Foundation

struct DataCommonModel {
    private let key = "fizfiozpen"
    
    fileprivate var fiozpen: Date {
        if UserDefaults.standard.object(forKey: key) as? Date == nil {
            UserDefaults.standard.set(Date(), forKey: key)
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.object(forKey: key) as! Date
    }
    
    fileprivate var time: Date?
    fileprivate var extra: String? {
        didSet {
            if let json = extra?.toJson {
                extraJSON = json
            } else {
                extraJSON = nil
            }
        }
    }
    fileprivate var extraJSON: MoDictionary?
    
    fileprivate var _allAds: [Ads] = adsesDefault
    fileprivate var adsActtive: [Ads] {
        return _allAds.sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public var openRatingView: Bool {
        guard let _time = time else {
            return false
        }
        if UserDefaults.standard.bool(forKey: "is_change_time") {
            return false
        }
        let timeIncremental: Int? = DataCommonModel.shared.extraFind("time_incremental")
        if timeIncremental == nil {
            return _time.timeIntervalSince1970 >= fiozpen.timeIntervalSince1970
        } else {
            if Date().timeIntervalSince1970 > UserDefaults.standard.double(forKey: "FIRS_INSTALL") + Double(timeIncremental!) {
                return true
            } else {
                return false
            }
        }
    }
    
    public var isRating: Bool = false
    
    // MARK: - static instance
    public static var shared = DataCommonModel()
    
    let APPLOVIN_SDK_KEY = "-gZCVF8CrTwrEnJlmARhvqx70po9HDW0V4Ar-099uam0f3DORup6y9f5_6GvXPy_-Kv7CkquXAGJhPudC-PXeK"
    
    // MARK: - keys admob
    @LocalStorage(key: "admob_banner", value: "ca-app-pub-8704589597859780/6216928795")
    public var admob_banner: String
    
    @LocalStorage(key: "admob_inter", value: "ca-app-pub-8704589597859780/8218806995")
    public var admob_inter: String
    
    @LocalStorage(key: "admob_inter_splash", value: "ca-app-pub-8704589597859780/7338438779")
    public var admob_inter_splash: String
    
    @LocalStorage(key: "admob_reward", value: "ca-app-pub-8704589597859780/6773863386")
    public var admob_reward: String
    
    @LocalStorage(key: "admob_reward_interstitial", value: "ca-app-pub-8704589597859780/6025357102")
    public var admob_reward_interstitial: String
    
    @LocalStorage(key: "admob_small_native", value: "ca-app-pub-8704589597859780/4968222460")
    public var admob_small_native: String
    
    @LocalStorage(key: "admob_medium_native", value: "ca-app-pub-8704589597859780/2086112095")
    public var admob_medium_native: String
    
    @LocalStorage(key: "admob_manual_native", value: "ca-app-pub-8704589597859780/3702446095")
    public var admob_manual_native: String
    
    @LocalStorage(key: "admob_appopen", value: "ca-app-pub-8704589597859780/8459948754")
    public var admob_appopen: String
    
    
    // MARK: - keys applovin
    @LocalStorage(key: "applovin_banner", value: "af36f0ac539b94fa")
    public var applovin_banner: String
    
    @LocalStorage(key: "applovin_inter", value: "5d7809209292f7ab")
    public var applovin_inter: String
    
    @LocalStorage(key: "applovin_inter_splash", value: "f9d8664df901d91d")
    public var applovin_inter_splash: String
    
    @LocalStorage(key: "applovin_reward", value: "3eeb020d2726f9e2")
    public var applovin_reward: String
    
    @LocalStorage(key: "applovin_small_native", value: "b44171850307690c")
    public var applovin_small_native: String
    
    @LocalStorage(key: "applovin_medium_native", value: "ee6430c375ca81de")
    public var applovin_medium_native: String
    
    @LocalStorage(key: "applovin_manual_native", value: "8ace90c232233b69")
    public var applovin_manual_native: String
    
    @LocalStorage(key: "applovin_appopen", value: "26ac2a668346e2c2")
    public var applovin_appopen: String
    
    // ?
    @LocalStorage(key: "applovin_id", value: "")
    public var applovin_id: String
}

extension DataCommonModel {
    public func extraFind<T>(_ key: String) -> T? {
        return (extraJSON ?? [:])[key] as? T
    }
    
    public func adsAvailableFor(_ name: AdsName) -> Ads? {
        return self.adsActtive.filter({ $0.name == .admob }).first
    }
    
    public func adsAvailableFor(_ unit: AdsUnit) -> [Ads] {
        return self.adsActtive.filter({ $0.adUnits.contains(unit.rawValue) }).sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public func isAvailable(_ name: AdsName, _ unit: AdsUnit) -> Bool {
        return self.adsAvailableFor(unit).contains(where: { $0.name == name })
    }
    
    public mutating func readData() {
        let data = NetworksService.shared.dataCommonSaved()
        
        if let timestamp = data["time"] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: timestamp)
        }
        if let listAds = data["adses"] as? [MoDictionary] {
            self._allAds.removeAll()
            for dic in listAds {
                if let name = dic["name"] as? String, let type = AdsName(rawValue: name) {
                    let m = Ads(name: type, sort: dic["sort"] as? Int, adUnits: (dic["adUnits"] as? [String]) ?? [])
                    self._allAds.append(m)
                }
            }
        }
        
        self.isRating = (data["isRating"] as? Bool) ?? false
        self.extra = data["extra"] as? String
    }
    
}
