import UIKit
import AVOSCloud
import AVOSCloudIM
import GrowingTextView
import SVProgressHUD

class SignupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var bioText: GrowingTextView!
    @IBOutlet weak var counter: TextCounterLabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    var keyboard : CGRect = CGRect()            //获取虚拟键盘的大小
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Notification设置
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // TODO: 添加Tap手势
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        keyboardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(keyboardTap)
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        imgTap.numberOfTapsRequired = 1
        avaImage.isUserInteractionEnabled = true
        avaImage.addGestureRecognizer(imgTap)
        
        // TODO: 页面修饰与布局        
        signupButton.layer.cornerRadius = signupButton.frame.height / 6
        signupButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 6
        cancelButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "4A4A48")
        bioText.layer.cornerRadius = bioText.frame.height / 20
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        
        bioText.placeholder = "自我介绍（60字以内）"
        bioText.maxLength = 60
        bioText.placeholderColor = UIColor.lightGray
        bioText.trimWhiteSpaceWhenEndEditing = true
        counter.textView = bioText
        counter.counterMode = .standard
        counter.counterMaxLength = 60
        counter.textColor = UIColor.lightGray
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        // 滚动视图
        scrollview.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollview.contentSize.height = height
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        avaImage.frame = CGRect(x: 15, y: 80, width: 80, height: 80)
        greetingLabel.frame = CGRect(x: 15, y: avaImage.frame.origin.y + 90, width: width - 30, height: 40)
        usernameText.frame = CGRect(x: 15, y: greetingLabel.frame.origin.y + 60, width: width - 30, height: 30)
        nicknameText.frame = CGRect(x: 15, y: usernameText.frame.origin.y + 40, width: width - 30, height: 30)
        emailText.frame = CGRect(x: 15, y: nicknameText.frame.origin.y + 40, width: width - 30, height: 30)
        passwordText.frame = CGRect(x: 15, y: emailText.frame.origin.y + 40, width: width - 30, height: 30)
        confirmPasswordText.frame = CGRect(x: 15, y: passwordText.frame.origin.y + 40, width: width - 30, height: 30)
        bioText.frame = CGRect(x: 15, y: confirmPasswordText.frame.origin.y + 40, width: width - 30, height: 120)
        counter.frame = CGRect(x: width - 70, y: bioText.frame.origin.y + 100, width: 45, height: 20)
        cancelButton.frame = CGRect(x: 15, y: bioText.frame.origin.y + 135, width: 150, height: 30)
        signupButton.frame = CGRect(x: width - 165, y: bioText.frame.origin.y + 135, width: 150, height: 30)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取头像
    /////////////////////////////////////////////////////////////////////////////////
    @objc func loadImage() {
        let chooseFromLibrary = UIAlertAction(title: "从手机相册选择", style: .default) { (UIAlertAction) in
            let pickerFromLibrary = UIImagePickerController()
            pickerFromLibrary.delegate = self
            pickerFromLibrary.sourceType = .photoLibrary
            pickerFromLibrary.allowsEditing = true
            self.present(pickerFromLibrary, animated: true, completion: nil)
        }
        let chooseFromCamera = UIAlertAction(title: "拍摄", style: .default) { (UIAlertAction) in
            let pickerFromCamera = UIImagePickerController()
            pickerFromCamera.delegate = self
            pickerFromCamera.sourceType = .camera
            pickerFromCamera.allowsEditing = true
            self.present(pickerFromCamera, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        menu.addAction(chooseFromLibrary)
        menu.addAction(chooseFromCamera)
        menu.addAction(cancel)
        
        present(menu, animated: true, completion: nil)
    }
    
    // TODO: 载入照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avaImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: 取消选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func signupButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        // TODO: 检查信息是否完整
        if usernameText.text!.isEmpty || nicknameText.text!.isEmpty || emailText.text!.isEmpty || passwordText.text!.isEmpty || confirmPasswordText.text!.isEmpty {
            alert(error: "注意", message: "信息不完整，请重新填写您的信息！")
            return
        }
        
        // TODO: 检查用户是否重复
        let usernameQuery = AVQuery(className: "_User")
        usernameQuery.whereKey("username", equalTo: usernameText.text!.uppercased())
        usernameQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                print("找到\(count)个相同的用户名")
                if count != 0 {
                    self.alert(error: "错误", message: "您输入的用户名已存在，请更换！")
                    return
                }
            }
            else {
                print("检查用户名是否重复发生错误！")
            }
        }
        
        let emailQuery = AVQuery(className: "_User")
        emailQuery.whereKey("email", equalTo: emailText.text!.lowercased())
        emailQuery.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                print("找到\(count)个相同的注册邮箱")
                if count != 0 {
                    self.alert(error: "错误", message: "邮箱已被注册，请更换！")
                    return
                }
            }
            else {
                print("检查邮箱是否重复发生错误！")
            }
        }
        
        // TODO: 检查手机号和邮箱
        if !validateEmail(email: emailText.text!) {
            alert(error: "电子邮箱错误", message: "请输入格式正确的电子邮箱！")
            return
        }
        
        // TODO: 检查密码是否一致
        if passwordText.text != confirmPasswordText.text {
            alert(error: "注意", message: "两次输入的密码不同，请重新输入！")
            return
        }
        
        // TODO: 创建服务器数据
        SVProgressHUD.show()
        
        let user = AVUser()
        user.username = usernameText.text?.uppercased()
        user["nickname"] = nicknameText.text
        user.email = emailText.text?.lowercased()
        user.password = confirmPasswordText.text
        user["bio"] = bioText.text
        
        let ava = UIImage.jpegData(avaImage.image!)(compressionQuality: 0.5)
        let avaFile = AVFile(name: "avaImage.jpg", data: ava!)
        user["avaImage"] = avaFile
        
        // TODO: 上传数据
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("用户注册成功！")
                SVProgressHUD.dismiss()
                //注册成功返回
                let alert = UIAlertController(title: "注册成功", message: "验证信息已发送至您的邮箱，请先通过验证！", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                print("注册发送错误！")
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 关闭Sign up页面
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancelButtonPressed(_ sender: Any) {
        hideKeyboardTap()
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: Notification方法
    /////////////////////////////////////////////////////////////////////////////////
    // TODO: 显示键盘
    @objc func showKeyboard(notification: Notification) {
        //定义keyboard大小
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        keyboard = keyboardFrame.cgRectValue

        //当虚拟键盘出现以后，以动画的形式将”scroll view 的实际高度“缩小为”屏幕高度“ - “键盘高度”
        UIView.animate(withDuration: 0.4) {
            self.scrollview.frame.size.height = self.view.frame.height - self.keyboard.size.height
        }
    }
    
    // TODO: 隐藏键盘
    @objc func hideKeyboard(notification: Notification) {
        //当虚拟键盘消失后，将”scroll view 的实际高度“ = ”屏幕高度“
        UIView.animate(withDuration: 0.4) {
            self.scrollview.frame.size.height = self.view.frame.height
        }
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
