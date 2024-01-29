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
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var dataBaseHandler: DataBaseHandler!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        guard let userModelName = appDelegate?.userModelName,
              let bookModelName = appDelegate?.bookModelName else {
                fatalError("User model name or book model name is nil.")
            }

            let userDBManager = DataBaseManager(modelName: userModelName)
            let bookDBManager = DataBaseManager(modelName: bookModelName)
            dataBaseHandler = DataBaseHandler(userDataBaseManager: userDBManager, bookDataBaseManager: bookDBManager)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        let book = BookDataModel(title: bookTitle.text ?? "", authorName: authorLabel.text ?? "", image: imageURL ?? "")
        bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        dataBaseHandler.addBook(book: book)
    }
}
