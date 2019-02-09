import UIKit
import AVOSCloud
import AVOSCloudIM

class PersonalVC: UIViewController {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var postNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followerNum: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(setting))
        self.navigationItem.rightBarButtonItem = settingButton
        
        // TODO: 页面修饰
        self.navigationItem.title = AVUser.current()?.username
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        editButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "1D97C1")
        
        // TODO: 添加手势
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTapAction))
        postsTap.numberOfTapsRequired = 1
        postNum.isUserInteractionEnabled = true
        postNum.addGestureRecognizer(postsTap)
        
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTapAction))
        followingsTap.numberOfTapsRequired = 1
        followingNum.isUserInteractionEnabled = true
        followingNum.addGestureRecognizer(followingsTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTapAction))
        followersTap.numberOfTapsRequired = 1
        followerNum.isUserInteractionEnabled = true
        followerNum.addGestureRecognizer(followersTap)
        
        alignment()
        getInfo()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 返回刷新页面
    /////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取信息
    /////////////////////////////////////////////////////////////////////////////////
    func getInfo() {
        let currentUser = AVUser.current()!
        
        //let avaquery = currentUser.object(forKey: "avaImage") as! AVFile
        let avaquery = AVUser.current()?.object(forKey: "avaImage") as! AVFile
        avaquery.getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                self.avaImage.image = UIImage(data: data!)
            }
            else {
                //print(error?.localizedDescription)
                print("下载头像出错-PersonalVC")
            }
        }
        
        nicknameLabel.text = currentUser.object(forKey: "nickname") as? String
        bioLabel.text = currentUser.object(forKey: "bio") as? String
        //bioLabel.sizeToFit() //调整试图大小为包裹所显示文字内容
        
        //查找Like个数
        let likeCount = AVQuery(className: "Likes")
        likeCount.whereKey("to", equalTo: currentUser.username!)
        likeCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.likeNum.text = String(count)
            }
            else {
                print("查找Like个数出错")
            }
        }
        
        //查找Post个数
        let postCount = AVQuery(className: "Posts")
        postCount.whereKey("username", equalTo: currentUser.username!)
        postCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.postNum.text = String(count)
            }
            else {
                print("查找Post个数出错")
            }
        }
        
        //查找Following个数
        let followingsCount = AVQuery(className: "_Followee")
        followingsCount.whereKey("user", equalTo: currentUser)
        followingsCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.followingNum.text = String(count)
            }
            else {
                print("查找Following个数出错")
            }
        }
        
        //查找Follower个数
        let followersCount = AVQuery(className: "_Follower")
        followersCount.whereKey("user", equalTo: currentUser)
        followersCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.followerNum.text = String(count)
            }
            else {
                print("查找Follower个数出错")
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 单击”帖子“后调用
    /////////////////////////////////////////////////////////////////////////////////
    @objc func postsTapAction() {
        
//        self.containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
 
        //如果PictureArray中有值的话讲视图滚动到第一个Section的第一个Item上
//        if !pictureArray.isEmpty {
//            let index = IndexPath(item: 0, section: 0)
//            self.collectionView.scrollToItem(at: index, at: UICollectionView.ScrollPosition.top, animated: true)
//        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 单击”粉丝“后调用
    /////////////////////////////////////////////////////////////////////////////////
    @objc func followersTapAction() {
        guestArray.append(AVUser.current()!)
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        //followers.user = AVUser.current()!.username!
        followers.show = "粉丝"
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 单击”关注“后调用
    /////////////////////////////////////////////////////////////////////////////////
    @objc func followingsTapAction() {
        guestArray.append(AVUser.current()!)
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        //followings.user = AVUser.current()!.username!
        followings.show = "关注"
        
        self.navigationController?.pushViewController(followings, animated: true)
    }

    
    @objc func setting() {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
        //        nicknameLabel.backgroundColor = .red
        //        likeNum.backgroundColor = .red
        //        likeLabel.backgroundColor = .green
        //        postNum.backgroundColor = .red
        //        postLabel.backgroundColor = .green
        //        followingNum.backgroundColor = .red
        //        followingLabel.backgroundColor = .green
        //        followerNum.backgroundColor = .red
        //        followerLabel.backgroundColor = .green
                bioLabel.backgroundColor = .red
        
        let width = self.view.frame.width
        avaImage.frame = CGRect(x: 15, y: 10, width: 90, height: 90)
        nicknameLabel.frame = CGRect(x: 120, y: 10, width: width - 125, height: 25)
        let subWidth = nicknameLabel.frame.width / 7
        let xGap = subWidth * 2
        likeNum.frame = CGRect(x: 120, y: nicknameLabel.frame.origin.y + 30, width: subWidth, height: 15)
        likeLabel.frame = CGRect(x: 120, y: likeNum.frame.origin.y + 15, width: subWidth, height: 15)
        postNum.frame = CGRect(x: likeNum.frame.origin.x + xGap, y: nicknameLabel.frame.origin.y + 30, width: subWidth, height: 15)
        postLabel.frame = CGRect(x: likeLabel.frame.origin.x + xGap, y: postNum.frame.origin.y + 15, width: subWidth, height: 15)
        followingNum.frame = CGRect(x: postNum.frame.origin.x + xGap, y: nicknameLabel.frame.origin.y + 30, width: subWidth, height: 15)
        followingLabel.frame = CGRect(x: postLabel.frame.origin.x + xGap, y: followingNum.frame.origin.y + 15, width: subWidth, height: 15)
        followerNum.frame = CGRect(x: followingNum.frame.origin.x + xGap, y: nicknameLabel.frame.origin.y + 30, width: subWidth, height: 15)
        followerLabel.frame = CGRect(x: followingLabel.frame.origin.x + xGap, y: followerNum.frame.origin.y + 15, width: subWidth, height: 15)
        editButton.frame = CGRect(x: 120, y: followerLabel.frame.origin.y + 15, width: width - 125, height: 30)
        bioLabel.frame = CGRect(x: 15, y: avaImage.frame.origin.y + 100, width: width - 30, height: 80)
        //bioLabel.frame.size.width = width - 30
        //containerView.frame.size.width = width
        
//        bioLabel.translatesAutoresizingMaskIntoConstraints = false
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[avaImage]-10-[bioLabel]-10-[containerView]-0-|", options: [], metrics: nil, views: ["avaImage": avaImage, "bioLabel": bioLabel, "containerView": containerView]))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bioLabel]-15-|", options: [], metrics: nil, views: ["bioLabel": bioLabel]))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[containerView]-0-|", options: [], metrics: nil, views: ["containerView": containerView]))
    }
}
