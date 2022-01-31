

import UIKit

protocol MealTableViewCellDelegate: AnyObject {
  func checkBoxToggle(sender: MealReminderCell)
}


class MealReminderCell: UITableViewCell {

  //create variable to keep track of delegate
  weak var delegate: MealTableViewCellDelegate?
  
  @IBOutlet weak var checkBoxButton: UIButton!
  @IBOutlet weak var MealReminderLabel: UILabel!
  
  
  //create a function to call the delegate
  @IBAction func checkToggled(_ sender: UIButton) {
    delegate?.checkBoxToggle(sender: self)
  }
}
