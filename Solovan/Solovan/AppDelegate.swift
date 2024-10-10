import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigationVC: UINavigationController?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        getIdAdses()
        ApplovinHandle.shared.awake {
            ApplovinOpenHandle.shared.awake()
        }
        setupVC()
        return true
    }


    func setupVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        navigationVC = UINavigationController(rootViewController: SplashVC())
        navigationVC?.isNavigationBarHidden = true
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
    
    private func getIdAdses() {
        NetworksService.shared.checkChangeTime()
        guard let url = URL(string: AppInfor.list_ads) else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let newData = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: newData, options: .mutableContainers) as? [String:Any] {
                for (key, value) in json {
                    UserDefaults.standard.set(value, forKey: key)
                    UserDefaults.standard.synchronize()
                }
                DBService.shared.saveTimeAdsesLatest()
            }
        }.resume()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if DataCommonModel.shared.openRatingView {
            AdmobOpenHandle.shared.tryToPresent { success in
                if !success {
                    ApplovinOpenHandle.shared.tryToPresent()
                }
            }
        }
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        guard rootViewController != nil else { return nil }
        
        guard !(rootViewController.isKind(of: (UITabBarController).self)) else{
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        }
        guard !(rootViewController.isKind(of:(UINavigationController).self)) else{
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        }
        guard !(rootViewController.presentedViewController != nil) else {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
}

