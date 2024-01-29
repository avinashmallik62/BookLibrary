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
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var dataBaseHandler: DataBaseHandler!
    
    override func viewDidLoad() {
        
        guard let userModelName = appDelegate?.userModelName,
              let bookModelName = appDelegate?.bookModelName else {
                fatalError("User model name or book model name is nil.")
            }

            let userDBManager = DataBaseManager(modelName: userModelName)
            let bookDBManager = DataBaseManager(modelName: bookModelName)
            dataBaseHandler = DataBaseHandler(userDataBaseManager: userDBManager, bookDataBaseManager: bookDBManager)
        
        super.viewDidLoad()
    }

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        checkIfUserExists(email: EmailTextField.text!, password: PasswordTextField.text!) { result in
            if result {
                DispatchQueue.main.async {
                    self.errorTextField.isHidden = true
                    self.errorTextField.text = ""
                }
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
        dataBaseHandler.fetchUsers { users in
            for user in users {
                if user.email == email && user.password == password {
                    completionHandler(true)
                    break
                }
            }
        }
       completionHandler(false)
    }
}
