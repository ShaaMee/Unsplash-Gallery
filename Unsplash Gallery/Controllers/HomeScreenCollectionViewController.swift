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
    
    private var randomImagesData: [UnsplashImageData] = [] {
        didSet {
            var imagesURLs = [String]()
            for image in randomImagesData {
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
    
    private let cellsInRowCount: CGFloat = 2.0
    private let cellsSpacing: CGFloat = 8.0
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(GalleryItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: cellsSpacing, left: cellsSpacing, bottom: cellsSpacing, right: cellsSpacing)
        collectionView.contentInsetAdjustmentBehavior = .automatic
                
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        guard let url = randomImagesRequestURL else { return }
        
        NetworkService.shared.fetchDataFromURL(url) { [weak self] data in
            
            guard let jsonData = try? self?.decoder.decode([UnsplashImageData].self, from: data)
            else {
                print("Can't decode data")
                return }
            self?.randomImagesData = jsonData
        }
    }

    // MARK:- UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLStrings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryItemCollectionViewCell
        
        cell.backgroundColor = .systemGray5
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryItemCollectionViewCell else { return }
        let detailsVC = DetailsViewController()
        detailsVC.imageData = randomImagesData[indexPath.row]
        detailsVC.image = cell.image
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}

extension HomeScreenCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewFrame = collectionView.frame
        let cellWidth = (collectionViewFrame.width - (cellsInRowCount - 1) * 2 - cellsSpacing * (cellsInRowCount + 1)) / cellsInRowCount
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
