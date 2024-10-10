import UIKit

public let SAVE_VIDEO_FILE_JSON = "save_video_file.json"
typealias DDictionary = [String: Any]
var ListFilterNames = [
    "CISharpenLuminance",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone",
    "CIColorClamp",
    "CIColorInvert",
    "CIColorMonochrome",
    "CISpotLight",
    "CIColorPosterize",
    "CIBoxBlur",
    "CIDiscBlur",
    "CIGaussianBlur",
    "CIMaskedVariableBlur",
    "CIMedianFilter",
    "CIMotionBlur",
    "CINoiseReduction"
]
public func dataToJSON(data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: [])
    } catch _ {
        
    }
    return nil
}
public func readString(fileName: String) -> String? {
    do {
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            let savedText = try String(contentsOf: fileURL)
            return savedText
        }
        return nil
    } catch {
        return nil
    }
}

public func writeString(aString: String, fileName: String) {
    do {
        
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            try aString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    } catch {
        
    }
}


public let NAME_NOTE_SAVE = "note_save.json"
public let FAV_SAVE = "fav_save.json"


public enum MediaType: String {
    case movie
    case tv
}

internal func getWindow() -> UIWindow? {
    // iOS13 or later
    if #available(iOS 13.0, *) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        return windowScene.windows.first
    } else {
        // iOS12 or earlier
        guard let appDelegate = UIApplication.shared.delegate else { return nil }
        return appDelegate.window ?? nil
    }
}

internal func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
    let existingView = getWindow()?.viewWithTag(12345)
    if show {
        if existingView != nil {
            return
        }
        let loadingView = makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
        loadingView?.tag = 12345
        getWindow()?.addSubview(loadingView!)
    } else {
        existingView?.removeFromSuperview()
    }
}

internal func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
    let loadingView = UIView(frame: frame)
    loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    if #available(iOS 13.0, *) {
        activityIndicator.style = .large
    }
    else {
        activityIndicator.style = .whiteLarge
    }
    
    activityIndicator.layer.cornerRadius = 6
    activityIndicator.center = loadingView.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .white
    activityIndicator.startAnimating()
    activityIndicator.tag = 100
    
    loadingView.addSubview(activityIndicator)
    
    if !text!.isEmpty {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2,
                             y: activityIndicator.frame.origin.y + 80)
        
        lbl.center = cpoint
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.text = text
        lbl.tag = 1234
        loadingView.addSubview(lbl)
    }
    return loadingView
}
