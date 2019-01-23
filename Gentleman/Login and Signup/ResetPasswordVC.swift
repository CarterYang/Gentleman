import UIKit
import AVOSCloud
import AVOSCloudIM

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // TODO: 添加Tap手势
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        keyboardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(keyboardTap)

        // TODO: 页面修饰与布局
        self.view.backgroundColor = UIColor.white
        self.preferredContentSize.width = UIScreen.main.bounds.width - 20
        self.preferredContentSize.height = 200
        self.view.layer.cornerRadius = 5
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 6
        confirmButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 6
        cancelButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "4A4A48")
        
        let width = self.preferredContentSize.width
        
        titleLabel.frame = CGRect(x: 15, y: 15, width: width - 30, height: 30)
        instructionLabel.frame = CGRect(x: 15, y: titleLabel.frame.origin.y + 35, width: width - 30, height: 30)
        emailTextField.frame = CGRect(x: 15, y: instructionLabel.frame.origin.y + 40, width: width - 30, height: 40)
        cancelButton.frame = CGRect(x: 15, y: emailTextField.frame.origin.y + 55, width: width / 2 - 50, height: 40)
        confirmButton.frame = CGRect(x: width / 2 + 35, y: emailTextField.frame.origin.y + 55, width: width / 2 - 50, height: 40)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 信息有效性
    /////////////////////////////////////////////////////////////////////////////////
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击确认按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func confirmButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        // TODO: 检查信息是否完整
        if emailTextField.text!.isEmpty {
            alert(error: "错误", message: "请填写您的电子邮箱地址！")
            return
        }
        
        // TODO: 检查邮箱
        if !validateEmail(email: emailTextField.text!) {
            alert(error: "电子邮箱错误", message: "请输入格式正确的电子邮箱！")
            return
        }
        
        // TODO: 重置密码
        AVUser.requestPasswordResetForEmail(inBackground: emailTextField.text!) { (success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "注意", message: "密码重设链接已发送至您的邮箱，请登录邮箱进行修改！", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                print("重设密码出错！")
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 关闭页面
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 隐藏虚拟键盘
    /////////////////////////////////////////////////////////////////////////////////
    @objc func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 警告消息方法
    /////////////////////////////////////////////////////////////////////////////////
    func alert (error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
