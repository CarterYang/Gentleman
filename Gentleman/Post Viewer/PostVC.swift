import UIKit
import AVOSCloud
import AVOSCloudIM

var postId = [String]()
var findHeight = [CGFloat]()

class PostVC: UITableViewController {

    var profileImageArray = [AVFile]()
    var usernameArray = [String]()
    var locationArray = [String]()
    var dateArray = [Date]()
    var postImageArray = [AVFile]()
    var postIdArray = [String]()
    var titleArray = [String]()
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //动态单元格高度设置
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 550
        tableView.separatorStyle = .singleLine
        
        //对指定pistId帖子的查询
        let postQuery = AVQuery(className: "Posts")
        postQuery.whereKey("postId", equalTo: postId.last!)
        postQuery.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            //清空数组
            self.profileImageArray.removeAll(keepingCapacity: false)
            self.usernameArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            self.postImageArray.removeAll(keepingCapacity: false)
            self.postIdArray.removeAll(keepingCapacity: false)
            self.titleArray.removeAll(keepingCapacity: false)
            
            for object in objects! {
                self.profileImageArray.append((object as AnyObject).value(forKey: "avaImage") as! AVFile)
                self.usernameArray.append((object as AnyObject).value(forKey: "username") as! String)
                self.locationArray.append((object as AnyObject).value(forKey: "location") as! String)
                self.dateArray.append((object as AnyObject).createdAt!)
                self.postImageArray.append((object as AnyObject).value(forKey: "media") as! AVFile)
                self.postIdArray.append((object as AnyObject).value(forKey: "postId") as! String)
                self.titleArray.append((object as AnyObject).value(forKey: "title") as! String)
            }
            self.tableView.reloadData()
        }
        
        // TODO: Notification设置
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init(rawValue: "liked"), object: nil)
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 设定Table
    /////////////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        //配置信息
        profileImageArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.avaImage.image = UIImage(data: data!)
        }
        postImageArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            cell.postImage.image = UIImage(data: data!)
        }
        cell.usernameButton.setTitle(usernameArray[indexPath.row], for: .normal)
        cell.locationLabel.text = locationArray[indexPath.row]
        cell.postIdLabel.text = postIdArray[indexPath.row]
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.titleLabel.sizeToFit()

        //配置时间
        let createdTime = dateArray[indexPath.row]
        let now = Date()
        let components : Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = Calendar.current.dateComponents(components, from: createdTime, to: now)
        
        if difference.second! <= 0 {
            cell.dateLabel.text = "现在"
        }
        
        if difference.second! > 0 && difference.minute! <= 0 {
            cell.dateLabel.text = "\(difference.second!)秒"
        }
        
        if difference.minute! > 0 && difference.hour! <= 0 {
            cell.dateLabel.text = "\(difference.minute!)分"
        }
        
        if difference.hour! > 0 && difference.day! <= 0 {
            cell.dateLabel.text = "\(difference.hour!)小时"
        }
        
        if difference.day! > 0 && difference.weekOfMonth! <= 0 {
            cell.dateLabel.text = "\(difference.day!)天"
        }
        
        if difference.weekOfMonth! > 0 {
            cell.dateLabel.text = "\(difference.weekOfMonth!)周"
        }
        
        return cell
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击UsernameButton
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func usernameButtonPressed(_ sender: Any) {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击CommentButton
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func commentButtonPressed(_ sender: Any) {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击MoreButton
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func moreButtonPressed(_ sender: Any) {
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 刷新页面
    /////////////////////////////////////////////////////////////////////////////////
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 警告消息
    /////////////////////////////////////////////////////////////////////////////////
    func alert(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面关闭效果
    /////////////////////////////////////////////////////////////////////////////////
    override func viewWillDisappear(_ animated: Bool) {
        findHeight.removeAll(keepingCapacity: false)
    }
}
