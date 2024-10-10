import UIKit


extension UIFont {
    static func lexendRegular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "LexendDeca-Regular", size: size)
    }
}

extension UIImage {
    class func original(_ name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
}

extension UIColor {
    static let shadow = UIColor.init(hex: 0x8F8F8F).withAlphaComponent(0.8)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time) % 60
        let hours = (time / 60)
        return String(format: "%0.1dh%0.2dm",hours,minutes)
    }
}

extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    static var cellID: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UILabel {
    func labelTwoColor(title: String, colorTitle: UIColor, fontTitle: UIFont? = nil, detail: String, colorDetail: UIColor, fontDetail: UIFont? = nil) {
        let ss = "\(title)\(detail)"
        let attributed = NSMutableAttributedString(string: ss)
        
        // title
        let range1 = NSString(string: ss).range(of: title)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTitle, range: range1)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontTitle ?? UIFont.lexendRegular(16))!, range: range1)
        
        // detail
        let range2 = NSString(string: ss).range(of: detail)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorDetail, range: range2)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontDetail ?? UIFont.lexendRegular(16))!, range: range2)
        
        self.attributedText = attributed
    }
}

extension String {
    func trimming() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var toJson: MoDictionary? {
        let data = Data(self.utf8)
        
        do {
            // make sure this JSON is in the format we expect
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? MoDictionary
            return json
        } catch let error as NSError {
            print("Convert to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension Dictionary {
    func jsonString() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError.make(code: 1002, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
    
    func toData() throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: self)
        return data
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        // iOS13 or later
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return nil }
            return sceneDelegate.window
        } else {
            // iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
    
    var topMost: UIViewController? {
        return UIWindow.keyWindow?.rootViewController
    }
    
}

extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIView {
    
    func setImageBackground() {
        backgroundColor = .shadow
    }
    

    func roundTopLeftRight(radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
      //  layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}

extension UIButton {
    func roundLeftTopBottom(radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func roundRightTopBottom(radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}

func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}

extension UITableView {
    func registerItem<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func registerItemNib<T: UITableViewCell>(cell: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let cell = dequeueReusableCell(withIdentifier: T.identifier) as! T
        return cell
    }
}
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

