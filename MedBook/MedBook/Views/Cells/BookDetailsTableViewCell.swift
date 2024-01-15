//
//  BookDetailsTableViewCell.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import UIKit

class BookDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var imageURL: String?
    private let dataBaseHandler = DataBaseHandler()
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        let book = BookDataModel(title: bookTitle.text ?? "", authorName: authorLabel.text ?? "", image: imageURL ?? "")
        bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        dataBaseHandler.addBook(book: book)
    }
}
