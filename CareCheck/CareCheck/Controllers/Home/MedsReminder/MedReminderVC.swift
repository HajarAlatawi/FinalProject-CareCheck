

import UIKit
import Firebase
import UserNotifications

class MedReminderViewController: UITableViewController {
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var medNameTF: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var descriptionTF: UITextView!
  
  var medItem: MedReminder?
  
  static var isUpdated = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    medNameTF.delegate = self
    
    //hide keyboard if we tap outside of a field
    let tap = UITapGestureRecognizer(target: self.view,
                                     action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    
    autherizedLocalNotifications()
    hideKeyboardWhenTappedAround()
    
    if let medItem = medItem {
      medNameTF.text = medItem.name
      descriptionTF.text = medItem.description
      
      let date = Date(timeIntervalSince1970: medItem.date!)
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy H:mm a"
      let reminderDate = formatter.string(from: date)
      datePicker.date = formatter.date(from: reminderDate)!
      
    }
  }
  
  
  @IBAction func saveReminder(_ sender: UIBarButtonItem) {
    
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    guard let reminderName = medNameTF.text, reminderName.isEmpty == false else {return}
    guard let reminderDescription = descriptionTF.text, reminderDescription.isEmpty == false else {return}
    
    if medItem != nil {
      // edit
      let notificationID = medItem?.notificationID
      let updatedReminder : [String: Any] = ["name": reminderName,
                                             "timestamp": Date().timeIntervalSince1970,
                                             "description": reminderDescription]
      
      Database.database().reference().child("MedsReminders").child(userID).child(notificationID!).updateChildValues(updatedReminder) { error, ref in
        if error == nil {
          
          // update notification
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID!])
          self.setCalenderNotification(subtitle: reminderName,
                                       body: reminderDescription,
                                       notificationID: notificationID!,
                                       date: self.datePicker.date)
          
          MedReminderViewController.isUpdated = true
          self.navigationController?.popViewController(animated: true)
        }
      }
    } else {
      let notificationID = UUID().uuidString
      let reminder : [String: Any] = ["name": reminderName,
                                      "timestamp": Date().timeIntervalSince1970,
                                      "description": reminderDescription,
                                      "reminderSet": false,
                                      "notificationID": notificationID,
                                      "completed": false
      ]
      
      Database.database().reference().child("MedsReminders").child(userID).child(notificationID).setValue(reminder) {
        error, reference in
        if error == nil {
          
          print("saved")
          self.setCalenderNotification(subtitle: reminderName,
                                       body: reminderDescription,
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
  
  
  
  
  func setCalenderNotification( subtitle: String,
                                body: String,
                                notificationID : String,
                                date: Date) {
    
    let content = UNMutableNotificationContent()
    content.title = "CareCheck"
    content.subtitle = subtitle
    content.body = body
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
    let isPresentingInAddMood = presentingViewController is MedViewController
    
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




extension MedReminderViewController: UITextFieldDelegate{
  
  //when press return button form keyboard it jumps from medNameTF to descriptionTF
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    descriptionTF.becomeFirstResponder()
    return true
  }
}
