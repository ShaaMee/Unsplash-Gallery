//
//  FavouritesTableViewCell.swift
//  Unsplash Gallery
//
//  Created by user on 22.11.2021.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    private var pictureView = UIImageView()
    
    var picture = UIImage() {
        didSet {
            pictureView.image = picture
            layoutSubviews()
        }
    }
    
    var artistNameLabel = UILabel()
    
    // MARK:- layoutSubviews()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK:- Setting up views

    private func setupViews() {
        pictureView.backgroundColor = .systemGray5
        pictureView.layer.cornerRadius = 8
        pictureView.contentMode = .scaleAspectFill
        pictureView.clipsToBounds = true
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(pictureView)
        contentView.addSubview(artistNameLabel)
    }
    
    // MARK:- Setting up constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            pictureView.widthAnchor.constraint(equalTo: pictureView.heightAnchor, multiplier: 1),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 16),
            artistNameLabel.centerYAnchor.constraint(equalTo: pictureView.centerYAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK:- Preparing cell for reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
    }
}
