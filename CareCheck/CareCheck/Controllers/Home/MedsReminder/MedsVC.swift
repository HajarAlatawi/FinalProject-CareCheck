

import UIKit
import Firebase


class MedViewController: UIViewController {

  @IBOutlet weak var medsTableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  var medItems: [MedReminder] = []
  
  override func viewDidLoad() {
        super.viewDidLoad()

    getUserReminders()
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if MedReminderViewController.isUpdated {
      medItems.removeAll()
      getUserReminders()
    }
  }
  
  
  func getUserReminders() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    Database.database().reference().child("MedsReminders").child(userID).observe(.childAdded) { snapshot in
      if let value = snapshot.value as? [String : AnyObject] {
        
        let description = value["description"] as? String
        let name = value["name"] as? String
        let notificationID = value["notificationID"] as? String
        let reminderSet =  value["reminderSet"] as? Bool
        let completed = value["completed"] as? Bool
        let timestamp =  value["timestamp"] as? TimeInterval
       
        let reminder = MedReminder(name: name,
                                   date: timestamp,
                                   description: description,
                                   reminderSet: reminderSet,
                                   notificationID: notificationID,
                                   completed: completed)
        
        self.medItems.append(reminder)
        self.medsTableView.reloadData()
      }
    }

  }
  
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "ShowMedReminder" {
      
      let destination = segue.destination as! MedReminderViewController
      destination.medItem = sender as? MedReminder
      
    }else {
      if let selectedIndexPath = medsTableView.indexPathForSelectedRow{
        medsTableView.deselectRow(at: selectedIndexPath,
                                  animated: true)
      }
    }
  }
  
}




extension MedViewController: UITableViewDelegate,
                             UITableViewDataSource,
                             MedTableViewCellDelegate {
  
  func checkBoxToggle(sender: MedReminderCell) {
    if let selectIndexPath = medsTableView.indexPath(for: sender){
      
      guard let userID = Auth.auth().currentUser?.uid else {return}
      guard var isCompleted = medItems[selectIndexPath.row].completed else {return}
      isCompleted.toggle()
      
      Database.database().reference().child("MedsReminders").child(userID).child(medItems[selectIndexPath.row].notificationID!).updateChildValues(["completed" : isCompleted]) {
        error, ref in
        if error == nil {
          self.medItems[selectIndexPath.row].completed = !self.medItems[selectIndexPath.row].completed!
          self.medsTableView.reloadRows(at: [selectIndexPath],
                                   with: .automatic)
        }
      }
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return medItems.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
    
    let cell = medsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MedReminderCell
    cell.delegate = self
    
    if let completed = medItems[indexPath.row].completed {
      cell.checkBoxButton.isSelected = completed
    }
    
    cell.medReminderLabel.text = medItems[indexPath.row].name
     
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let reminder = medItems[indexPath.row]
    performSegue(withIdentifier: "ShowMedReminder", sender: reminder)
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
       
       guard let userID = Auth.auth().currentUser?.uid else {return}
       guard let notificationID = medItems[indexPath.row].notificationID else {return}
       Database.database().reference().child("MedsReminders").child(userID).child(notificationID).removeValue()
       
       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
       
       medItems.remove(at: indexPath.row)
       medsTableView.deleteRows(at: [indexPath],
                                with: .fade)
      
     }
   }
  
}
