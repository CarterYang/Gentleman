import UIKit

class TabbarVC: UITabBarController, UIPopoverPresentationControllerDelegate {

    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tabBar.tintColor = .white      //每个Item的文字颜色
        //self.tabBar.barTintColor = UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)      //标签栏的背景色
        self.tabBar.isTranslucent = false
        
    }
}
