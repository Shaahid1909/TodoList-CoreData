
import UIKit

class CalenderTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewcal: UIImageView!
    @IBOutlet weak var CalView: UIView!
    @IBOutlet weak var CalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        CalView.layer.cornerRadius = 10
//        CalView.layer.borderWidth = 0.3
//        CalView.layer.borderColor = UIColor.systemGray.cgColor
        imageViewcal.layer.cornerRadius = 20
        imageViewcal.layer.borderWidth = 1.0
        imageViewcal.layer.masksToBounds = false
        imageViewcal.layer.borderColor = UIColor.white.cgColor
        imageViewcal.clipsToBounds = true

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
