

import UIKit

protocol MedTableViewCellDelegate: class {
  func checkBoxToggle(sender: MedReminderCell)
}


class MedReminderCell: UITableViewCell {

  //create variable to keep track of delegate
  weak var delegate: MedTableViewCellDelegate?
  
  @IBOutlet weak var checkBoxButton: UIButton!
  @IBOutlet weak var medReminderLabel: UILabel!
  
  
  //create a function to call the delegate
  @IBAction func checkToggled(_ sender: UIButton) {
    delegate?.checkBoxToggle(sender: self)
  }
}
