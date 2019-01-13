import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AVOSCloud.setApplicationId("WsistOYipMEkdYH5iaDqxTTo-gzGzoHsz", clientKey: "9jgGV17SjJDIPD5VmCgL9xMr")
        
        //跟踪应用打开情况
        //AVAnalytics.trackAppOpened(launchOptions: launchOptions)

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


}

