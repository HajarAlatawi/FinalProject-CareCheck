

import UIKit
import Firebase

class HomeViewController: UIViewController {
  
  @IBOutlet weak var signOutButton: UIBarButtonItem!
  @IBOutlet weak var medsButton: UIButton!
  @IBOutlet weak var mealsButton: UIButton!
  @IBOutlet weak var showerButton: UIButton!
  @IBOutlet weak var photoButton: UIButton!
  
  let medsTrackShape = CAShapeLayer()
  let medsShape = CAShapeLayer()
  
  let mealsTrackShape = CAShapeLayer()
  let mealsShape = CAShapeLayer()
 
  let showerTrackShape = CAShapeLayer()
  let showerShape = CAShapeLayer()
  
  let photoTrackShape = CAShapeLayer()
  let photoShape = CAShapeLayer()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureButton()
    configureProgressBar()
    
    view.layer.addSublayer(medsTrackShape)
    view.layer.addSublayer(medsShape)
    
    view.layer.addSublayer(mealsTrackShape)
    view.layer.addSublayer(mealsShape)
    
    view.layer.addSublayer(showerTrackShape)
    view.layer.addSublayer(showerShape)
    
    view.layer.addSublayer(photoTrackShape)
    view.layer.addSublayer(photoShape)
    
    let defults = UserDefaults.standard
    
    Service.getUserInfo(onSuccess: {
      
    }) { (error) in
      
      self.present(Service.createAlertController(
        title: "Error",
        message: error!.localizedDescription),
      animated: true,
      completion: nil)
    }
    
  }
  
  
  @IBAction func medsButtonPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "medsSegue",
                      sender: nil)
    
    
  }
  
  @IBAction func mealsButtonPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "mealsSegue",
                      sender: nil)
  }
  
  @IBAction func showerButtonPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "showerSegue",
                      sender: nil)
  }
  
  @IBAction func photoButtonPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "photoSegue",
                      sender: nil)
  }
  
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    
    do{
      try Auth.auth().signOut()
      let defults = UserDefaults.standard
      defults.set(false, forKey: "isUserSignIn")
      self.dismiss(animated: true, completion: nil)
    }
    
    
    catch let signOutError {
      self.present(
        Service.createAlertController(
          title: "Error",
          message:signOutError.localizedDescription),
        animated: true,
        completion: nil)
    }
    
    let viewController =
          self.storyboard?.instantiateViewController(
            withIdentifier: "signInViewID") as! UINavigationController
    
          viewController.modalTransitionStyle = .crossDissolve
          viewController.modalPresentationStyle = .overFullScreen
    
          self.present(viewController,
                       animated: true,
                       completion: nil)
  }
  
}

