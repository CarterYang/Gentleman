import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        //登出用户
        AVUser.logOut()
        
        //从UserDefaults中删除用户登录记录
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
        
        //将页面转到登录界面
        let logIn = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = logIn
    }

}
