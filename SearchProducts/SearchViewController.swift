//
//  SearchViewController.swift
//  SearchProducts
//
//  Created by Cristobal Nuñez on 19/4/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Fields
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    // Outlets
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: "Buscar producto")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    let apiHelper = APIHelper()
    var currentPage: Int = 1
    var lastSearched: String = ""
    
    var searchResults: [SearchResultViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // establish delegates/data source
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "ResultsTable"
        textField.delegate = self
        loadingView.isHidden = true
        loadingIndicator.isHidden = true
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Calls api to retrieve search results for searched text when return button is pressed -
        // will NOT call for empty text
        
        
        
        if let text = textField.text, !text.isEmpty {
            view.endEditing(true)
            currentPage = 1
            loadingView.isHidden = false
            loadingIndicator.isHidden = false
            apiHelper.getProductSearchResults(search: text, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                DispatchQueue.main.async() {
                    self.loadingView.isHidden = true
                    self.loadingIndicator.isHidden = true
                        }
                
                if let data = data, success {
                    // Transform data into expected structure [SearchResultViewModel] to load into TableView
                    self.searchResults = self.apiHelper.handleData(data: data)
                    
                    // Shows alert if no results found
                    if self.searchResults.isEmpty {
                        self.showAlert()
                    }
                    // Keep track of next page to be searched as well as last searched term for pagination
                    self.lastSearched = text
                }
                // Presents alert on failure case (service error)
                else if !success, data == nil {
                    self.showAlert()
                }
            }
        }
        return true
    }
    
    func showAlert() {
        let alertVC = UIAlertController(title: "Lo siento", message: "No se han encontrado resultados.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "De acuerdo", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Custom cell to display image, title, and description per searchResult
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        
        // Configure cell based on coorelating searchResult at the same index
        cell.searchResultViewModel = searchResults[indexPath.row]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            currentPage += 1
                        print(currentPage)
                        self.tableView.tableFooterView?.isHidden = false
                        apiHelper.getProductSearchResults(search: lastSearched, pageNumber: currentPage, mediaType: "image", pageLimit: nil) { success, data in
                            if let data = data, success {
                                self.searchResults.append(contentsOf: self.apiHelper.handleData(data: data))
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.tableView.tableFooterView?.isHidden = true
                                }
                            }
                            
                        }
        }
    }
}

