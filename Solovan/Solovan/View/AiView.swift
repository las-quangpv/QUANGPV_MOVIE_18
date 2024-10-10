//
//  AiView.swift
//  Movie018
//
//  Created by Mac on 14/9/24.
//

import UIKit

class AiView: UIView {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    
    @IBOutlet weak var boderView: BoderView!
    var index = 0
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
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    

}
