import Foundation

struct Ads {
    public let name: AdsName
    public let sort: Int?
    public let adUnits: [String]
    
    public func toDictionary() -> MoDictionary {
        return [
            "name": name.rawValue,
            "sort": sort,
            "adUnits": adUnits
        ]
    }
    
    public static func createInstance(_ d: MoDictionary) -> Ads {
        var name: AdsName = .admob
        if let _name = d["name"] as? String, let type = AdsName(rawValue: _name) {
            name = type
        }
        
        let sort = d["sort"] as? Int
        
        var adUnits: [String] = []
        if let s = d["adUnits"] as? String {
            adUnits = s.components(separatedBy: ",").map({ val in
                return val.trimmingCharacters(in: .whitespacesAndNewlines)
            })
        }
        
        return Ads(name: name, sort: sort, adUnits: adUnits)
    }
}

let adsesDefault: [Ads] = [
    Ads(name: .admob, sort: 1, adUnits: [AdsUnit.banner.rawValue, AdsUnit.native.rawValue]),
    Ads(name: .applovin, sort: 2, adUnits: [AdsUnit.banner.rawValue, AdsUnit.native.rawValue])
]
