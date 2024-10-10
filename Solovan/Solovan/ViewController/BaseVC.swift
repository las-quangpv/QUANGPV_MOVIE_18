

import TTGSnackbar

class BaseVC: UIViewController {
    var loadingView: ProgressView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        loadingView = ProgressView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        loadingView.tag = 103
    }
    
    func showMessage(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .short)
        
        snackbar.show()
    }
    
    func showMessageLong(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .long)
        snackbar.backgroundColor = UIColor.systemBlue
        snackbar.show()
    }
 
    func showLoading() {
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        if let tag = self.view.viewWithTag(103) {
            tag.removeFromSuperview()
        }

    }
}
