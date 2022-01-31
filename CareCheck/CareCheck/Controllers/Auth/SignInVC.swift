

import UIKit
import Firebase

class SignInViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var forgetPasswordButton: UIButton!
  
 
    override func viewDidLoad() {
    super.viewDidLoad()
  
    signInButton.layer.cornerRadius = 15
      
      checkUserIsSignedIn()
      hideKeyboardWhenTappedAround()
  }
  
  
  @IBAction func signInButtonPressed(_ sender: UIButton) {
    
    let defults = UserDefaults.standard
    Auth.auth().signIn(withEmail: emailTextField.text!,
                       password: passwordTextField.text!) {
      
      (authResult, error) in
      if error != nil {
        
        self.present(
          Service.createAlertController(
            title: "Error",
            message: error!.localizedDescription),
          animated: true,
          completion: nil)
        
        return
      }
      
      self.performSegue(withIdentifier: "userSignedInSegue",
                        sender: nil)
    }
  }
  
  
  @IBAction func forgetPasswordButtonPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "forgetPasswordSegue",
                      sender: nil)
    
  }
  
  
  func checkUserIsSignedIn(){
    Auth.auth().addStateDidChangeListener{(auth,user)in
      if user != nil
      {
        let viewController =
        self.storyboard?.instantiateViewController(
          withIdentifier: "welcomeViewID") as! UITabBarController
        
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController,
                     animated: true,
                     completion: nil)
      }
    }
  }
  
}


