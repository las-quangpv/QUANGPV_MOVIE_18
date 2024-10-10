import UIKit
import SideMenu

enum MenuItem: String {
    case movie, tvshow, people, category, myPlayList, rateapp, share, term
    
    func title() -> String {
        switch self {
        case .movie: return "Movies"
        case .tvshow: return "TV Shows"
        case .people: return "People"
        case .category: return "Category"
        case .myPlayList: return "My Playlist"
        case .rateapp: return "Rate app"
        case .share: return "Share With Friend"
        case .term: return "Term of Policy"
        }
    }
}

class MenuController: UIViewController {
    //MARK: -properties
    var menuItem: [MenuItem] = [.movie, .tvshow, .people, .category, .myPlayList, .rateapp, .share, .term]
    
    var selectTVShow: (() -> Void)?
    var selectPeople: (() -> Void)?
    var selectCategory: (() -> Void)?
    var selectPlaylist: (() -> Void)?
    
    //MARK: -outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0x6236FF)
        // Do any additional setup after loading the view.
        menuTableView.register(UINib(nibName: MenuCell.cellId, bundle: nil), forCellReuseIdentifier: MenuCell.cellId)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        //view.backgroundColor = UIColor(rgb: 0xD8D8D8)
    }
    
    @IBAction func closeHandler(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.cellId) as! MenuCell
        cell.menuItemText = menuItem[indexPath.row].title()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuItem[indexPath.row] {
        case .movie:
            self.dismiss(animated: true)
        case .tvshow:
            selectTVShow?()
            self.dismiss(animated: true)
        case .people:
            selectPeople?()
            self.dismiss(animated: true)
        case .category:
            selectCategory?()
            self.dismiss(animated: true)
        case .myPlayList:
            selectPlaylist?()
            self.dismiss(animated: true)
        case .rateapp:
            ApplicationHelper.shared.presentRateApp()
        case .share:
            let shareText = "Download now https://apps.apple.com/us/app/id\(AppInfor.id)";
            let textToShare = [shareText] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        case .term:
            UtilService.openURL(URL(string: AppInfor.privacy)!, controller: self)
        }
    }
}


