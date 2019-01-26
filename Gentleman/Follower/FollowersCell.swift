import UIKit
import AVOSCloud
import AVOSCloudIM

class FollowersCell: UITableViewCell {

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: AVUser!
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 视图初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: 页面修饰
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        followButton.layer.cornerRadius = followButton.frame.height / 6
        
        // TODO: 页面布局
        avaImage.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[ava(60)]-10-|", options: [], metrics: nil, views: ["ava": avaImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[username(35)]-0-[nickname(20)]-15-|", options: [], metrics: nil, views: ["username": usernameLabel, "nickname": nicknameLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[follow(30)]-25-|", options: [], metrics: nil, views: ["follow": followButton]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ava(60)]-5-[username]-5-[follow(50)]-10-|", options: [], metrics: nil, views: ["ava": avaImage, "username": usernameLabel, "follow": followButton]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ava(60)]-5-[nickname]-5-[follow(50)]-10-|", options: [], metrics: nil, views: ["ava": avaImage, "nickname": nicknameLabel, "follow": followButton]))
        
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: 添加关注与取消关注
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func followButtonPressed(_ sender: UIButton) {
        let title = followButton.title(for: .normal)
        
        if title == "关 注" {
            guard user != nil else {return}
            
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followButton.setTitle("已关注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "1D97C1")
                    
                    //发送notification
//                    let newsObj = AVObject(className: "News")
//                    newsObj["by"] = AVUser.current()?.username
//                    newsObj["profileImage"] = AVUser.current()?.object(forKey: "profileImage") as! AVFile
//                    newsObj["to"] = self.usernameLabel.text
//                    newsObj["owner"] = ""
//                    newsObj["postId"] = ""
//                    newsObj["type"] = "follow"
//                    newsObj["checked"] = "no"
//                    newsObj.saveEventually()
                }
                else {
                    print(error?.localizedDescription ?? "无法更改关注状态！")
                }
            })
        }
        else {
            guard user != nil else {return}
            
            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                if success {
                    self.followButton.setTitle("关 注", for: .normal)
                    self.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "4A4A48")
                    
                    //删除notification
//                    let newsQuery = AVQuery(className: "News")
//                    newsQuery.whereKey("by", equalTo: AVUser.current()!.username!)
//                    newsQuery.whereKey("to", equalTo: self.usernameLabel.text!)
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
                    print(error?.localizedDescription ?? "无法更改关注状态！")
                }
            })
        }
    }
}
