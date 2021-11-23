//
//  HomeScreenCollectionViewController.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

private let reuseIdentifier = "galleryCell"

class HomeScreenCollectionViewController: UICollectionViewController {
    
    private let randomImagesRequestURL = URL(string: "https://api.unsplash.com/photos/random")
    private let searchImagesRequestURL = URL(string: "https://api.unsplash.com/search/photos")
    private let cellsInRowCount: CGFloat = 2.0
    private let cellsSpacing: CGFloat = 8.0
    
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
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK:- viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        self.collectionView!.register(GalleryItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchRandomPhotos()
        
//        guard let url = randomImagesRequestURL else { return }
//
//        NetworkService.shared.fetchDataFromURL(url) { [weak self] data in
//
//            guard let jsonData = try? self?.decoder.decode([UnsplashImageData].self, from: data)
//            else {
//                print("Can't decode for first load! Check your load limit")
//                return }
//            self?.imagesData = jsonData
//        }
    }
    
    // MARK:- Setting up views
    
    private func setupViews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: cellsSpacing, left: cellsSpacing, bottom: cellsSpacing, right: cellsSpacing)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        // Creating and seting up a UISearchController
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    // MARK:- UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLStrings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryItemCollectionViewCell
        cell.image = nil
        cell.tag = indexPath.row
        cell.activityIndicator.startAnimating()
        cell.isUserInteractionEnabled = false
        guard let url = URL(string: imagesURLStrings[indexPath.row]) else { return cell }
        
        NetworkService.shared.fetchDataFromURL(url) { imageData in
            
            guard let image = UIImage(data: imageData) else { return }
            
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
    
    func fetchRandomPhotos() {
        
        guard let url = randomImagesRequestURL else { return }
        
        NetworkService.shared.fetchDataFromURL(url) { [weak self] data in
            
            guard let jsonData = try? self?.decoder.decode([UnsplashImageData].self, from: data)
            else {
                print("Can't decode for first load! Check your load limit")
                return }
            self?.imagesData = jsonData
        }
    }

    // MARK:- UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryItemCollectionViewCell else { return }
        let detailsVC = DetailsViewController()
        detailsVC.imageData = imagesData[indexPath.row]
        detailsVC.image = cell.image
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}

// MARK:- UICollectionViewDelegateFlowLayout

extension HomeScreenCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewFrame = collectionView.frame
        let cellWidth = (collectionViewFrame.width - (cellsInRowCount - 1) * 2 - cellsSpacing * (cellsInRowCount + 1)) / cellsInRowCount
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK:- UISearchControllerDelegate

extension HomeScreenCollectionViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        guard let searchText = searchBar.text else { return }
        
        guard let url = searchImagesRequestURL else { return }

        NetworkService.shared.fetchDataFromURL(url, searchText: searchText) { [weak self] data in

            guard let jsonData = try? self?.decoder.decode(SearchedImagesData.self, from: data)
            else {
                print("Can't decode!!!")
                return }
            
            self?.imagesData = []
            
            for result in jsonData.results {
                guard let url = URL(string: "https://api.unsplash.com/photos/" + result.id) else { return }
                
                NetworkService.shared.fetchDataFromURL(url) { singleImageData in
                    
                    guard let singleImageData = try? self?.decoder.decode(UnsplashImageData.self, from: singleImageData)
                    else {
                        print("Can't decode Single Image data!")
                        return }
                    
                    self?.imagesData.append(singleImageData)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchRandomPhotos()
    }
}
