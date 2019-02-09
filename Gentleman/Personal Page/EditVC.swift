import UIKit
import AVOSCloud
import AVOSCloudIM
import GrowingTextView
import SVProgressHUD

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var toolbar: UIToolbar!
    
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
    @IBOutlet weak var cellphoneLabel: UILabel!
    @IBOutlet weak var cellphoneTextfield: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextfield: UITextField!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    var sexPicker = UIPickerView()
    let sex = ["", "男", "女"]
    var keyboard = CGRect()
    
    var birthdayPicker = UIDatePicker()
    
    
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
        //sexPicker.backgroundColor = UIColor.groupTableViewBackground
        sexPicker.backgroundColor = UIColor.lightGray
        sexPicker.showsSelectionIndicator = true
        sexTextfield.inputView = sexPicker
        sexTextfield.inputAccessoryView = toolbar
        
        birthdayPicker.datePickerMode = .date
        birthdayPicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        birthdayPicker.backgroundColor = UIColor.lightGray
        birthdayPicker.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
        birthTextfield.inputView = birthdayPicker
        birthTextfield.inputAccessoryView = toolbar
        
        // TODO: 页面修饰
        navigationItem.title = "编辑资料"
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        bioTextfield.maxLength = 60
        bioTextfield.layer.borderColor = UIColor.lightGray.cgColor
        bioTextfield.layer.borderWidth = 0.2
        bioTextfield.layer.cornerRadius = 5
        bioTextfield.trimWhiteSpaceWhenEndEditing = true
        counter.textView = bioTextfield
        counter.counterMode = .standard
        counter.counterMaxLength = 60
        counter.textColor = .lightGray
        sectionLabel.textColor = .lightGray
        
        alignment()
        getInfo()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取用户当前信息方法
    /////////////////////////////////////////////////////////////////////////////////
    func getInfo() {
        let currentUser = AVUser.current()!
        greetingLabel.text = "\(currentUser.username ?? "") 您好！"
        usernameText.text = currentUser.username
        nicknameTextfield.text = currentUser.object(forKey: "nickname") as? String
        emailTextfield.text = currentUser.email
        bioTextfield.text = currentUser.object(forKey: "bio") as? String
        sexTextfield.text = currentUser.object(forKey: "sex") as? String
        birthTextfield.text = currentUser.object(forKey: "birthday") as? String
        
        
        let avaQuery = currentUser.object(forKey: "avaImage") as? AVFile
        avaQuery?.getDataInBackground({ (data: Data?, error: Error?) in
            if data == nil {
                print("下载头像出错-EditVC")
            }
            else {
                self.avaImage.image = UIImage(data: data!)
            }
        })
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 选择头像
    /////////////////////////////////////////////////////////////////////////////////
    @objc func loadAva() {
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
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        menu.addAction(chooseFromLibrary)
        menu.addAction(chooseFromCamera)
        menu.addAction(cancel)
        
        present(menu, animated: true, completion: nil)
    }
    
    // TODO: 载入照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //发送头像数据到服务器
        let user = AVUser.current()
        let avaImageData = UIImage.jpegData(selectedImage!)(compressionQuality: 0.5)!
        let avaImageFile = AVFile(name: "ava.jpg", data: avaImageData)
        user?["avaImage"] = avaImageFile
        
        user?.saveInBackground({ (success: Bool, error: Error!) in
            if success {
                self.view.endEditing(true)
                //self.dismiss(animated: true, completion: nil)
            }
            else {
                print("修改头像出错！")
            }
        })
        
        avaImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: 取消选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
        let user = AVUser.current()
        
        if nicknameTextfield.text!.isEmpty {
            alert(error: "昵称不能为空", message: "请输入您的昵称！")
            return
        }
        else {
            user?["nickname"] = nicknameTextfield.text
        }
        
        if emailTextfield.text!.isEmpty {
            alert(error: "电子邮箱不能为空", message: "请输入您的电子邮箱地址！")
            return
        }
        else if !validateEmail(email: emailTextfield.text!) {
            alert(error: "Email格式错误", message: "请输入正确的电子邮箱地址！")
            return
        }
        else {
            user?.email = emailTextfield.text?.lowercased()
        }
        
        user?["bio"] = bioTextfield.text
        user?["sex"] = sexTextfield.text
        user?["birthday"] = birthTextfield.text
        
        if !cellphoneTextfield.text!.isEmpty {
            if !validatePhone(phone: cellphoneTextfield.text!) {
                alert(error: "手机号格式错误", message: "请输入正确的手机号！")
                return
            }
            else {
                user?["cellphone"] = cellphoneTextfield.text
            }
        }
        
        user?["address"] = addressTextfield.text
        
        //发送头像数据到服务器
//        let avaImageData = UIImage.jpegData(avaImage.image!)(compressionQuality: 0.5)!
//        let avaImageFile = AVFile(name: "avaImage.jpg", data: avaImageData)
//        user?["avaImage"] = avaImageFile

        user?.saveInBackground({ (success: Bool, error: Error!) in
            if success {
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("保存资料出错！")
            }
        })
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
    // MARK: 日期选择器
    /////////////////////////////////////////////////////////////////////////////////
    @objc func dateChanged(datePicker:UIDatePicker)
    {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let selectedDate = birthdayPicker.date
        let time = format.string(from: selectedDate)
        
        birthTextfield.text = time
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
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
        let height = self.view.frame.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.contentSize.height = height

        avaImage.frame = CGRect(x: 15, y: 15, width: 80, height: 80)
        greetingLabel.frame = CGRect(x: 15, y: avaImage.frame.origin.y + 90, width: width - 30, height: 30)
        usernameLabel.frame = CGRect(x: 15, y: greetingLabel.frame.origin.y + 40, width: 70, height: 30)
        nicknameLabel.frame = CGRect(x: 15, y: usernameLabel.frame.origin.y + 40, width: 70, height: 30)
        emailLabel.frame = CGRect(x: 15, y: nicknameLabel.frame.origin.y + 40, width: 70, height: 30)
        bioLabel.frame = CGRect(x: 15, y: emailLabel.frame.origin.y + 40, width: 70, height: 30)
        sectionLabel.frame = CGRect(x: 15, y: bioLabel.frame.origin.y + 110, width: width - 30, height: 20)
        sexLabel.frame = CGRect(x: 15, y: sectionLabel.frame.origin.y + 30, width: 70, height: 30)
        birthLabel.frame = CGRect(x: 15, y: sexLabel.frame.origin.y + 40, width: 70, height: 30)
        cellphoneLabel.frame = CGRect(x: 15, y: birthLabel.frame.origin.y + 40, width: 70, height: 30)
        addressLabel.frame = CGRect(x: 15, y: cellphoneLabel.frame.origin.y + 40, width: 70, height: 30)
        
        usernameText.frame = CGRect(x: 90, y: greetingLabel.frame.origin.y + 40, width: width - 105, height: 30)
        nicknameTextfield.frame = CGRect(x: 90, y: usernameText.frame.origin.y + 40, width: width - 105, height: 30)
        emailTextfield.frame = CGRect(x: 90, y: nicknameTextfield.frame.origin.y + 40, width: width - 105, height: 30)
        bioTextfield.frame = CGRect(x: 90, y: emailTextfield.frame.origin.y + 40, width: width - 105, height: 100)
        sexTextfield.frame = CGRect(x: 90, y: sectionLabel.frame.origin.y + 30, width: width - 105, height: 30)
        birthTextfield.frame = CGRect(x: 90, y: sexTextfield.frame.origin.y + 40, width: width - 105, height: 30)
        cellphoneTextfield.frame = CGRect(x: 90, y: birthTextfield.frame.origin.y + 40, width: width - 105, height: 30)
        addressTextfield.frame = CGRect(x: 90, y: cellphoneTextfield.frame.origin.y + 40, width: width - 105, height: 30)
        
        counter.frame = CGRect(x: bioTextfield.frame.origin.x + (bioTextfield.frame.width - 45), y: bioTextfield.frame.origin.y + 80, width: 45, height: 20)
    }

}
