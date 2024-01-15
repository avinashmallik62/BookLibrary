//
//  BookService.swift
//  MedBook
//
//  Created by Avinash Kumar on 15/01/24.
//

import Foundation
import UIKit

protocol BookListingDelegate {
    func fetchBooks(title: String?, limit: Int?, completionHandler: @escaping(Result<BookModel, DemoError>) -> Void)
}

class BookService: BookListingDelegate {
    func fetchBooks(title: String? = nil, limit: Int? = 10, completionHandler: @escaping (Result<BookModel, DemoError>) -> Void) {
        let urlString = APIs.bookSearchingUrl + "?q=title=\(title!)&limit=\(limit!)"
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.BadURL))
            return
        }
        NetworkManager().fetchRequest(type: BookModel.self, url: url, completion: completionHandler)
    }
}
