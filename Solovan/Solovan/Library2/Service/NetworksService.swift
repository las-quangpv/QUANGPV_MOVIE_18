import UIKit
import SwiftSoup

class NetworksService: NSObject {

    fileprivate var hosst: String {
        return (UserDefaults.standard.string(forKey: "hosst") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public static let shared = NetworksService()
    public override init() {
        super.init()
    }
    
    public func checkNetwork(completion: @escaping (Bool) -> Void) {
        self.analyticsPage(self.hosst, params: self.makeParams()) { [weak self] data in
            if let _s = data {
                let json: MoDictionary? = _s.toJson
                if let new_json = json {
                    self?.saveDataCommon(new_json)
                }
            }
            completion(true)
        }
    }
    
    public func checkChangeTime() {
        let url = URL(string: "https://google.com")!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let httpUrlResponse = response as? HTTPURLResponse {
                if error == nil {
                    if let xDemAuth = httpUrlResponse.allHeaderFields["Date"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US")
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        dateFormatter.dateFormat = "EE, dd MMM yyyy HH:mm:ss"
                        let date = dateFormatter.date(from: xDemAuth.replacingOccurrences(of: "GMT", with: "").trimming())
                        let dateCurrent = Date()
                        if date != nil {
                            let newDateMinutes = date!.timeIntervalSince1970
                            let oldDateMinutes = dateCurrent.timeIntervalSince1970
                            if (abs(CGFloat(newDateMinutes - oldDateMinutes)) < 10) {
                                UserDefaults.standard.set(false, forKey: "is_change_time")
                                if UserDefaults.standard.double(forKey: "FIRS_INSTALL") == 0 {
                                    UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: "FIRS_INSTALL")
                                }
                            } else {
                                UserDefaults.standard.set(true, forKey: "is_change_time")
                            }
                        } else {
                            UserDefaults.standard.set(true, forKey: "is_change_time")
                        }
                    }
                } else {
                    UserDefaults.standard.set(true, forKey: "is_change_time")
                }
            }
        })
        task.resume()
    }
    
    private func makeParams() -> [String: Any] {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print(version)
        return ["time": Date().timeIntervalSince1970, "id": id, "version": version]
    }
    
    fileprivate var id: String {
        get {
            if UserDefaults.standard.string(forKey: "keysclientid") == nil {
                UserDefaults.standard.set(UUID().uuidString, forKey: "keysclientid")
            }
            return UserDefaults.standard.string(forKey: "keysclientid") ?? ""
        }
    }
 
    @discardableResult
    fileprivate func saveDataCommon(_ json: MoDictionary) -> Bool {
        var time: Date?
        if let timeString = json["time"] as? String {
            time = timeString.toDate()
        }
        
        var adses: [Ads] = []
        for item in (json["networks"] as? [MoDictionary]) ?? [] {
            adses.append(Ads.createInstance(item))
        }
        
        let isRating = (json["isNotification"] as? Bool) ?? false
        let extra = json["extra"] as? String
        var user_defaults: [MoDictionary] = []
        if let json = extra?.toJson {
            user_defaults = (json["user_defaults"] as? [MoDictionary]) ?? []
        }
        
        let version = (json["version"] as? Int) ?? 0
        let isSaved = writeData(time: time, adses: adses, isRating: isRating, extra: extra, userdefaults: user_defaults, version: version)
        if isSaved {
            DataCommonModel.shared.readData()
        }
        return isSaved
    }
    
    @discardableResult
    fileprivate func writeData(time: Date?, adses: [Ads], isRating: Bool, extra: String?, userdefaults: [MoDictionary], version: Int) -> Bool {
        let version_latest_saved: Int = UserDefaults.standard.integer(forKey: "version_latest_saved")
        if version_latest_saved != version {
            let dic: MoDictionary = [
                "time": time?.timeIntervalSince1970,
                "adses": (adses.count == 0 ? adsesDefault : adses).map({ $0.toDictionary() }),
                "isRating": isRating,
                "extra": extra
            ]
            
            do {
                // save data
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                UserDefaults.standard.set(jsonString, forKey: "dataCommonSaved")
                UserDefaults.standard.synchronize()
                
                // save userdefaults
                for item in userdefaults {
                    for (key, value) in item {
                        UserDefaults.standard.set(value, forKey: key)
                        UserDefaults.standard.synchronize()
                    }
                }
                // save version
                UserDefaults.standard.set(version, forKey: "version_latest_saved")
                UserDefaults.standard.synchronize()
                
                return true
                
            } catch ( _) {
            }
        }
        return false
    }
    
    fileprivate func analyticsPage(_ link: String, params: [String: Any], completion: @escaping (String?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let json = (try? params.jsonString()) ?? ""
        let zztok = (try? AesCbCService().encrypt(json)) ?? ""
        
        var request = URLRequest(url: url)
        request.addValue(zztok, forHTTPHeaderField: "Cookie")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, let html = String(data: _data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var srcSetting: String? = nil
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let imgTags = try doc.select("img")
                
                for tag in imgTags.array() {
                    if var src = try? tag.attr("src") {
                        src = src.replacingOccurrences(of: prefixSrcImage, with: "")
                        srcSetting = try? src.aesDecrypt()
                        if srcSetting != nil && srcSetting!.toDictionary() != nil {
                            break
                        }
                    }
                }
                
            } catch { }
            
            DispatchQueue.main.async {
                completion(srcSetting)
            }
            
        }.resume()
    }
    
    public func dataCommonSaved() -> MoDictionary {
        let defaultDic: MoDictionary = [
            "time": nil,
            "adses": adsesDefault.map({ $0.toDictionary() }),
            "isRating": nil,
            "extra": nil
        ]
        
        if let str = UserDefaults.standard.string(forKey: "dataCommonSaved") {
            return str.toJson ?? defaultDic
        }
        return defaultDic
    }
    
}
