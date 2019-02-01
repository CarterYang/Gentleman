import UIKit
import AVOSCloud
import AVOSCloudIM
import GrowingTextView
import SVProgressHUD

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextfield: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var bioTextfield: GrowingTextView!
    @IBOutlet weak var counter: TextCounterLabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sexTextfield: UITextField!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthTextfield: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextfield: UITextField!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    var sexPicker = UIPickerView()
    let sex = ["男", "女"]
    var keyboard = CGRect()
    
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
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadAva))
        avaTap.numberOfTapsRequired = 1
        avaImage.isUserInteractionEnabled = true
        avaImage.addGestureRecognizer(avaTap)
        
        // TODO: UIPicker设定
        sexPicker.dataSource = self
        sexPicker.delegate = self
        sexPicker.backgroundColor = UIColor.groupTableViewBackground
        sexPicker.showsSelectionIndicator = true
        sexTextfield.inputView = sexPicker
        
        // TODO: 页面修饰
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        
        //bioTextfield.placeholder = "个性签名（60字以内）"
        bioTextfield.maxLength = 60
        bioTextfield.placeholderColor = UIColor.lightGray
        bioTextfield.trimWhiteSpaceWhenEndEditing = true
        counter.textView = bioTextfield
        counter.counterMode = .standard
        counter.counterMaxLength = 60
        counter.textColor = UIColor.lightGray
        
        alignment()
        getInfo()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取用户当前信息方法
    /////////////////////////////////////////////////////////////////////////////////
    func getInfo() {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 上传头像
    /////////////////////////////////////////////////////////////////////////////////
    @objc func loadAva() {
        
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: Picker设置
    /////////////////////////////////////////////////////////////////////////////////
    //设置Picker组件数量 (UIPickerViewDataSource)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //设置Picker选项数量 (UIPickerViewDataSource)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sex.count
    }
    
    //设置选项标题 (UIPickerViewDelegate)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sex[row]
    }
    
    //从Picker中得到用户选择的Item (UIPickerViewDelegate)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexTextfield.text = sex[row]
        self.view.endEditing(true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 保存
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePhone(phone: String) -> Bool {
        let phoneRegex = "0?(13|14|15|18)[0-9]{9}"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 取消
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancelButtonPressed(_ sender: Any) {
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
            self.scrollView.frame.size.height = self.view.frame.height - self.keyboard.size.height
        }
    }
    
    // TODO: 隐藏键盘
    @objc func hideKeyboard(notification: Notification) {
        //当虚拟键盘消失后，将”scroll view 的实际高度“ = ”屏幕高度“
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
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
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
        let width = self.view.frame.width
        avaImage.frame = CGRect(x: 15, y: 15, width: 80, height: 80)
        greetingLabel.frame = CGRect(x: 15, y: avaImage.frame.origin.y + 90, width: width - 30, height: 40)
        usernameLabel.frame = CGRect(x: 15, y: greetingLabel.frame.origin.y + 50, width: 120, height: 30)
        nicknameLabel.frame = CGRect(x: 15, y: usernameLabel.frame.origin.y + 40, width: 120, height: 30)
        emailLabel.frame = CGRect(x: 15, y: nicknameLabel.frame.origin.y + 40, width: 120, height: 30)
        bioLabel.frame = CGRect(x: 15, y: emailLabel.frame.origin.y + 40, width: 120, height: 30)
        sectionLabel.frame = CGRect(x: 15, y: bioLabel.frame.origin.y + 130, width: 120, height: 20)
        sexLabel.frame = CGRect(x: 15, y: sectionLabel.frame.origin.y + 30, width: width - 30, height: 30)
        birthLabel.frame = CGRect(x: 15, y: sexLabel.frame.origin.y + 40, width: width - 30, height: 30)
        addressLabel.frame = CGRect(x: 15, y: birthLabel.frame.origin.y + 40, width: width - 30, height: 30)
        
        usernameText.frame = CGRect(x: 140, y: greetingLabel.frame.origin.y + 40, width: width - 155, height: 30)
        nicknameTextfield.frame = CGRect(x: 140, y: usernameText.frame.origin.y + 40, width: width - 155, height: 30)
        emailTextfield.frame = CGRect(x: 140, y: nicknameTextfield.frame.origin.y + 40, width: width - 155, height: 30)
        bioTextfield.frame = CGRect(x: 140, y: emailTextfield.frame.origin.y + 40, width: width - 155, height: 120)
        sexTextfield.frame = CGRect(x: 140, y: sectionLabel.frame.origin.y + 30, width: width - 155, height: 30)
        birthTextfield.frame = CGRect(x: 140, y: sexTextfield.frame.origin.y + 40, width: width - 155, height: 30)
        addressTextfield.frame = CGRect(x: 140, y: birthTextfield.frame.origin.y + 40, width: width - 155, height: 30)
        
        counter.frame = CGRect(x: width - 60, y: bioTextfield.frame.origin.y + 100, width: 45, height: 20)
    }
}
