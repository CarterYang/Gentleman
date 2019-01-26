import UIKit

class MediaCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    /////////////////////////////////////////////////////////////////////////////////
    // MARK: 视图初始化
    /////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //页面布局
        let width = UIScreen.main.bounds.width
        
        //设定单元格中image尺寸
        mediaImage.frame = CGRect(x: 0, y: 0, width: (width - 2) / 3, height: (width - 2) / 3)
    }
}
