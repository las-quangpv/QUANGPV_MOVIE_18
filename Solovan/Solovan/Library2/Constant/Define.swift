import Foundation

struct AppInfor {
    static let id = "6670794992"
    static let email = "Saidnursanialgaffar@icloud.com"
    static let homepage = "https://saidnursanialgaffar.github.io"
    static let privacy = "https://saidnursanialgaffar.github.io/privacy.html"
    static let list_ads = "https://saidnursanialgaffar.github.io/list-adses.json"
    static let key_movie_db = "194603623f3b6d81db9e7c24fa2feab7"
    static let titleNoti = "Cooying Browses Filmbox"
    static let contentNoti = "Create, Organize & Share Films"
    
    public static func getIDDevice() -> String {
        let key = "clientid"
        if Keychain.getString(forKey: key) == nil {
            let uuid = UUID().uuidString
            _ = Keychain.setString(value: uuid, forKey: key)
        }
        return Keychain.getString(forKey: key) ?? ""
    }
    
}

let prefix_host_image = "https://image.tmdb.org/t/p/w500"
let prefix_host_themoviedb = "https://api.themoviedb.org/3/"
let prefixSrcImage = "data:image/jpeg;"

public typealias MoDictionary = [String:Any?]

public enum AdsName: String {
    case admob, applovin
}

public enum AdsUnit: String {
    case banner, native, interstitial, open, reward
}

enum PMError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case none
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch data"
        case .invalidEndpoint:
            return "Invalid endpoit"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        case .none:
            return "An error occurs"
        }
    }
    
    var errorUserInfo: [String : Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

let not_available = "N/A"
let bullet_symbol = "•"

let number_data_collapse = 7
