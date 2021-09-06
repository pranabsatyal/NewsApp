//
//  HomeViewController.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/5/21.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    
    static let topStoryHeaderId = "topStoryHeaderId"
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: HomeViewController.createCollectionViewLayout())
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private var modelData = [Article]()
    
    var loading = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        requestToFetchData()

        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureCollectionView()
        
        configureRefreshControl()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        collectionView.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: view.frame.width/2 - 10, y: view.frame.height/3, width: 10, height: 10)
        
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        collectionView.register(MiddleCollectionViewCell.self, forCellWithReuseIdentifier: MiddleCollectionViewCell.identifier)
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: HomeViewController.topStoryHeaderId, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureRefreshControl() {
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        requestToFetchData()
    }
    
    private func requestToFetchData() {
        let apiKey = "" // use your own api key here
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        fetchData(withURL: url)
    }
    
    private func fetchData(withURL: String) {
        activityIndicator.startAnimating()
        NetworkManager.shared.fetchData(urlString: withURL) { [weak self] (results: Result<Model, Error>) in
            switch results {
            
            case .success(let result):
                self?.modelData = result.articles
                self?.loading = false
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { sectionNumber, _ in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets.trailing = 10
                item.contentInsets.bottom = 10
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.92),
                        heightDimension: .fractionalHeight(0.55)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 10
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(100)),
                        elementKind: topStoryHeaderId,
                        alignment: .topLeading)
                ]
                
                
                return section
                
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1/2),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets.trailing = 10
                item.contentInsets.bottom = 10

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1/3)
                    ),
                    subitems: [item]
                )
                group.contentInsets.leading = 10
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            } else {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets.trailing = 10
                item.contentInsets.bottom = 10
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)
                    ),
                    subitems: [item]
                )
                group.contentInsets.leading = 10
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if loading {
            return 0
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        if section == 0 {
            itemCount = 4
        } else if section == 1 {
            itemCount = 4
        } else {
            itemCount = modelData.count - 8
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if loading {
            activityIndicator.startAnimating()
        } else {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as! TopCollectionViewCell
                
                if let imageUrl = modelData[indexPath.item].urlToImage {
                    cell.configureImage(with: imageUrl)
                }
                
                cell.sourceLabel.text = modelData[indexPath.item].source.name
                cell.titleLabel.text = modelData[indexPath.item].title
                
                return cell
                
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiddleCollectionViewCell.identifier, for: indexPath) as! MiddleCollectionViewCell
                
                let itemIndex = indexPath.item + 4
                
                if let imageUrl = modelData[itemIndex].urlToImage {
                    cell.configureImage(with: imageUrl)
                }
                
                cell.sourceLabel.text = modelData[itemIndex].source.name
                cell.titleLabel.text = modelData[itemIndex].title
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as! BottomCollectionViewCell
                
                let itemIndex = indexPath.item + 8
                
                if let imageUrl = modelData[itemIndex].urlToImage {
                    cell.configureImage(with: imageUrl)
                }
                
                cell.sourceLabel.text = modelData[itemIndex].source.name
                cell.titleLabel.text = modelData[itemIndex].title
                
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        return header
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let itemIndex = indexPath.item
            showWeb(for: itemIndex)
            
        } else if indexPath.section == 1 {
            let itemIndex = indexPath.item + 4
            showWeb(for: itemIndex)
        } else {
            let itemIndex = indexPath.item + 8
            showWeb(for: itemIndex)
        }
        
    }
    
    private func showWeb(for indexPath: Int) {
        let urlString = modelData[indexPath].url
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
