

import UIKit

protocol PhotoTableViewCellDelegate: class {
  func checkBoxToggle(sender: PhotoReminderCell)
}

class PhotoReminderCell: UITableViewCell {

  //create variable to keep track of delegate
  weak var delegate: PhotoTableViewCellDelegate?
  
  @IBOutlet weak var checkBoxButton: UIButton!
  @IBOutlet weak var photoReminderLabel: UILabel!
  
  
  //create a function to call the delegate
  @IBAction func checkToggled(_ sender: UIButton) {
    delegate?.checkBoxToggle(sender: self)
  }

}
