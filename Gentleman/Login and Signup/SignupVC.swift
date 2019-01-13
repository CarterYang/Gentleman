import UIKit
import AVOSCloud
import AVOSCloudIM

class SignupVC: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var cellphoneText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var sexText: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var scrollViewHeight : CGFloat = 0          //根据需要，设置滚动视图的高度
    var keyboard : CGRect = CGRect()            //获取虚拟键盘的大小
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 滚动视图调整
        scrollview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollview.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height

        // TODO: 添加Tap手势
        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideKeyboardTap)
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        imgTap.numberOfTapsRequired = 1
        avaImage.isUserInteractionEnabled = true
        avaImage.addGestureRecognizer(imgTap)
        
        // TODO: 页面修饰
        signupButton.layer.cornerRadius = signupButton.frame.height / 6
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 6
        
        // TODO: 页面布局

    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取照片作为profile image
    /////////////////////////////////////////////////////////////////////////////////
    @objc func loadImage() {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击确认Sign up按钮
    /////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 检查Email有效性
    /////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 检查PhoneNumber有效性
    /////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 虚拟键盘出现消失时对Scroll view的操作
    /////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 隐藏虚拟键盘
    /////////////////////////////////////////////////////////////////////////////////
    @objc func hideKeyboard() {
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
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 关闭Sign up页面
    /////////////////////////////////////////////////////////////////////////////////
}
