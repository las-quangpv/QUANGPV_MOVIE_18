

import UIKit

class EnterTextView: UIView {
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var boderView: BoderView!
    
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
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func styleTagPopup() {
        boderView.radius = 20
        tf.textAlignment = .center
    }
    
    func getText() -> String {
        return tf.text ?? ""
    }
    
    func setText(str: String) {
        tf.text = str
    }
    
    @IBInspectable var placeHolderStr: String = "Enter here" {
        didSet {
            let placeholderText = placeHolderStr
            let placeholderColor = UIColor(hex: 0xA4CD7B)
            tf.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
    }
}
