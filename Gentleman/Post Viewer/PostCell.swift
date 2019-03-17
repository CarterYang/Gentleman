import UIKit
import AVOSCloud
import AVOSCloudIM

class PostCell: UITableViewCell {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentNum: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postIdLabel: UILabel!
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 屏幕初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: 页面修饰
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        
        likeButton.setTitleColor(.clear, for: .normal)      //将likeButton按钮的title文字颜色定位无色
        
        // TODO: 添加手势
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeTap.numberOfTapsRequired = 2
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(likeTap)
        
        alignment()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 点击LikeButton
    /////////////////////////////////////////////////////////////////////////////////
    @IBAction func likeButtonPressed(_ sender: Any) {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 双击点赞功能
    /////////////////////////////////////////////////////////////////////////////////
    @objc func likeTapped() {
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 页面布局
    /////////////////////////////////////////////////////////////////////////////////
    func alignment() {
//        usernameButton.backgroundColor = .red
//        locationLabel.backgroundColor = .green
//        dateLabel.backgroundColor = .red
//        commentButton.backgroundColor = .red
//        commentNum.backgroundColor = .green
//        likeButton.backgroundColor = .red
//        likeNum.backgroundColor = .green
//        titleLabel.backgroundColor = .red
//        postImage.backgroundColor = .red
        
        let width = UIScreen.main.bounds.width
        
        avaImage.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentNum.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeNum.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        postIdLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[avaImage(40)]-10-[postImage(\(findHeight.last!))]-5-[commentButton(25)]-5-[titleLabel]-5-|", options: [], metrics: nil, views: ["avaImage": avaImage, "postImage": postImage, "commentButton": commentButton, "titleLabel": titleLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[usernameButton(25)]-0-[locationLabel(15)]", options: [], metrics: nil, views: ["usernameButton": usernameButton, "locationLabel": locationLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[dateLabel(40)]", options: [], metrics: nil, views: ["dateLabel": dateLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[postImage]-5-[commentNum(25)]", options: [], metrics: nil, views: ["postImage": postImage, "commentNum": commentNum]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[postImage]-5-[likeButton(25)]", options: [], metrics: nil, views: ["postImage": postImage, "likeButton": likeButton]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[postImage]-5-[likeNum(25)]", options: [], metrics: nil, views: ["postImage": postImage, "likeNum": likeNum]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[postImage]-5-[moreButton(25)]", options: [], metrics: nil, views: ["postImage": postImage, "moreButton": moreButton]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[avaImage(40)]-5-[usernameButton(\(width - 120))]-5-[dateLabel(50)]-10-|", options: [], metrics: nil, views: ["avaImage": avaImage, "usernameButton": usernameButton, "dateLabel": dateLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[avaImage]-5-[locationLabel(\(width - 120))]-5-[dateLabel]", options: [], metrics: nil, views: ["avaImage": avaImage, "locationLabel": locationLabel, "dateLabel": dateLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[postImage]-0-|", options: [], metrics: nil, views: ["postImage": postImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[commentButton(25)]-0-[commentNum(50)]-5-[likeButton(25)]-0-[likeNum(50)]", options: [], metrics: nil, views: ["commentButton": commentButton, "commentNum": commentNum, "likeButton": likeButton, "likeNum": likeNum]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[moreButton(25)]-10-|", options: [], metrics: nil, views: ["moreButton": moreButton]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options: [], metrics: nil, views: ["titleLabel": titleLabel]))
    }
}
