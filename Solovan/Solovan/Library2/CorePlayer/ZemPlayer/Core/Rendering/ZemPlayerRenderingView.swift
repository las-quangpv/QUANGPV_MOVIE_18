import UIKit
import AVKit

open class ZemPlayerRenderingView: UIView {
    var widthMaxConstraint: NSLayoutConstraint?
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 0
        let fontSize = UIDevice.current.userInterfaceIdiom == .pad ? 35.0 : 20.0
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 1.0
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    lazy public var playerLayer: AVPlayerLayer = {
        return layer as! AVPlayerLayer
    }()
    
    /// ZemPlayer instance being rendered by renderingLayer
    public weak var player: ZemPlayer!
    
    deinit {
        
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///     - player: ZemPlayer instance to render.
    public init(with player: ZemPlayerView) {
        super.init(frame: CGRect.zero)
        playerLayer.player = player.player
        
        addSubview(subtitleLabel)
        
        subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        
        widthMaxConstraint = subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        widthMaxConstraint?.isActive = true
        
        subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let guide = safeAreaLayoutGuide
        let width = guide.layoutFrame.size.width
        widthMaxConstraint?.constant = width - 100
    }
    
}
