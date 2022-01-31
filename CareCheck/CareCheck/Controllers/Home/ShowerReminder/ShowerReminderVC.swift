

import UIKit
import Firebase
import UserNotifications

class ShowerReminderViewController: UITableViewController{
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var showerNameTF: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var showerItem: ShowerReminder?
  
  static var isUpdated = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //hide keyboard if we tap outside of a field
    let tap = UITapGestureRecognizer(target: self.view,
                                     action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    
    autherizedLocalNotifications()
    hideKeyboardWhenTappedAround() 
    
    if let showerItem = showerItem {
      showerNameTF.text = showerItem.name
      
      let date = Date(timeIntervalSince1970: showerItem.date!)
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy H:mm a"
      let reminderDate = formatter.string(from: date)
      datePicker.date = formatter.date(from: reminderDate)!
      
    }
  }
  
  
  @IBAction func saveReminder(_ sender: UIBarButtonItem) {
    
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    guard let reminderName = showerNameTF.text, reminderName.isEmpty == false else {return}
    
    if showerItem != nil {
      // edit
      let notificationID = showerItem?.notificationID
      let updatedReminder : [String: Any] = ["name": reminderName,
                                             "timestamp": Date().timeIntervalSince1970
      ]
      
      Database.database().reference().child("ShowerReminders").child(userID).child(notificationID!).updateChildValues(updatedReminder) { error, ref in
        if error == nil {
          
          // update notification
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID!])
          self.setCalenderNotification(subtitle: reminderName,
                                       notificationID: notificationID!,
                                       date: self.datePicker.date)
          ShowerReminderViewController.isUpdated = true
          self.navigationController?.popViewController(animated: true)
        }
      }
    } else {
      let notificationID = UUID().uuidString
      let reminder : [String: Any] = ["name": reminderName,
                                      "timestamp": Date().timeIntervalSince1970,
                                      "reminderSet": false,
                                      "notificationID": notificationID,
                                      "completed": false
      ]
      
      Database.database().reference().child("ShowerReminders").child(userID).child(notificationID).setValue(reminder) {
        error, reference in
        if error == nil {
          
          print("saved")
          self.setCalenderNotification(subtitle: reminderName,
                                       notificationID: notificationID,
                                       date: self.datePicker.date)
          
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
    
  }
  
  
  func autherizedLocalNotifications(){
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,
                                                                      .sound,
                                                                      .badge])
    {
      (granted, error) in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      if granted {
        print("garnted")
      }else{
        print("not garnted")
      }
    }
  }
  
  
  func setNotification(){
    
    //remove all notifications
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
  }
  
  
  func setCalenderNotification(subtitle: String,
                               notificationID : String,
                               date: Date) {
    
    let content = UNMutableNotificationContent()
    content.title = "CareCheck"
    content.subtitle = subtitle
    content.sound = .default
    
    //create trigger
    var dateComponents = Calendar.current.dateComponents([.year,
                                                          .month,
                                                          .day,
                                                          .hour,
                                                          .minute],
                                                         from: date)
    dateComponents.second = 00
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                repeats: true)
    
    //create request
    let request = UNNotificationRequest(identifier: notificationID,
                                        content: content,
                                        trigger: trigger)
    
    
    //register request with notification center
    UNUserNotificationCenter.current().add(request)
    {
      (error) in
      if let error = error
      {
        print(error.localizedDescription)
      }else {
        print(notificationID, content.title)
      }
    }
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    
    //check if the segue comes from which viewcontroller
    let isPresentingInAddMood = presentingViewController is ShowerViewController
    
    if isPresentingInAddMood{
      
      dismiss(animated: true, completion: nil)
      
    }else{
      navigationController?.popViewController(animated: true)
      dismiss(animated: true, completion: nil)
    }
  }
  
  
  func enableDisableSaveButton(text: String){
    
    if text.count > 0 {
      saveButton.isEnabled = true
      
    } else {
      saveButton.isEnabled = false
    }
  }
  
  
  //to unable saveButton to save if the textField is empty
  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    enableDisableSaveButton(text: sender.text!)
    
  }
  
  
  @IBAction func datePickerPressed(_ sender: UIDatePicker) {
    self.view.endEditing(true)
  }
}


