

import UIKit
import Firebase
import UserNotifications

class PhotoReminderViewController: UITableViewController {
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var photoItem: PhotoReminder?
  
  static var isUpdated = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    autherizedLocalNotifications()
    
    if let photoItem = photoItem {
      
      let date = Date(timeIntervalSince1970: photoItem.date!)
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy H:mm a"
      let reminderDate = formatter.string(from: date)
      datePicker.date = formatter.date(from: reminderDate)!
      
    }
  }
  
  
  @IBAction func saveReminder(_ sender: UIBarButtonItem) {
    
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    if photoItem != nil {
      // edit
      let notificationID = photoItem?.notificationID
      let updatedReminder : [String: Any] = ["timestamp": Date().timeIntervalSince1970]
      
      Database.database().reference().child("PhotoReminders").child(userID).child(notificationID!).updateChildValues(updatedReminder) { error, ref in
        if error == nil {
          
          // update notification
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID!])
          self.setCalenderNotification(notificationID: notificationID!,
                                       date: self.datePicker.date)
          PhotoReminderViewController.isUpdated = true
          self.navigationController?.popViewController(animated: true)
        }
      }
    } else {
      let notificationID = UUID().uuidString
      let reminder : [String: Any] = ["timestamp": Date().timeIntervalSince1970,
                                      "reminderSet": false,
                                      "notificationID": notificationID,
                                      "completed": false
      ]
      
      Database.database().reference().child("PhotoReminders").child(userID).child(notificationID).setValue(reminder) {
        error, reference in
        if error == nil {
          
          print("saved")
          self.setCalenderNotification(notificationID: notificationID,
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
  
  
  func setCalenderNotification(notificationID : String,
                               date: Date) {
    
    let content = UNMutableNotificationContent()
    content.title = "CareCheck"
    content.subtitle = "Daily Photo"
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
    let notificationID = UUID().uuidString
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
    let isPresentingInAddMood = presentingViewController is PhotoViewController
    
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
  
  
  @IBAction func datePickerPressed(_ sender: UIDatePicker) {
    self.view.endEditing(true)
  }
  
}


