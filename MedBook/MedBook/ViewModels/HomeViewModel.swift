//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import Foundation

class HomeViewModel {
    func fetchBooks(title: String? = nil, limit: Int? = 10, completionHandler: @escaping (Result<BookModel, DemoError>) -> ()) {
        BookService().fetchBooks(title: title, limit: limit) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getImageURL(imagePath: Int) -> String {
        return APIs.coverImageURL + "\(imagePath)-M.jpg"
    }
}
