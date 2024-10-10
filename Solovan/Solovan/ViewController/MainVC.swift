import UIKit
import MobileCoreServices
import AVFoundation
import GoogleMobileAds

class MainVC: BaseVC {

    @IBOutlet weak var constrantLeadingStack: NSLayoutConstraint!
    @IBOutlet weak var constrantTrailingStack: NSLayoutConstraint!
    @IBOutlet weak var fsPageControl: FSPageControl!
    @IBOutlet weak var fsPagerView: FSPagerView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var bannerBound: UIView!
    
    var bannerView: GADBannerView?
    
    var isFilter = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.setFontSize(size: 24)
        if(isPad()) {
            constrantLeadingStack.constant = 100
            constrantTrailingStack.constant = 100
        }
        setupList()
        loadBannerAdmod()
    }
    
    func loadBannerAdmod(){
        bannerView = GADBannerView(adSize: GADPortraitInlineAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width))
        bannerView?.adUnitID = "ca-app-pub-8704589597859780/6216928795"
        bannerView?.rootViewController = self
        bannerView?.delegate = self
        bannerBound.addSubview(bannerView!)
        bannerView?.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        bannerView?.load(GADRequest())
    }
    
    func adDidReceive(_ height: CGFloat) {
        for constraint in self.bannerBound.constraints {
            if constraint.identifier == "heightConstraint" {
               constraint.constant = height
            }
        }
        bannerBound.layoutIfNeeded()
    }

    func setupList() {
        fsPagerView.delegate = self
        fsPagerView.dataSource = self
        fsPagerView.transformer = FSPagerViewTransformer(type: .linear)
        fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        fsPagerView.itemSize = CGSize(width: fsPagerView.frame.width - 100, height: fsPagerView.frame.height-80)
        fsPagerView.interitemSpacing = 25
        fsPagerView.isInfinite = true
    }
    
    @IBAction func actionSetting(_ sender: Any) {
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionNoteMovie(_ sender: Any) {
        let vc = MyMovieVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMyVideoEdit(_ sender: Any) {
        let vc = MyVideoAIVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionEditVideo(_ sender: Any) {
        // chon video
        isFilter = false
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "From Gallery", style: .default, handler: { action in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeMovie as String] // Chỉ lấy video
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "From App", style: .default, handler: { action in
            let vc = VideoSelectPopupVC()
            vc.videoSelectBlock = { saveVideoModel in
                if let videoURL = saveVideoModel.url {
                    if(self.isFilter) {
                        let filterVC = FilterVideoVC()
                        filterVC.videourl = videoURL
                        self.navigationController?.pushViewController(filterVC, animated: true)
                    }else {
                        let asset = AVAsset(url: videoURL)
                        let vc = EditVideoVC()
                        vc.asset = asset
                        vc.videourl = videoURL
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            self.present(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func actionMovieSlider(_ sender: Any) {
        // chon video
        isFilter = true
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "From Gallery", style: .default, handler: { action in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeMovie as String] // Chỉ lấy video
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "From App", style: .default, handler: { action in
            let vc = VideoSelectPopupVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.videoSelectBlock = { saveVideoModel in
                if let videoURL = saveVideoModel.url {
                    if(self.isFilter) {
                        let filterVC = FilterVideoVC()
                        filterVC.videourl = videoURL
                        self.navigationController?.pushViewController(filterVC, animated: true)
                    }else {
                        let asset = AVAsset(url: videoURL)
                        let vc = EditVideoVC()
                        vc.asset = asset
                        vc.videourl = videoURL
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            self.present(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func actionMyAi(_ sender: Any) {
        let vc = MyVideoAIVC()
        vc.isAI = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainVC :FSPagerViewDataSource,FSPagerViewDelegate{
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        // Kiểm tra xem đã có iconView trong contentView hay chưa
        var iconView: AiView!
        if let existingIconView = cell.contentView.subviews.first(where: { $0 is AiView }) as? AiView {
            iconView = existingIconView
        } else {
            // Nếu chưa có thì tạo mới
            iconView = AiView(frame: CGRect(x: 0, y: 0, width: fsPagerView.frame.width - 100, height: fsPagerView.frame.height - 80))
            cell.contentView.addSubview(iconView)
        }
        if(index == 0) {
            iconView.iv.image = UIImage(named: "banner_gallery")
            iconView.lbTitle.text = "Video AI"
            iconView.lbContent.text = "Create AI videos with your creativity"
        }else if(index == 1) {
            iconView.iv.image = UIImage(named: "banner_thedb")
            iconView.lbTitle.text = "Video AI"
            iconView.lbContent.text = "Create video with AI with popular movies on themovie.db"
        }
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if(index == 0) {
            let vc = CreateVideoAI()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(index == 1) {
            // themoviedb
            let vc = MovieVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
      
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        
    }
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                if(isFilter) {
                    let filterVC = FilterVideoVC()
                    filterVC.videourl = videoURL
                    self.navigationController?.pushViewController(filterVC, animated: true)
                }else {
                    let asset = AVAsset(url: videoURL)
                    let vc = EditVideoVC()
                    vc.asset = asset
                    vc.videourl = videoURL
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}

extension MainVC: GADBannerViewDelegate {
    //for banner
    /// Tells the delegate an ad request loaded an ad.
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        if bannerBound != nil{
            bannerBound.isHidden = false
            adDidReceive(bannerView.frame.size.height)
        }
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        if bannerBound != nil{
            bannerBound.isHidden = true
        }
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        if bannerBound != nil{
            bannerBound.isHidden = true
        }
        loadBannerAdmod()
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
}
