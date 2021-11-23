//
//  SearchedImagesData.swift
//  Unsplash Gallery
//
//  Created by user on 23.11.2021.
//

import Foundation

struct SearchedImagesData: Codable {
    let results: [SearchResults]
}

struct SearchResults: Codable {
    let id: String
}
