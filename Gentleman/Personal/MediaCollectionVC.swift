import UIKit
import AVOSCloud
import AVOSCloudIM

class MediaCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var refresher = UIRefreshControl()
    var postPerPage: Int = 12
    var postIdArray = [String]()
    var mediaArray = [AVFile]()
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.alwaysBounceVertical = true     //允许垂直的拉拽刷新动作
        
        //设置refresher控件到CollectionView中
        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresher)
        
        // TODO: 页面修饰与布局
        //self.collectionView.backgroundColor = .green
        let width = self.view.frame.width
        let height = self.view.frame.height
        let tabBarHeight = self.tabBarController!.tabBar.frame.height
        self.collectionView.frame = CGRect(x: 0, y: tabBarHeight, width: width, height: height - tabBarHeight)
        
        loadPosts()
    }

    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 设置单元格布局
    /////////////////////////////////////////////////////////////////////////////////
    //设置Cell 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (self.view.frame.width - 2) / 3, height: (self.view.frame.width - 2) / 3)
        return size
    }

    //同一行Cell 之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //同一列Cell 之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //设置Collection中单元格个数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mediaArray.count == 0 ? 0:30
        //return mediaArray.count
    }
    
    //配置单元格
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionCell
        
        mediaArray[0].getDataInBackground { (data: Data?, error: Error?) in
        //mediaArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.mediaImage.image = UIImage(data: data!)
            }
            else {
                print("无法从PictureArray中提取图片！")
            }
        }
        
        return cell
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 载入帖子到mediaArray
    /////////////////////////////////////////////////////////////////////////////////
    func loadPosts() {
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()!.username!)  //注意：这里有改动current()？.username
        query.limit = postPerPage
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            if error == nil {
                //如果查询成功，清空两个Array
                self.postIdArray.removeAll(keepingCapacity: false)
                self.mediaArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    //将查询到的数据x添加到数组中
                    self.postIdArray.append((object as AnyObject).value(forKey: "postId") as! String)
                    self.mediaArray.append((object as AnyObject).value(forKey: "media") as! AVFile)
                }
                
                self.collectionView.reloadData()
                self.refresher.endRefreshing()
            }
            else {
                print(error?.localizedDescription ?? "对象查找错误！")
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 下拉加载更多帖子
    /////////////////////////////////////////////////////////////////////////////////
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
            self.loadMorePosts()
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 加载更多帖子
    /////////////////////////////////////////////////////////////////////////////////
    func loadMorePosts() {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 刷新页面
    /////////////////////////////////////////////////////////////////////////////////
    @objc func refresh() {
        self.collectionView.reloadData()
        //停止动画刷新
        refresher.endRefreshing()
    }
}
