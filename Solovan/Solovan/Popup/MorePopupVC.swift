

import UIKit

class MorePopupVC: BaseVC {
    var morePopupBlock:((Int) -> Void)?

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnEdit.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 16)
        btnAdd.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 16)
        btnShare.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 16)
        btnCancel.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 16)
    }

    @IBAction func actionEdit(_ sender: Any) {
      
        self.dismiss(animated: true) {
            if let morePopupBlock = self.morePopupBlock {
                morePopupBlock(0)
            }
        }
    }
    
    @IBAction func actionPlaylist(_ sender: Any) {
       
    }
    
    @IBAction func actionShare(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if let morePopupBlock = self.morePopupBlock {
                morePopupBlock(2)
            }
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
