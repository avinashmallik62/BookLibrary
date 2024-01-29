//
//  HomeViewController.swift
//  MedBook
//
//  Created by Avinash Kumar on 14/01/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var bookListTableView: UITableView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    let searchController = UISearchController(searchResultsController: nil)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var spinner = UIActivityIndicatorView()
    var searchedData: [BookInfo] = []
    var searchTimer: Timer?
    var searching: Bool = false
    var userEmail: String?
    var users: [User]?
    var searchTextEntered: String?
    var limit = 10
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialiseDataBaseHandler()
        setupUI()
    }
    

    @IBAction func sortByHitsTapped(_ sender: UIButton) {
        print("hits tapped")
    }
    
    @IBAction func sortByAverageTapped(_ sender: UIButton) {
        print("average tapped")
    }
    
    @IBAction func sortByTitleTapped(_ sender: UIButton) {
        print("title tapped")
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchedData.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookListTableView.dequeueReusableCell(withIdentifier: "BookDetailsTableViewCell", for: indexPath) as? BookDetailsTableViewCell else { return UITableViewCell() }
        
        let url = homeViewModel.getImageURL(imagePath: searchedData[indexPath.row].coverI)
        
        DispatchQueue.global().async {
            if let imageURL = URL(string: url), let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    cell.coverImageView.image = UIImage(data: data)
                }
            }
        }
        
        cell.bookTitle.text = searchedData[indexPath.row].title
        cell.authorLabel.text = searchedData[indexPath.row].authorName?.first
        cell.imageURL = url
        if let average = searchedData[indexPath.row].ratingsAverage {
            cell.ratingLabel.text = "\(Int(average)) ⭐️"
        } else {
            cell.ratingLabel.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataBaseHandler?.fetchUsers(completionHandler: { [weak self] users in
            for user in users {
                if user.email == self?.userEmail {
                    
                    break
                }
            }
        })
        dataBaseHandler?.saveUsers()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            limit = limit + 10
            homeViewModel.fetchBooks(title: searchTextEntered, limit: limit) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.searchedData = data.docs
                    DispatchQueue.main.async {
                        self?.bookListTableView.reloadData()
                    }
                case .failure(let error):
                    print("error", error.localizedDescription)
                }
            }
        }
    }
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTimer?.invalidate()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter your data based on the search text
        let searchText = searchBar.text!
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.performSearch(with: searchText)
        }
    }
    
    func performSearch(with searchText: String) {
        spinner.startAnimating()
        if !searchText.isEmpty {
            searching = true
            searchedData.removeAll()
            searchTextEntered = searchText.lowercased()
            homeViewModel.fetchBooks(title: searchText.lowercased()) {
                [weak self] result in
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                }
               
                switch result {
                case .success(let data):
                    self?.searchedData = data.docs
                    DispatchQueue.main.async {
                        self?.buttonsStackView.isHidden = true
                        self?.bookListTableView.isHidden = false
                        self?.buttonsStackView.isHidden = false
                        self?.bookListTableView.reloadData()
                    }
                case .failure(let error):
                    print("error", error.localizedDescription)
                }
            }
        } else {
            searching = false
            searchedData.removeAll()
            DispatchQueue.main.async {
                self.bookListTableView.isHidden = true
                self.bookListTableView.reloadData()
            }
        }
    }
}


extension HomeViewController {
    func setupUI() {
        setupBarButtonItems()
        setupSpinner()
        bookListTableView.isHidden = true
        searchController.loadViewIfNeeded()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for books"
    }
    
    @objc func bookmarkScreenButtonTapped() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let bookListVC = storyBoard.instantiateViewController(withIdentifier: "BookmarkListViewController") as! BookmarkListViewController
        self.navigationController?.pushViewController(bookListVC, animated: true)
    }
    
    @objc func logoutTapped() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func setupSpinner(){
        spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.color = .black
        self.spinner.center = CGPoint(x:UIScreen.main.bounds.size.width / 2, y:UIScreen.main.bounds.size.height / 2)
        self.view.addSubview(spinner)
        spinner.hidesWhenStopped = true
    }
    
    func setupBarButtonItems() {
        let logoutBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(logoutTapped))
        let bookmarkBarButtonItem = UIBarButtonItem(title: "bookmark", style: .done, target: self, action: #selector(bookmarkScreenButtonTapped))
        self.navigationItem.rightBarButtonItems = [logoutBarButtonItem, bookmarkBarButtonItem]
    }
}
