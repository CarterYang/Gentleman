import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //导航栏中title的颜色
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        //导航栏中的按钮颜色
        self.navigationBar.tintColor = UIColor.black
        //导航栏的背景色
        self.navigationBar.barTintColor = UIColor.white
        //不允许透明
        self.navigationBar.isTranslucent = false
        //设置状态栏风格，lightContent与导航栏目前文字风格一致
        var preferredStatusBarStyle: UIStatusBarStyle{
            return .lightContent
        }
    }
}
