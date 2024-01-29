//
//  SignupViewController.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let signupViewModel = SignupViewModel()
    let databaseHandler = DataBaseHandler()
    var selectedCountry: String?
    var countries: [String] = [String]()
    
    @IBAction func SignupButtonTapped(_ sender: UIButton) {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let country = selectedCountry
        
        if !signupViewModel.performValidationForEmail(email: email) {
            errorLabel.isHidden = false
            errorLabel.text = ErrorMessages.emailValidationError
        } else if !signupViewModel.performValidationForPassword(password: password) {
            errorLabel.isHidden = false
            errorLabel.text = ErrorMessages.passwordValidationError
        } else {
            errorLabel.isHidden = true
            databaseHandler.addUser(user: UserModel(email: email, password: password, country: selectedCountry))
            databaseHandler.saveUsers()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupViewModel.fetchCountries { result in
            switch result {
            case .success(let data):
                for values in data.data {
                    self.countries.append(values.value.country)
                }
                DispatchQueue.main.async {
                    self.countryPickerView.reloadAllComponents()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = countries[row]
        self.selectedCountry = country
    }
}


extension SignupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == emailTextField {
                let email = emailTextField.text ?? ""
                if !signupViewModel.performValidationForEmail(email: email) {
                    DispatchQueue.main.async {
                        self.errorLabel.text = ErrorMessages.emailValidationError
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorLabel.text = ""
                    }
                }
            } else if textField == passwordTextField {
                let password = passwordTextField.text ?? ""
                if !signupViewModel.performValidationForPassword(password: password) {
                    DispatchQueue.main.async {
                        self.errorLabel.text = ErrorMessages.passwordValidationError
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorLabel.text = ""
                    }
                }
            }
        }
}
