

import UIKit
import Firebase

class PhotoViewController: UIViewController {
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet var cameraTableView: UITableView!
  @IBOutlet weak var photoTakenView: UIImageView!
  @IBOutlet weak var takePhotoButton: UIButton!
  @IBOutlet weak var savePhotoButton: UIButton!
  
  
  var rowsWhichAreChecked = [NSIndexPath]()
  
  var photoItems: [PhotoReminder] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    takePhotoButton.layer.cornerRadius = 15
    savePhotoButton.layer.cornerRadius = 15
    
    getUserReminders()
  }
  
  
  func getUserReminders() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    Database.database().reference().child("PhotoReminders").child(userID).observe(.childAdded) { snapshot in
      if let value = snapshot.value as? [String : AnyObject] {

        let notificationID = value["notificationID"] as? String
        let reminderSet =  value["reminderSet"] as? Bool
        let completed = value["completed"] as? Bool
        let timestamp =  value["timestamp"] as? TimeInterval
       
        let reminder = PhotoReminder(date: timestamp,
                                   reminderSet: reminderSet,
                                   notificationID: notificationID,
                                   completed: completed)
        
        self.photoItems.append(reminder)
        self.cameraTableView.reloadData()
      }
    }
  }
   
  
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
      
      if segue.identifier == "ShowPhotoReminder" {
        
        let destination = segue.destination as! PhotoReminderViewController
        destination.photoItem = sender as? PhotoReminder
      }else {
        if let selectedIndexPath = cameraTableView.indexPathForSelectedRow{
          cameraTableView.deselectRow(at: selectedIndexPath,
                                     animated: true)
        }
      }
    }
    
    
  @IBAction func takeAPhotoPressed(_ sender: UIButton) {
    takePhoto()
  }
  
  @IBAction func saveThePhotoPressed(_ sender: UIButton) {
    UIImageWriteToSavedPhotosAlbum(photoTakenView.image!,
                                   self,
                                   #selector(savePhoto(_:didFinishSavingWithError:contextInfo:)),
                                   nil)
  }
  
  
  func takePhoto(){
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = self
    present(picker,
            animated: true)
  }
  
  
  @objc func savePhoto(_ image: UIImage,
                       didFinishSavingWithError error: Error?,
                       contextInfo: UnsafeRawPointer) {
    if let error = error {
      
      // we got back an error!
      let ac = UIAlertController(title: "Save error",
                                 message: error.localizedDescription,
                                 preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK",
                                 style: .default))
      present(ac,
              animated: true)
    } else {
      
      let ac = UIAlertController(title: "Saved!",
                                 message: "Image has been saved to your photos.",
                                 preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK",
                                 style: .default))
      present(ac,
              animated: true)
    }
  }
  
  }
  
  
  

extension PhotoViewController: UITableViewDelegate,
                               UITableViewDataSource,
                               PhotoTableViewCellDelegate,
                               UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate{
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return photoItems.count
  }
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = cameraTableView.dequeueReusableCell(withIdentifier: "Cell",
                                                   for: indexPath) as! PhotoReminderCell
    cell.delegate = self
    
    if let completed = photoItems[indexPath.row].completed {
      cell.checkBoxButton.isSelected = completed
    }
    
    cell.photoReminderLabel.text = "Daily Photo"
    
      
    return cell
    
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
       
       guard let userID = Auth.auth().currentUser?.uid else {return}
       guard let notificationID = photoItems[indexPath.row].notificationID else {return}
       Database.database().reference().child("PhotoReminders").child(userID).child(notificationID).removeValue()
       
       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
       
       photoItems.remove(at: indexPath.row)
       cameraTableView.deleteRows(at: [indexPath],
                                with: .fade)
      
     }
   }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let reminder = photoItems[indexPath.row]
    performSegue(withIdentifier: "ShowPhotoReminder",
                 sender: reminder)
  }


  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true,
                   completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
  {
    picker.dismiss(animated: true,
                   completion: nil)
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
    photoTakenView.image = image
  }
  
  
  func checkBoxToggle(sender: PhotoReminderCell) {
    
    if let selectIndexPath = cameraTableView.indexPath(for: sender){
      
      guard let userID = Auth.auth().currentUser?.uid else {return}
      guard var isCompleted = photoItems[selectIndexPath.row].completed else {return}
      isCompleted.toggle()
      
      Database.database().reference().child("PhotoReminders").child(userID).child(photoItems[selectIndexPath.row].notificationID!).updateChildValues(["completed" : isCompleted]) {
        error, ref in
        if error == nil {
          self.photoItems[selectIndexPath.row].completed = !self.photoItems[selectIndexPath.row].completed!
          self.cameraTableView.reloadRows(at: [selectIndexPath],
                                   with: .automatic)
        }
      }
    }
  }
}

