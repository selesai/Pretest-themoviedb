//
//  Reviews.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

struct ReviewsArrayResponse: Codable, Equatable {
    let results: [Reviews]
}

struct Reviews: Codable, Equatable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content, id: String?
    let createdAt, updatedAt: Date?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable, Equatable {
    let name, username, avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
