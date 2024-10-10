import UIKit
import WebKit

class PlayTrailerVC: BVC, WKNavigationDelegate{

    var movie: Movie?
    var tele: TvShow?
    
    var key: String?
    
    // MARK: - outlets
    @IBOutlet weak var playYoutubeView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playYoutubeView.navigationDelegate = self
        loadYoutube(key: key)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func loadYoutube(key: String?) {
        
        guard let key = key else {
            return
        }
        guard let url = URL(string: "https://youtube.com/embed/\(key)") else { return  }
        
        let requestObj = URLRequest(url: url)
        playYoutubeView.load(requestObj)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            
            if html != nil {
                if "\(html!)".contains("UNPLAYABLE") {
                    let alert = UIAlertController(title: "Notification", message: "The trailer does not exists", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    if self.movie != nil {
                        let video = VideoTrailer(id: self.movie!.id, key: self.key!, type: BookmarkType.movieNotAvaiable.rawValue)
                        BookmarkService.shared.addBookmark(data: video, type: .movieNotAvaiable)
                    } else {
                        let video = VideoTrailer(id: self.movie!.id, key: self.key!, type: BookmarkType.tvShowNotAvaiable.rawValue)
                        BookmarkService.shared.addBookmark(data: video, type: .tvShowNotAvaiable)
                    }
                }
            }
        })
    }
    
}
