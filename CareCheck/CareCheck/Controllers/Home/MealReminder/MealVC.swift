

import UIKit
import Firebase


class MealViewController: UIViewController {
  
  @IBOutlet weak var mealsTableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
 
    var mealItems: [MealReminder] = []
    
    override func viewDidLoad() {
          super.viewDidLoad()

      getUserReminders()
      
      }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if MealReminderViewController.isUpdated {
        mealItems.removeAll()
        getUserReminders()
      }
    }
    
    
    func getUserReminders() {
      guard let userID = Auth.auth().currentUser?.uid else {return}
      Database.database().reference().child("MealsReminders").child(userID).observe(.childAdded) { snapshot in
        if let value = snapshot.value as? [String : AnyObject] {
          
          let description = value["description"] as? String
          let name = value["name"] as? String
          let notificationID = value["notificationID"] as? String
          let reminderSet =  value["reminderSet"] as? Bool
          let completed = value["completed"] as? Bool
          let timestamp =  value["timestamp"] as? TimeInterval
         
          let reminder = MealReminder(name: name,
                                     date: timestamp,
                                     description: description,
                                     reminderSet: reminderSet,
                                     notificationID: notificationID,
                                     completed: completed)
          
          self.mealItems.append(reminder)
          self.mealsTableView.reloadData()
        }
      }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
      if segue.identifier == "ShowMealReminder" {
        
        let destination = segue.destination as! MealReminderViewController
        destination.mealItem = sender as? MealReminder
        
      }else {
        if let selectedIndexPath = mealsTableView.indexPathForSelectedRow{
          mealsTableView.deselectRow(at: selectedIndexPath,
                                    animated: true)
        }
      }
    }
    
  }




  extension MealViewController: UITableViewDelegate,
                               UITableViewDataSource,
                               MealTableViewCellDelegate {
    
    func checkBoxToggle(sender: MealReminderCell) {
      if let selectIndexPath = mealsTableView.indexPath(for: sender){
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        guard var isCompleted = mealItems[selectIndexPath.row].completed else {return}
        isCompleted.toggle()
        
        Database.database().reference().child("MealsReminders").child(userID).child(mealItems[selectIndexPath.row].notificationID!).updateChildValues(["completed" : isCompleted]) {
          error, ref in
          if error == nil {
            self.mealItems[selectIndexPath.row].completed = !self.mealItems[selectIndexPath.row].completed!
            self.mealsTableView.reloadRows(at: [selectIndexPath],
                                     with: .automatic)
          }
        }
      }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return mealItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
      let cell = mealsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MealReminderCell
      cell.delegate = self
      
      if let completed = mealItems[indexPath.row].completed {
        cell.checkBoxButton.isSelected = completed
      }
      
      cell.MealReminderLabel.text = mealItems[indexPath.row].name
      
        
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let reminder = mealItems[indexPath.row]
      performSegue(withIdentifier: "ShowMealReminder", sender: reminder)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
         
         guard let userID = Auth.auth().currentUser?.uid else {return}
         guard let notificationID = mealItems[indexPath.row].notificationID else {return}
         Database.database().reference().child("MealsReminders").child(userID).child(notificationID).removeValue()
         UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
         mealItems.remove(at: indexPath.row)
         mealsTableView.deleteRows(at: [indexPath],
                                  with: .fade)
        
       }
     }
  }

