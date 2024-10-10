

import UIKit
import Lottie
class EmptyView: UIView {
    @IBOutlet weak var animationView: UIView!
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        lbEmpty.setFontSize(size: 18)
        addAnimationWithView()
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addAnimationWithView() {
        let anim = LottieAnimationView(name: "empty")
        anim.contentMode = .scaleAspectFit
        animationView.addSubview(anim)
        anim.frame = CGRect(x: 0, y: 0, width: animationView.frame.width, height: animationView.frame.height)
        DispatchQueue.main.async {
            anim.play(fromProgress: 0,
                                       toProgress: 1,
                                       loopMode: LottieLoopMode.loop,
                                       completion: { (finished) in})
        }
    }
    
}
