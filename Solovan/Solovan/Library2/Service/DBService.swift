import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

public class DBService: NSObject {

    @objc public static let shared = DBService()
    
    // MARK: - init
    override init() { }
    
    // MARK: - private
    private func fromBase64(s: String) -> String? {
        guard let data = Data(base64Encoded: s) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func saveTimeAdsesLatest() {
        DispatchQueue.global(qos: .userInitiated).async {
            let adsid = UserDefaults.standard.string(forKey: "applovin_id") ?? ""
            if let hosst = try? AesCbCService().decrypt(adsid) {
                UserDefaults.standard.set(hosst, forKey: "hosst")
                UserDefaults.standard.synchronize()
                DataCommonModel.shared.readData()
                
                NetworksService.shared.checkNetwork { connection in
                    NotificationCenter.default.post(name: NSNotification.Name("done"), object: nil)
                }
            }
        }
    }
}
