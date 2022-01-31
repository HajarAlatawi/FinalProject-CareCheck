

import UIKit

protocol ShowerTableViewCellDelegate: class {
  func checkBoxToggle(sender: ShowerReminderCell)
}

class ShowerReminderCell: UITableViewCell {

    //create variable to keep track of delegate
    weak var delegate: ShowerTableViewCellDelegate?
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var showerReminderLabel: UILabel!
    
    
    //create a function to call the delegate
    @IBAction func checkToggled(_ sender: UIButton) {
      delegate?.checkBoxToggle(sender: self)
    }
  }

