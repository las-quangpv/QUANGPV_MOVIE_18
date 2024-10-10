import UIKit

class CommunityVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnJoinTelegram(_ sender: Any) {
        let link: String? = DataCommonModel.shared.extraFind("telegram_group")
        if link != nil && link != "" {
            UIApplication.shared.open(URL(string: link!)!, options: [:], completionHandler: nil)
        }
        self.remove()
    }
    
    @IBAction func btnJoinTelegramChannel(_ sender: Any) {
        let link: String? = DataCommonModel.shared.extraFind("telegram_channel")
        if link != nil && link != "" {
            UIApplication.shared.open(URL(string: link!)!, options: [:], completionHandler: nil)
        }
        self.remove()
    }
    
    @IBAction func btnJoinDiscord(_ sender: Any) {
        let link: String? = DataCommonModel.shared.extraFind("discord_group")
        if link != nil && link != "" {
            UIApplication.shared.open(URL(string: link!)!, options: [:], completionHandler: nil)
        }
        self.remove()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
