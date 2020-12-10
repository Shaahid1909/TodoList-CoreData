
import UIKit

class TableViewCell2: UITableViewCell {
    
    
    @IBOutlet var pushImg: UIImageView!
    @IBOutlet var pushTextField: UITextField!
    @IBOutlet var TextTitle: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TextTitle.borderStyle = .none
        pushTextField.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
