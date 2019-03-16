import UIKit
import GrowingTextView
import AVOSCloud
import AVOSCloudIM
import LocationPickerViewController

class UploadPicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var titleText: GrowingTextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: 添加手势
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        keyboardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(keyboardTap)
        
        let chooseLocationTap = UITapGestureRecognizer(target: self, action: #selector(chooseLocation))
        chooseLocationTap.numberOfTapsRequired = 1
        self.locationTextfield.isUserInteractionEnabled = true
        self.locationTextfield.addGestureRecognizer(chooseLocationTap)
        
        // TODO: 页面修饰
        titleText.placeholder = "添加信息..."
        titleText.placeholderColor = UIColor.lightGray
        titleText.trimWhiteSpaceWhenEndEditing = true
        chooseButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        confirmButton.isEnabled = false
        
        alignment()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 选择照片
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func chooseButtonPressed(_ sender: Any) {
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
        postImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        confirmButton.isEnabled = true
        
        //实现第二次单击放大图片
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomPicture))
        zoomTap.numberOfTapsRequired = 1
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(zoomTap)
    }
    
    // TODO: 取消选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 放大或缩小图片
    /////////////////////////////////////////////////////////////////////////////////
    @objc func zoomPicture() {
        //放大后的Image View的位置
        let scale = postImage.image!.size.width / postImage.image!.size.height
        let frameWidth = self.view.frame.width
        let frameHeight = frameWidth / scale
        let zoomed = CGRect(x: 0, y: self.view.center.y - frameHeight / 2, width: frameWidth, height: frameHeight)
        
        //Image View还原到初始位置
        let navHeight = self.navigationController!.navigationBar.frame.height
        let unzoomed = CGRect(x: 10, y: navHeight + 10, width: 80, height: 80)
        
        //判断放大状态
        if postImage.frame == unzoomed {
            self.navigationController?.navigationBar.alpha = 0
            self.chooseButton.alpha = 0
            self.titleText.alpha = 0
            self.locationTextfield.alpha = 0
            self.locationImage.alpha = 0
            
            UIView.animate(withDuration: 0.4) {
                self.postImage.frame = zoomed
                self.view.backgroundColor = UIColor.black
            }
        }
        else {
            UIView.animate(withDuration: 0.8) {
                self.navigationController?.navigationBar.alpha = 1
                self.chooseButton.alpha = 1
                self.titleText.alpha = 1
                self.locationTextfield.alpha = 1
                self.locationImage.alpha = 1
            }
            
            UIView.animate(withDuration: 0.4) {
                self.postImage.frame = unzoomed
                self.view.backgroundColor = UIColor.white
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 跳转标记地点页面
    /////////////////////////////////////////////////////////////////////////////////
    @objc func chooseLocation() {
        let customLocationPicker = CustomLocationPicker()
        customLocationPicker.isAllowArbitraryLocation = true
        customLocationPicker.viewController = self
        let navigationController = UINavigationController(rootViewController: customLocationPicker)
        present(navigationController, animated: true, completion: nil)
    }
    
    func locationDidSelect(locationItem: LocationItem) {
        print("Select delegate method: " + locationItem.name)
    }
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem: locationItem)
    }
    
    func showLocation(locationItem: LocationItem) {
        locationTextfield.text = locationItem.name
        //locationTextfield.text = locationItem.formattedAddressString
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 隐藏虚拟键盘
    /////////////////////////////////////////////////////////////////////////////////
    @objc func hideKeyboardTap() {
        self.view.endEditing(true)
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 取消上传按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 确认上传按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func confirmButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        let object = AVObject(className: "Posts")
        object["username"] = AVUser.current()?.username
        object["avaImage"] = AVUser.current()?.value(forKey: "avaImage") as! AVFile
        let uuid = NSUUID().uuidString
        object["postId"] = "\(AVUser.current()!.username! ) \(uuid)"
        
        if titleText.text.isEmpty {
            object["title"] = ""
        }
        else {
            object["title"] = titleText.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)  //去掉两端的空格和换行
        }
        
        let pictureData = UIImage.jpegData(postImage.image!)(compressionQuality: 0.75)!
        let pictureFile = AVFile(name: "\(AVUser.current()!.username! )post.jpg", data: pictureData)
        object["media"] = pictureFile
        object["location"] = locationTextfield.text
        object["type"] = "照片"
        
        //发送Hashtag到云端
//        let newTitle = textField.text.replacingOccurrences(of: "#", with: " #")
//        let words: [String] = newTitle.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//        for var word in words {
//            let pattern = "#[^#]+"
//            let regular = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
//            let results = regular.matches(in: word, options: .reportProgress, range: NSMakeRange(0, word.count))
//
//            //输出截取结果
//            print("符合的结果有\(results.count)个")
//            for result in results {
//                word = (word as NSString).substring(with: result.range)
//            }
//
//            if word.hasPrefix("#") {
//                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)  //去除两端的标点
//                word = word.trimmingCharacters(in: CharacterSet.symbols)                //去除两端的符号
//
//                let hashtagOBJ = AVObject(className: "Hashtags")
//                hashtagOBJ["to"] = "\(AVUser.current()!.username! ) \(uuid)"
//                hashtagOBJ["by"] = AVUser.current()?.username
//                hashtagOBJ["hashtag"] = word.lowercased()
//                hashtagOBJ["comment"] = textField.text
//                hashtagOBJ.saveInBackground { (success: Bool, error: Error?) in
//                    if success {
//                        print("hashtag \(word) 创建成功")
//                    }
//                    else {
//                        print(error?.localizedDescription ?? "无法创建hashtag")
//                    }
//                }
//            }
//        }
        
        //上传数据到服务器
        object.saveInBackground { (success: Bool, error: Error?) in
            if error == nil {
                //发送上传通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                //将TabBar控制器中索引值为0的自控制器显示在手机屏幕上(回到FeedVC)
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
//                self.tabBarController?.selectedIndex = 3
                self.viewDidLoad()
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
        let width = self.view.frame.width
        let navHeight = self.navigationController!.navigationBar.frame.height
                
        postImage.frame = CGRect(x: 10, y: navHeight + 10, width: 80, height: 80)
        titleText.frame = CGRect(x: 100, y: postImage.frame.origin.y, width: width - 110, height: 120)
        chooseButton.frame = CGRect(x: 10, y: postImage.frame.origin.y + 90, width: 80, height: 30)
        locationImage.frame = CGRect(x: 10, y: chooseButton.frame.origin.y + 40, width: 30, height: 30)
        locationTextfield.frame = CGRect(x: 50, y: chooseButton.frame.origin.y + 40, width: width - 60, height: 30)
    }
    
}
