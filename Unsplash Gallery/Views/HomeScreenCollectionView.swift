//
//  HomeScreenView.swift
//  Unsplash Gallery
//
//  Created by user on 29.11.2021.
//

import UIKit

class HomeScreenCollectionView: UICollectionView {
    
    let cellsSpacing: CGFloat = 8.0
    let searchController = UISearchController(searchResultsController: nil)
    
    init(){
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        setUpCollectionView()
        setUpSearchController()
    }
    
    private func setUpCollectionView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        contentInset = UIEdgeInsets(top: cellsSpacing, left: cellsSpacing, bottom: cellsSpacing, right: cellsSpacing)
        contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setUpSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
    }
}
