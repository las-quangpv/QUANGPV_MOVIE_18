import UIKit
import GoogleMobileAds

class AdmobNativeAdView: GADNativeAdView {
    
    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var viewLbAds: CustomView!
    @IBOutlet weak var viewCallToAction: CustomView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var viewBgads: UIView!
    @IBOutlet weak var lbBody: UILabel!
    
    public override var nativeAd: GADNativeAd? {
        didSet {
            guard nativeAd != nil else { return }
            self.viewAds.isHidden = false
            self.viewBgads.isHidden = false
            (self.headlineView as? UILabel)?.text = nativeAd!.headline
            self.lbBody.text = nativeAd!.body
            self.mediaView?.mediaContent = nativeAd!.mediaContent
            if let mediaView = self.mediaView, nativeAd!.mediaContent.aspectRatio > 0 {
                self.mediaView?.isHidden = false
                self.iconView?.isHidden = true
            } else {
                self.iconView?.isHidden = false
                self.mediaView?.isHidden = true
                (self.iconView as? UIImageView)?.image = nativeAd!.icon?.image
                self.iconView?.layer.cornerRadius = 5
                self.iconView?.layer.masksToBounds = true
            }
            
            (self.callToActionView as? UIButton)?.setTitle(nativeAd!.callToAction, for: .normal)
            self.callToActionView?.isHidden = nativeAd!.callToAction == nil
            self.viewCallToAction?.isHidden = nativeAd!.callToAction == nil
            
            (self.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd!.starRating)
            self.starRatingView?.isHidden = nativeAd!.starRating == nil
            
            (self.advertiserView as? UILabel)?.text = nativeAd!.advertiser
            self.advertiserView?.isHidden = nativeAd!.advertiser == nil
            self.callToActionView?.isUserInteractionEnabled = false
            
            self.viewLbAds?.isHidden = false
            self.lblAds?.layer.cornerRadius = 0;
            self.lblAds?.layer.masksToBounds = true
            self.backgroundColor = UIColor.clear
        }
    }

    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
    
    public static var height: CGFloat {
        return 236
    }
}
