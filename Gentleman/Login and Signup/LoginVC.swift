import UIKit
import AVOSCloud
import AVOSCloudIM
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var gentlemanImage: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 添加Tap手势
        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideKeyboardTap)
        
        // TODO: 页面修饰
        loginButton.layer.cornerRadius = loginButton.frame.height / 6
        signupButton.layer.cornerRadius = signupButton.frame.height / 6
                
        // TODO: 页面布局
        let width = self.view.frame.width
        
        gentlemanImage.frame = CGRect(x: width / 2 - 90, y: 80, width: 180, height: 180)
        usernameText.frame = CGRect(x: 15, y: gentlemanImage.frame.origin.y + 200, width: width - 30, height: 30)
        passwordText.frame = CGRect(x: 15, y: usernameText.frame.origin.y + 40, width: width - 30, height: 30)
        forgetPasswordButton.frame = CGRect(x: width - 65, y: passwordText.frame.origin.y + 30, width: 50, height: 20)
        loginButton.frame = CGRect(x: 15, y: forgetPasswordButton.frame.origin.y + 30, width: 150, height: 30)
        signupButton.frame = CGRect(x: width - 165, y: forgetPasswordButton.frame.origin.y + 30, width: 150, height: 30)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 登录按钮功能
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func loginButtonPressed(_ sender: Any) {
        hideKeyboard()
        
        // TODO: 检查信息
        if usernameText.text!.isEmpty || passwordText.text!.isEmpty {
            alert(error: "错误", message: "请完整填写您的登录信息！")
            return
        }
        
        SVProgressHUD.show()
        
        // TODO: 用户登录
        AVUser.logInWithUsername(inBackground: usernameText.text!.uppercased(), password: passwordText.text!) { (user: AVUser?, error: Error?) in
            if error == nil {
                //记住用户
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()

                SVProgressHUD.dismiss()

                //从AppDelegate.swift中调用login方法，让用户直接进入主界面
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }
            else {
                SVProgressHUD.dismiss()
                print("登录发生错误！")
                
                let str = error!.localizedDescription as NSString
                if str == "Email address isn't verified." {
                    self.alert(error: "错误", message: "您还没有验证您的邮箱。为了您的账户安全，请先登录您的邮箱进行验证！")
                }
                else if str == "The username and password mismatch." {
                    self.alert(error: "错误", message: "密码填写错误！")
                }
                else if str == "Could not find user." {
                    self.alert(error: "错误", message: "用户不存在！")
                }
                else{
                    self.alert(error: "错误", message: "\(error!.localizedDescription)")
                }
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 隐藏虚拟键盘
    /////////////////////////////////////////////////////////////////////////////////
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 警告消息
    /////////////////////////////////////////////////////////////////////////////////
    func alert(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
