//
//  HomeScreenCollectionViewController.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

private let reuseIdentifier = "galleryCell"

class HomeScreenCollectionViewController: UICollectionViewController {
    
    private var mainCollectionView: HomeScreenCollectionView {
        guard let view = self.collectionView as? HomeScreenCollectionView else {
            return HomeScreenCollectionView()
        }
        return view
    }
    
    private var imagesData: [UnsplashImageData] = [] {
        didSet {
            var imagesURLs = [String]()
            for image in imagesData {
                imagesURLs.append(image.urls.small)
            }
            imagesURLStrings = imagesURLs
        }
    }
    
    private var imagesURLStrings: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    let refreshIndicator = UIRefreshControl()
    private let decoder = JSONDecoder()
    private let cellsInRowCount: CGFloat = 2.0
    private let randomImagesRequestURL = URL(string: "https://api.unsplash.com/photos/random")
    private let searchImagesRequestURL = URL(string: "https://api.unsplash.com/search/photos")
    private let singleSearchedImageURLString = "https://api.unsplash.com/photos/"
    
    
    // MARK: - loadView()
    
    override func loadView() {
        collectionView = HomeScreenCollectionView()
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(GalleryItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setupViews()
        setupJSONDecoder()
        fetchRandomPhotos()
    }
    
    // MARK: - Setting up views
    
    private func setupViews() {
        setupSearchController()
        setupRefreshControl()
    }
    
    private func setupSearchController() {
        mainCollectionView.searchController.searchBar.delegate = self
        mainCollectionView.searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = mainCollectionView.searchController
    }
    
    private func setupRefreshControl() {
        refreshIndicator.addTarget(self, action: #selector(fetchRandomPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshIndicator
    }
    
    // MARK: - Setting up JSON Decoder
    
    private func setupJSONDecoder() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Fetching random photos
    
    @objc func fetchRandomPhotos() {
        
        guard let url = randomImagesRequestURL else { return }
        
        NetworkService.shared.fetchDataFromURL(url) { [weak self] data, errorText in
            
            guard let self = self else { return }
            
            if let errorText = errorText {
                AlertService.shared.showAlertWith(messeage: errorText, inViewController: self)
            }
            
            guard let jsonData = try? self.decoder.decode([UnsplashImageData].self, from: data)
            else {
                print("Can't decode for first load! Check your load limit")
                return }
            self.imagesData = jsonData
            self.refreshIndicator.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeScreenCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLStrings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GalleryItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.image = nil
        cell.tag = indexPath.row
        cell.activityIndicator.startAnimating()
        cell.isUserInteractionEnabled = false
        
        ImageService.shared.image(forURLString: imagesURLStrings[indexPath.row]) { (image, errorText) in
            
            if let errorText = errorText {
                AlertService.shared.showAlertWith(messeage: errorText, inViewController: self)
            }
            
            guard let image = image else { return }
            
            if cell.tag == indexPath.row {
                DispatchQueue.main.async {
                    cell.image = image
                    cell.activityIndicator.stopAnimating()
                    cell.isUserInteractionEnabled = true
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeScreenCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryItemCollectionViewCell else { return }
        let detailsVC = DetailsViewController()
        detailsVC.imageData = imagesData[indexPath.row]
        guard let image = cell.image  else { return }
        detailsVC.image = image
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeScreenCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewFrame = collectionView.frame
        let cellWidth = (collectionViewFrame.width - (cellsInRowCount - 1) * 2 - mainCollectionView.cellsSpacing * (cellsInRowCount + 1)) / cellsInRowCount
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: - UISearchControllerDelegate

extension HomeScreenCollectionViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text,
              let url = searchImagesRequestURL
        else { return }
        
        NetworkService.shared.fetchDataFromURL(url, searchText: searchText) { [weak self] data, _ in
            
            guard let self = self else { return }
            guard let jsonData = try? self.decoder.decode(SearchedImagesData.self, from: data)
            else {
                print("Can't decode searched images data!!!")
                return }
            
            self.imagesData = []
            
            for result in jsonData.results {
                guard let url = URL(string: self.singleSearchedImageURLString + result.id) else { return }
                
                NetworkService.shared.fetchDataFromURL(url) { singleImageData, _ in
                    
                    guard let singleImageData = try? self.decoder.decode(UnsplashImageData.self, from: singleImageData)
                    else {
                        print("Can't decode Single Image data!")
                        return }
                    
                    self.imagesData.append(singleImageData)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imagesData = []
        collectionView.reloadData()
        fetchRandomPhotos()
    }
}
