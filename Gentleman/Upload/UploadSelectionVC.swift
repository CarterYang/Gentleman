import UIKit

class UploadSelectionVC: UIViewController {

    @IBOutlet weak var picImage: UIImageView!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var instructionImage: UIImageView!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: 页面修饰
        self.view.backgroundColor = UIColor.lightGray
        self.preferredContentSize.width = 130
        self.preferredContentSize.height = 170
        self.view.layer.cornerRadius = 15
        picButton.layer.cornerRadius = 5
        picButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        videoButton.layer.cornerRadius = 5
        videoButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        instructionButton.layer.cornerRadius = 5
        instructionButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        infoButton.layer.cornerRadius = 5
        infoButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        
        alignment()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func picButtonPressed(_ sender: Any) {
        //self.presentingViewController!.dismiss(animated: true, completion: nil)
        //self.presentedViewController!.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let goTo = storyboard.instantiateViewController(withIdentifier: "UploadVideoVC")
//        self.present(goTo, animated: true, completion: nil)
    }
    
    @IBAction func instructionButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let goTo = storyboard.instantiateViewController(withIdentifier: "UploadInstructionVC")
//        self.present(goTo, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let goTo = storyboard.instantiateViewController(withIdentifier: "UploadInfoVC")
//        self.present(goTo, animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
        picImage.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        picButton.frame = CGRect(x: 50, y: 10, width: 70, height: 30)
        videoImage.frame = CGRect(x: 10, y: 50, width: 30, height: 30)
        videoButton.frame = CGRect(x: 50, y: 50, width: 70, height: 30)
        instructionImage.frame = CGRect(x: 10, y: 90, width: 30, height: 30)
        instructionButton.frame = CGRect(x: 50, y: 90, width: 70, height: 30)
        infoImage.frame = CGRect(x: 10, y: 130, width: 30, height: 30)
        infoButton.frame = CGRect(x: 50, y: 130, width: 70, height: 30)
    }
}
