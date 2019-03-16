import UIKit
import AVOSCloud
import AVOSCloudIM

var guestArray = [AVUser]()

class GuestVC: UIViewController {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postNum: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerNum: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏中的title
        self.navigationItem.title = guestArray.last?.username
        
        //导航栏按钮
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        //let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        let moreButton = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(more))
        self.navigationItem.rightBarButtonItem = moreButton
        
        //右滑返回
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back))
        backSwipe.direction = .right
        self.view.addGestureRecognizer(backSwipe)
        
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
        
        // TODO: 页面修饰
        self.navigationItem.title = AVUser.current()?.username
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        messageButton.backgroundColor = appDelegateSource.hexStringToUIColor(hex: "fdb44b")
        //        nicknameLabel.backgroundColor = .red
        //        likeNum.backgroundColor = .red
        //        likeLabel.backgroundColor = .green
        //        postNum.backgroundColor = .red
        //        postLabel.backgroundColor = .green
        //        followingNum.backgroundColor = .red
        //        followingLabel.backgroundColor = .green
        //        followerNum.backgroundColor = .red
        //        followerLabel.backgroundColor = .green
        //        bioLabel.backgroundColor = .red
        
        alignment()
        getInfo()
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 获取信息
    /////////////////////////////////////////////////////////////////////////////////
    func getInfo() {
        let infoQuery = AVQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestArray.last!.username!)            //注意：这里有改动last?.username
        infoQuery.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            if error == nil {
                
                //判断用户是否有数据, 处理不存在的用户
                guard let objects = objects, objects.count > 0 else {
                    let alert = UIAlertController(title: "\(guestArray.last?.username ?? "错误！")", message: "该用户不存在或已经被删除！", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                //找到用户相关信息
                for object in objects {
                    self.nicknameLabel.text = (object as AnyObject).object(forKey: "nickname") as? String
                    self.bioLabel.text = (object as AnyObject).object(forKey: "bio") as? String
                    self.bioLabel.sizeToFit()
                    
                    self.avaImage.layer.cornerRadius = self.avaImage.frame.width / 2
                    self.avaImage.clipsToBounds = true //减掉多余的部分
                    
                    let avaImageQuery = (object as AnyObject).object(forKey: "avaImage") as? AVFile
                    avaImageQuery?.getDataInBackground({ (data: Data?, error: Error?) in
                        if data == nil {
                            print(error?.localizedDescription as Any)
                        }
                        else {
                            self.avaImage.image = UIImage(data: data!)
                        }
                    })
                }
            }
            else {
                print("无法载入访客基本信息")
            }
        }
        
        //设置关注状态
        let query = AVUser.current()?.followeeQuery()
        query?.whereKey("user", equalTo: AVUser.current()!)
        query?.whereKey("followee", equalTo: guestArray.last!)
        query?.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                if count == 0 {
                    self.followButton.setTitle("关 注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "4A4A48")
                }
                else {
                    self.followButton.setTitle("已关注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "1D97C1")
                }
            }
        }
        
        //设置统计数据
        let postCount = AVQuery(className: "Posts")
        postCount.whereKey("username", equalTo: guestArray.last!.username!)   //注意：这里有改动last?.username
        postCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.postNum.text = String(count)
            }
        }
        
        let followersCount = AVQuery(className: "_Follower")
        followersCount.whereKey("user", equalTo: guestArray.last!)           //注意：这里有改动guestArray.last
        followersCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.followerNum.text = String(count)
            }
        }
        
        //查找Following个数
        let followingsCount = AVQuery(className: "_Followee")
        followingsCount.whereKey("user", equalTo: guestArray.last!)         //注意：这里有改动guestArray.last
        followingsCount.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                self.followingNum.text = String(count)
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
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        //followers.user = guestArray.last!.username!
        followers.show = "粉丝"
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 单击”关注“后调用
    /////////////////////////////////////////////////////////////////////////////////
    @objc func followingsTapAction() {
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        //followings.user = guestArray.last!.username!
        followings.show = "关注"
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 关注按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func followButtonPressed(_ sender: Any) {
        let title = followButton.title(for: .normal)
        
        //获取当前访客对象
        let user = guestArray.last
        
        if title == "关 注" {
            guard let user = user else {return}
            
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followButton.setTitle("已关注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "1D97C1")
                    
                    //发送关注通知到云端
//                    let newsObj = AVObject(className: "News")
//                    newsObj["by"] = AVUser.current()?.username
//                    newsObj["profileImage"] = AVUser.current()?.object(forKey: "profileImage") as! AVFile
//                    newsObj["to"] = guestArray.last?.username
//                    newsObj["owner"] = ""
//                    newsObj["postId"] = ""
//                    newsObj["type"] = "follow"
//                    newsObj["checked"] = "no"
//                    newsObj.saveEventually()
                }
                else {
                    print("无法关注对象")
                }
            })
        }
        else {
            guard let user = user else {return}
            
            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followButton.setTitle("关 注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "4A4A48")
                    
                    //删除关注通知
//                    let newsQuery = AVQuery(className: "News")
//                    newsQuery.whereKey("by", equalTo: AVUser.current()!.username!)
//                    newsQuery.whereKey("to", equalTo: guestArray.last!.username!)
//                    newsQuery.whereKey("type", equalTo: "follow")
//                    newsQuery.findObjectsInBackground({ (objects: [Any]?, error: Error?) in
//                        if error == nil {
//                            for object in objects! {
//                                (object as AnyObject).deleteEventually()
//                            }
//                        }
//                    })
                }
                else {
                    print("无法取消关注对象")
                }
            })
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 发送信息按钮
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func messageButtonPressed(_ sender: Any) {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 返回按钮
    /////////////////////////////////////////////////////////////////////////////////
    @objc func back() {
        //退回到之前的控制器
        self.navigationController?.popViewController(animated: true)
        
        //从guestArray中移除最后一个AVUser
        if !guestArray.isEmpty {
            guestArray.removeLast()
        }
    }
    
    @objc func more() {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
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
        followButton.frame = CGRect(x: 120, y: followerLabel.frame.origin.y + 15, width: subWidth * 3, height: 30)
        messageButton.frame = CGRect(x: width - subWidth * 3 - 15, y: followerLabel.frame.origin.y + 15, width: subWidth * 3, height: 30)
        bioLabel.frame = CGRect(x: 15, y: avaImage.frame.origin.y + 100, width: width - 30, height: 100)
        //bioLabel.frame.size.width = width - 30
        //containerView.frame.size.width = width
        
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[avaImage]-10-[bioLabel]-10-[containerView]-0-|", options: [], metrics: nil, views: ["avaImage": avaImage, "bioLabel": bioLabel, "containerView": containerView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bioLabel]-15-|", options: [], metrics: nil, views: ["bioLabel": bioLabel]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[containerView]-0-|", options: [], metrics: nil, views: ["containerView": containerView]))
    }
}
