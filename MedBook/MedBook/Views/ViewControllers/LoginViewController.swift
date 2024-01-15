//
//  LoginViewController.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let databaseHandler = DataBaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        checkIfUserExists(email: EmailTextField.text!, password: PasswordTextField.text!) { result in
            if result {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homeVC.userEmail = self.EmailTextField.text!
                self.navigationController?.pushViewController(homeVC, animated: true)
            } else {
                DispatchQueue.main.async {
                    self.errorTextField.isHidden = false
                    self.errorTextField.text = "User doesn't exist"
                }
            }
        }
    }
    
    func checkIfUserExists(email: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        databaseHandler.fetchUsers { users in
            for user in users {
                if user.email == email && user.password == password {
//                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                    UserDefaults.standard.synchronize()
//                    self.appDel.window!.rootViewController = HomeViewController()
//                    self.appDel.window!.makeKeyAndVisible()
                    completionHandler(true)
                    break
                }
            }
        }
       completionHandler(false)
    }
}
