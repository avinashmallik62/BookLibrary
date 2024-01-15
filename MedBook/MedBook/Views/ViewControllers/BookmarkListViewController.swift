//
//  BookmarkListViewController.swift
//  MedBook
//
//  Created by Avinash Kumar on 15/01/24.
//

import Foundation
import UIKit

class BookmarkListViewController: UIViewController {
    
    @IBOutlet weak var bookmarkListTableView: UITableView!
    private let databaseHandler = DataBaseHandler()
    private var books = [Book]()
    
    override func viewDidLoad() {
        databaseHandler.fetchBooks { [weak self] books in
            self?.books = books
            print("books", books)
            self?.bookmarkListTableView.reloadData()
        }
    }
}

extension BookmarkListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookmarkListTableView.dequeueReusableCell(withIdentifier: "BookmarkListTVC", for: indexPath) as? BookmarkListTVC else { return UITableViewCell() }
        DispatchQueue.global().async {
            if let imageURL = URL(string: self.books[indexPath.row].image ?? ""), let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    cell.bookImage.image = UIImage(data: data)
                }
            }
        }
        cell.bookTitle.text = books[indexPath.row].title
        cell.authorLabel.text = books[indexPath.row].authorName
        
        return cell
    }
}
