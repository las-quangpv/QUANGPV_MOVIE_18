
import UIKit
import AVFoundation
import Kingfisher

typealias Dictionary = [String: Any]
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

extension UIImageView{
    func setImage(urlStr: String){
        self.kf.setImage(with: URL(string: ("https://image.tmdb.org/t/p/w500"+urlStr)))
    }
}

extension AVAsset {
    var fullRange: CMTimeRange {
        return CMTimeRange(start: .zero, duration: duration)
    }
    func trimmedComposition(_ range: CMTimeRange) -> AVAsset {
        guard CMTimeRangeEqual(fullRange, range) == false else {return self}

        let composition = AVMutableComposition()
        try? composition.insertTimeRange(range, of: self, at: .zero)

        if let videoTrack = tracks(withMediaType: .video).first {
            composition.tracks.forEach {$0.preferredTransform = videoTrack.preferredTransform}
        }
        return composition
    }
    
    func getArtwork() -> UIImage? {
      if let metaArtwork = self.metadata.first(where: {$0.commonKey == .commonKeyArtwork}), let data = metaArtwork.value as? Data {
        let image = UIImage(data: data)
        return image
      }
       
      let imageGenerator = AVAssetImageGenerator(asset: self)
      imageGenerator.appliesPreferredTrackTransform = true
       
      let durationSeconds = CMTimeGetSeconds(self.duration)
      let time = durationSeconds > 1 ? CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC)) : .zero
      var actualTime: CMTime = CMTime.zero
      do {
          let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
          let image = UIImage(cgImage: imageRef)
          return image
      } catch let error as NSError {
          print("\(error.description). Time: \(actualTime)")
      }
      return nil
    }
}

extension UILabel {
   func setFontSize(size: CGFloat) {
       self.font = UIFont(name: "Pacifico-Regular", size: size)
    }
}

extension CMTime {
    var displayString: String {
        let offset = TimeInterval(seconds)
        let numberOfNanosecondsFloat = (offset - TimeInterval(Int(offset))) * 1000.0
        let nanoseconds = Int(numberOfNanosecondsFloat)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return String(format: "%@.%0d", formatter.string(from: offset) ?? "00:00", nanoseconds)
    }
    var convertSecond: Double {
        let offset = TimeInterval(seconds)
        return Double(offset)
    }
}


extension String {
   func getUrlFromFileName() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newUrl = documentsURL.appendingPathComponent(self)
       return newUrl
    }
}

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        self.init(red, green, blue, 1.0)
    }
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(hex:Int) {
        self.init((hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff)
    }
    
    func toHexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        
        return String(format: "#%06x", rgb)
    }
    
    func toHex() -> Int? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
            
            let rgb = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
            return rgb
        }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func applyShadow(color: UIColor, cornerRadius: CGFloat, blur: CGFloat, height: CGFloat) {
        // Đặt màu sắc bóng
        layer.shadowColor = color.cgColor
        
        // Đặt độ mờ của bóng
        layer.shadowOpacity = 1.0 // Đặt độ mờ tối đa
        
        // Đặt kích thước bóng
        layer.shadowOffset = CGSize(width: 0, height: height)
        
        // Đặt độ mờ (blur) của bóng
        layer.shadowRadius = blur
        
        // Đặt bo góc cho view
        layer.cornerRadius = cornerRadius
        
        // Đặt `masksToBounds` là `false` để bóng có thể hiển thị ngoài biên của view
        layer.masksToBounds = false
    }
}


func writeString(string: String, fileName: String) {
   do {
       
       if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
           let fileURL = documentDirectory.appendingPathComponent(fileName)
           if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
               FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
           }
           try string.write(to: fileURL, atomically: false, encoding: .utf8)
       }
   } catch {
       
   }
}


 func convertDataToJSON(data: Data) -> Any? {
      do {
          return try JSONSerialization.jsonObject(with: data, options: [])
      } catch { }
      return nil
}

func convertDictionaryToString(dictionary: Dictionary) -> String? {
    if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }
    return nil
}


func imageToDoc(image: UIImage, completion: (String) ->Void) {
    let fileName: String = "\(Date().timeIntervalSince1970).png"
    guard let imageData = image.pngData() else {
        completion("")
        return
    }

    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        completion("")
        return
    }

    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    do {
        try imageData.write(to: fileURL)
        completion(fileName)
    } catch {
        completion("")
    }
}

func loadImageFromDoc(fileName: String) -> UIImage? {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }

    let fileURL = documentsDirectory.appendingPathComponent("\(fileName)")
    if !fileManager.fileExists(atPath: fileURL.path) {
        return nil
    }
    
    if let imageData = try? Data(contentsOf: fileURL) {
        return UIImage(data: imageData)
    } else {
        return UIImage(named: "ic_placeholder")
    }
}

func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)

    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print(error)
    }

    return nil
}

func getVideoDuration(from url: URL) -> String {
    let asset = AVAsset(url: url)
    
    // Lấy thời lượng video tính bằng giây
    let duration = asset.duration
    let durationInSeconds = CMTimeGetSeconds(duration)
    
    // Chuyển đổi giây thành phút và giây
    let minutes = Int(durationInSeconds) / 60
    let seconds = Int(durationInSeconds) % 60
    
    // Định dạng dưới dạng "00:00"
    let formattedDuration = String(format: "%02d:%02d", minutes, seconds)
    
    return formattedDuration
}

var colorBegin: [ColorModel] = [
    ColorModel(colorHex: 0x2F6344, tag: "Action"),
    ColorModel(colorHex: 0x289B79, tag: "Adventure"),
    ColorModel(colorHex: 0x28799B, tag: "Animation"),
    ColorModel(colorHex: 0x28349B, tag: "Comedy"),
    ColorModel(colorHex: 0x62289B, tag: "Crime"),
    ColorModel(colorHex: 0x9B2890, tag: "Documentary"),
    ColorModel(colorHex: 0x9B284B, tag: "Fantasy"),
    ColorModel(colorHex: 0x9B6D28, tag: "TV Show")
]

