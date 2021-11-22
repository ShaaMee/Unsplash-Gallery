//
//  RandomImageModel.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import Foundation

struct UnsplashImageData: Codable {
    let createdAt: Date
    let urls: Urls
    let user: User
    let location: Location
    let downloads: Int
}

// MARK: - Location
struct Location: Codable {
    let title: String?
}

// MARK: - Urls
struct Urls: Codable {
    let small: String
}

// MARK: - User
struct User: Codable {
    let name: String
}
