//
//  SignupViewModel.swift
//  MedBook
//
//  Created by Avinash Kumar on 15/01/24.
//

import Foundation

class SignupViewModel {
    func fetchCountries(completionHandler: @escaping (Result<CountryData, DemoError>) -> ()) {
        CountryService().fetchCountries { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                print(error)
                completionHandler(.failure(DemoError.DecodingError))
            }
        }
    }
    
    func performValidationForEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func performValidationForPassword(password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
