//
//  DatabaseHandler.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//
import Foundation
import CoreData

final class DataBaseHandler {
    private let userDataBaseManager = UserDataBaseManager()
    private let bookDataBaseManager = BookDataBaseManager()
    private var users = [User]()
    private var books = [Book]()
    
    func saveUsers() {
        do {
            try userDataBaseManager.getContext().save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func saveBooks() {
        do {
            try bookDataBaseManager.getContext().save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func fetchUsers(completionHandler: @escaping ([User]) -> ()) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        users = userDataBaseManager.fetchData(request: request)
        completionHandler(users)
    }
    
    func fetchBooks(completionHandler: @escaping ([Book]) -> ()) {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        books = bookDataBaseManager.fetchData(request: request)
        completionHandler(books)
    }
    
    func addUser(user: UserModel) {
        let newUser = User(context: userDataBaseManager.getContext())
        newUser.email = user.email
        newUser.password = user.password ?? ""
        users.append(newUser)
        userDataBaseManager.saveContext()
    }
    
    func addBook(book: BookDataModel) {
        let newBook = Book(context: bookDataBaseManager.getContext())
        newBook.authorName = book.authorName
        newBook.image = book.image
        newBook.title = book.title
        books.append(newBook)
        bookDataBaseManager.saveContext()
    }
}
