//
//  RandomImageModel.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import Foundation

struct UnsplashImageData: Codable {
    let id: String
    let createdAt, updatedAt, promotedAt: Date
    let width, height: Int
    let urls: Urls
    let likes: Int
    let likedByUser: Bool
    let user: User
    let location: Location
    let downloads: Int
}


// MARK: - Location
struct Location: Codable {
    let title, name, city, country: String?
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let name: String
}
