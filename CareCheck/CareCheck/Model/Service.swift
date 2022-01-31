

import UIKit
import Firebase


struct Service {
  
  static func signUpUser (email: String,
                          password: String,
                          name: String,
                          onSuccess: @escaping () -> Void,
                          onError: @escaping (_ error: Error?) -> Void){
    
    Auth.auth().createUser(withEmail:email ,
                           password: password) { (authResult, error) in
      if error != nil {
        
        onError(error!)
        return
      }
      uploadToDatabase(email: email,
                       name: name,
                       onSuccess: onSuccess)
    }
  }

  
  static func uploadToDatabase (email: String,
                                name: String,
                                onSuccess: @escaping () -> Void){
    
  
   var  ref = Database.database().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
    ref.child("users").child(uid!).setValue(["email": email,
                                             "name": name])
  
   
    onSuccess()
    
    ref.child("users").child(uid!)
  }
  


  static func getUserInfo(onSuccess: @escaping () -> Void,
                          onError: @escaping(_ error: Error?) ->Void) {
    let ref = Database.database().reference()
    let defualts = UserDefaults.standard
    
    guard let uid = Auth.auth().currentUser?.uid else {return}
    
    ref.child("users").child(uid).observe(.value,
                                          with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: Any]
      {
        let email = dictionary["email"] as! String
        let name = dictionary["name"] as! String
        
        defualts.set(email, forKey: "userEmailKey")
        defualts.set(name, forKey: "userNameKey")
        
        onSuccess()
      }
    }) { (error) in
      onError(error)
    }

  }
  
  
  
  static func createAlertController(title: String,
                                    message: String)
  -> UIAlertController{
    
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok",
                                 style: .default) { (action) in
      alert.dismiss(animated: true,
                    completion: nil)
    }
    
    alert.addAction(okAction)
    
    return alert
  }
  
}
