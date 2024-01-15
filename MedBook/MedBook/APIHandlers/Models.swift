//
//  BookModel.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import Foundation
import Foundation
import UIKit

struct BookModel: Codable {
    let numFound: Int
    let start: Int
    let numFoundExact: Bool
    let docs: [BookInfo]
}

struct BookInfo: Codable {
    let title: String?
    let authorName: [String]?
    let coverI: Int
    let ratingsAverage: Double?

    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case coverI = "cover_i"
        case ratingsAverage = "ratings_average"
    }
}

struct CountryData: Codable {
    let data: [String: Country]
}

struct Country: Codable {
    let country: String
    let region: String
}

struct UserModel {
    let email: String?
    let password: String?
    let country: String?
}

struct BookDataModel {
    let title: String
    let authorName: String
    let image: String
}


struct UserData {
    let title: String
    let authorName: String
}
