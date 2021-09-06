//
//  DiscoverViewController.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/5/21.
//

import UIKit
import SafariServices

class DiscoverViewController: UIViewController {
    
    private let searchBar: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search News, Topics, & Stories"
        search.searchBar.autocapitalizationType = .none
        search.obscuresBackgroundDuringPresentation = false
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPink,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        return search
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .clear
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return table
    }()
    
    lazy var watermarkLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: view.frame.size.height/3, width: view.frame.size.width, height: 50))
        label.text = "Search News, Topics and Stories"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .systemGray3
        tableView.addSubview(label)
        return label
    }()
    
    let refreshControl = UIRefreshControl()
    var currentSearchText = ""
    var canRefresh = false {
        didSet {
            if canRefresh {
                configureRefreshControl()
            }
        }
    }
    
    var model = [Article]()
    var loading = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        to make navigation controller's background clear and transparent:
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        
        configureTableView()
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        if model.count == 0 {
            tableView.addSubview(watermarkLabel)
        }
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureRefreshControl() {
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(pullToRefesh), for: .valueChanged)
    }
    
    @objc private func pullToRefesh() {
        fetchInfo(with: currentSearchText)
        refreshControl.endRefreshing()
    }
    
    private func fetchInfo(with searchText: String) {
        let apiKey = "" // use your own api key here
        
        NetworkManager.shared.fetchData(urlString: "https://newsapi.org/v2/everything?q=\(searchText)&apiKey=\(apiKey)") { (results: Result<Model, Error>) in
            switch results {
            case .success(let model):
                self.model = model.articles
                self.loading = false
                
                DispatchQueue.main.async {
                    self.watermarkLabel.removeFromSuperview()
                    self.tableView.reloadData()
                    self.searchBar.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
    }
    
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchedText = searchBar.text?.replacingOccurrences(of: " ", with: "%20") else { return }
        currentSearchText = searchedText
        
        fetchInfo(with: currentSearchText)
        searchBar.text = ""
        
        if canRefresh == false {
            canRefresh = true
        }
    }
}

extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if model.count == 0 {
            return 0
        }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        
        if let urlString = model[indexPath.row].urlToImage {
            if let url = URL(string: urlString) {
                cell.resultImageView.sd_setImage(with: url)
            }
        }
        
        cell.resultLabel.text = model[indexPath.row].title
        return cell
    }
    
}

extension DiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let urlString = model[indexPath.row].url
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        
    }
}
