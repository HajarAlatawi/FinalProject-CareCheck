

import UIKit
import Firebase


class SignUpViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signUpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUpButton.layer.cornerRadius = 15
    
    hideKeyboardWhenTappedAround()
    
  }
  
  
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    
    let defults = UserDefaults.standard
    
    Service.signUpUser(email: emailTextField.text!,
                       password: passwordTextField.text!,
                       name: nameTextField.text!,
                       onSuccess: {
      self.performSegue(withIdentifier: "userSignedUpSegue",
                        sender: nil)
    }) { (error) in
      self.present(
                Service.createAlertController(title: "Error",
                                              message: error!.localizedDescription), animated: true,
                completion: nil)
    }
  }
}
