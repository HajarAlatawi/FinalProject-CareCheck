

import UIKit
import Firebase

class ShowerViewController: UIViewController {


    @IBOutlet weak var showerTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var showerItems: [ShowerReminder] = []
    
    override func viewDidLoad() {
          super.viewDidLoad()

      getUserReminders()
      
      }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if ShowerReminderViewController.isUpdated {
        showerItems.removeAll()
        getUserReminders()
      }
    }
    
    
    func getUserReminders() {
      guard let userID = Auth.auth().currentUser?.uid else {return}
      Database.database().reference().child("ShowerReminders").child(userID).observe(.childAdded) { snapshot in
        if let value = snapshot.value as? [String : AnyObject] {
          
          let description = value["description"] as? String
          let name = value["name"] as? String
          let notificationID = value["notificationID"] as? String
          let reminderSet =  value["reminderSet"] as? Bool
          let completed = value["completed"] as? Bool
          let timestamp =  value["timestamp"] as? TimeInterval
         
          let reminder = ShowerReminder(name: name,
                                     date: timestamp,
                                     reminderSet: reminderSet,
                                     notificationID: notificationID,
                                     completed: completed)
          
          self.showerItems.append(reminder)
          self.showerTableView.reloadData()
        }
      }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
      if segue.identifier == "ShowShowerReminder" {
        
        let destination = segue.destination as! ShowerReminderViewController
        destination.showerItem = sender as? ShowerReminder
        
      }else {
        if let selectedIndexPath = showerTableView.indexPathForSelectedRow{
          showerTableView.deselectRow(at: selectedIndexPath,
                                    animated: true)
        }
      }
    }
    
  }




  extension ShowerViewController: UITableViewDelegate,
                               UITableViewDataSource,
                               ShowerTableViewCellDelegate {
    
    func checkBoxToggle(sender: ShowerReminderCell) {
      if let selectIndexPath = showerTableView.indexPath(for: sender){
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        guard var isCompleted = showerItems[selectIndexPath.row].completed else {return}
        isCompleted.toggle()
        
        Database.database().reference().child("ShowerReminders").child(userID).child(showerItems[selectIndexPath.row].notificationID!).updateChildValues(["completed" : isCompleted]) {
          error, ref in
          if error == nil {
            self.showerItems[selectIndexPath.row].completed = !self.showerItems[selectIndexPath.row].completed!
            self.showerTableView.reloadRows(at: [selectIndexPath],
                                     with: .automatic)
          }
        }
      }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return showerItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
      let cell = showerTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShowerReminderCell
      cell.delegate = self
      
      if let completed = showerItems[indexPath.row].completed {
        cell.checkBoxButton.isSelected = completed
      }
      
      cell.showerReminderLabel.text = showerItems[indexPath.row].name
      
        
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let reminder = showerItems[indexPath.row]
      performSegue(withIdentifier: "ShowShowerReminder", sender: reminder)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
         
         guard let userID = Auth.auth().currentUser?.uid else {return}
         guard let notificationID = showerItems[indexPath.row].notificationID else {return}
         Database.database().reference().child("ShowerReminders").child(userID).child(notificationID).removeValue()
         UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
         showerItems.remove(at: indexPath.row)
         showerTableView.deleteRows(at: [indexPath],
                                  with: .fade)
        
       }
     }
    
  }

