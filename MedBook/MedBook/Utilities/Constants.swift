//
//  Constants.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import Foundation


enum APIs {
    static let bookSearchingUrl = "https://openlibrary.org/search.json"
    static let countryListingURL = "https://api.first.org/data/v1/countries"
    static let coverImageURL = "https://covers.openlibrary.org/b/id/"
}

enum ErrorMessages {
    static let emailValidationError = "Please Enter a valid email address"
    static let passwordValidationError = "Password should be atleast Minimum 8 Characters, At least 1 number, At least 1 Uppercase Character, At least 1 Special Character"
}
