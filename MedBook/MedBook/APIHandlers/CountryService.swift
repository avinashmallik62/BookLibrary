//
//  CountryService.swift
//  MedBook
//
//  Created by Avinash Kumar on 15/01/24.
//

import Foundation

protocol CountryListingDelegate {
    func fetchCountries(completionHandler: @escaping(Result<CountryData, DemoError>) -> Void)
}

class CountryService: CountryListingDelegate {
    func fetchCountries(completionHandler: @escaping (Result<CountryData, DemoError>) -> Void) {
        let urlString = APIs.countryListingURL
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.BadURL))
            return
        }
        NetworkManager().fetchRequest(type: CountryData.self, url: url, completion: completionHandler)
    }
}
