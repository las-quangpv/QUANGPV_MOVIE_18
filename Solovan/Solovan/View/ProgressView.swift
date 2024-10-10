
import UIKit
class ProgressView: UIView {
    let uiActivityIndicatorView: UIActivityIndicatorView = {
        var uictivityIndicatorView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            uictivityIndicatorView = UIActivityIndicatorView(style: .large)
        } else {
            uictivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            
        }
        uictivityIndicatorView.color = .blue
        uictivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return uictivityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.clipsToBounds = true
        uiActivityIndicatorView.startAnimating()
        addSubview(uiActivityIndicatorView)
        uiActivityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        uiActivityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
