//
//  GalleryItemCollectionViewCell.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    let activityIndicator = UIActivityIndicatorView()
    
    private var imageView = UIImageView(frame: .zero) {
        didSet { layoutSubviews() }
    }
    
    var image: UIImage? {
        didSet {
            guard let image = image else {
                imageView.image = nil
                imageView.layoutSubviews()
                return
            }
            imageView = UIImageView(image: image)
        }
    }
    
    // MARK: - layoutSubviews()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setting up views
    
    private func setupViews() {
        setupMainView()
        setupImageView()
        setupActivityIndicator()
    }
    
    private func setupMainView(){
        layer.cornerRadius = 16
        backgroundColor = .systemGray5
        clipsToBounds = true
    }
    
    private func setupImageView(){
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }
    
    private func setupActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        contentView.addSubview(activityIndicator)
    }
    
    // MARK: - Setting up constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    // MARK: - Preparing cell for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
