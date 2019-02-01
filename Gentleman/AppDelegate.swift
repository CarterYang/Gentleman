import UIKit
import AVOSCloud
import AVOSCloudIM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AVOSCloud.setApplicationId("WsistOYipMEkdYH5iaDqxTTo-gzGzoHsz", clientKey: "9jgGV17SjJDIPD5VmCgL9xMr")
        
        //跟踪应用打开情况
        //AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        window?.backgroundColor = hexStringToUIColor(hex: "#4A4A48")
        
        //如果有登录信息直接跳转页面
        login()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 登录云端
    /////////////////////////////////////////////////////////////////////////////////
    func login() {
        //获取UserDefaults中z储存的用户信息
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        //如果用户不是空的
        if username != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            window?.rootViewController = myTabBar
        }
        
//                AVUser.current()?.follow("5c4c88d444d904004d86f6d4") {(success: Bool, error: Error?) in
//                    if success {
//                        print("关注成功")
//                    }
//                    else {
//                        print("关注失败")
//                    }
//                }
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 十六进制颜色转化
    /////////////////////////////////////////////////////////////////////////////////
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

