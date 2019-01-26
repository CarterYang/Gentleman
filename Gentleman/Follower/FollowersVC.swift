import UIKit
import AVOSCloud
import AVOSCloudIM

class FollowersVC: UITableViewController {
    
    //var user = String()
    var show = String()
    var followArray = [AVUser]()
    let appDelegateSource = UIApplication.shared.delegate as! AppDelegate

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: 相关设置
        self.navigationItem.title = show
        
        if show == "Followers" {
            loadFollowers()
        }
        else if show == "Followings"{
            loadFollowings()
        }
        else {
            return
        }
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 设定Table
    /////////////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followArray.count
    }
    
    override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell", for: indexPath) as! FollowersCell
        
        //关注信息
        cell.usernameLabel.text = followArray[indexPath.row].username
        cell.nicknameLabel.text = followArray[indexPath.row].object(forKey: "nickname") as? String
        let profileImage = followArray[indexPath.row].object(forKey: "profileImage") as! AVFile
        profileImage.getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.avaImage.image = UIImage(data: data!)
            }
            else {
                print("下载头像出错！")
            }
        }
        
        //关注状态
        let query = followArray[indexPath.row].followeeQuery()
        query.whereKey("user", equalTo: AVUser.current()!)
        query.whereKey("followee", equalTo: followArray[indexPath.row])
        query.countObjectsInBackground { (count: Int, error: Error?) in
            if error == nil {
                if count == 0 {
                    cell.followButton.setTitle("关 注", for: .normal)
                    cell.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "4A4A48")
                }
                else {
                    cell.followButton.setTitle("已关注", for: .normal)
                    cell.followButton.backgroundColor = self.appDelegateSource.hexStringToUIColor(hex: "1D97C1")
                }
            }
        }
        //将关注对象传递给FollowCell
        cell.user = followArray[indexPath.row]

        if cell.usernameLabel.text == AVUser.current()?.username {
            cell.followButton.isHidden = true
        }
        
        return cell
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 载入Followers信息
    /////////////////////////////////////////////////////////////////////////////////
    func loadFollowers() {
        guestArray.last?.getFollowers({ (followers: [Any]?, error: Error?) in
            if error == nil && followers != nil {
                self.followArray = followers! as! [AVUser]
                self.tableView.reloadData()
            }
            else {
                print("无法载入关注者信息！")
            }
        })
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 载入Followings信息
    /////////////////////////////////////////////////////////////////////////////////
    func loadFollowings() {
        guestArray.last?.getFollowers({ (followers: [Any]?, error: Error?) in
            if error == nil && followers != nil {
                self.followArray = followers! as! [AVUser]
                self.tableView.reloadData()
            }
            else {
                print("无法载入关注者信息！")
            }
        })
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 当选中对象时
    /////////////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
        
        if cell.usernameLabel.text == AVUser.current()?.username {
            let home = storyboard?.instantiateViewController(withIdentifier: "PersonalVC") as! HomeViewController
            self.navigationController?.pushViewController(home, animated: true)
        }
        else {
            guestArray.append(followArray[indexPath.row])
            let guest = storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }

}
