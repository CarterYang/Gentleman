import UIKit
import AVOSCloud
import AVOSCloudIM
import SVProgressHUD

class LoginVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UITextView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
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
        titleLabel.font = UIFont(name: "Pacifico", size: 40)
        instructionLabel.text = "请输入您的用户名和密码！\n 如果您刚完成注册，请先登录您的邮箱完成验证！"
        instructionLabel.isUserInteractionEnabled = false
        loginButton.layer.cornerRadius = loginButton.frame.height / 6
        loginButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
                
        // TODO: 页面布局
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        titleLabel.frame = CGRect(x: 15, y: 100, width: width - 30, height: 50)
        instructionLabel.frame = CGRect(x: 15, y: titleLabel.frame.origin.y + 100, width: width - 30, height: 40)
        accountLabel.frame = CGRect(x: 15, y: instructionLabel.frame.origin.y + 60, width: 50, height: 40)
        usernameText.frame = CGRect(x: 70, y: instructionLabel.frame.origin.y + 60, width: width - 85, height: 40)
        passwordLabel.frame = CGRect(x: 15, y: accountLabel.frame.origin.y + 50, width: 50, height: 40)
        passwordText.frame = CGRect(x: 70, y: usernameText.frame.origin.y + 50, width: width - 85, height: 40)
        loginButton.frame = CGRect(x: 15, y: passwordLabel.frame.origin.y + 60, width: width - 30, height: 40)
        forgetPassword.frame = CGRect(x: 15, y: loginButton.frame.origin.y + 50, width: 80, height: 20)
        signup.frame = CGRect(x: width - 95, y: loginButton.frame.origin.y + 50, width: 80, height: 20)
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
    // MARK: 修改密码Segue
    /////////////////////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popoverCtrl = segue.destination.popoverPresentationController
        
        if sender is UIButton {
            popoverCtrl?.sourceRect = (sender as! UIButton).bounds
        }
        
        popoverCtrl?.delegate = self
        popoverCtrl?.permittedArrowDirections = .down
        popoverCtrl?.backgroundColor = UIColor.white
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
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
    
}
