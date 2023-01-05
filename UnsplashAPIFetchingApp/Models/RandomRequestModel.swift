//
//  RandomRequestModel.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import Foundation

struct RandomImagesResult: Codable, Hashable{
    let id: String
    let likes: Int
    let updatedAt: Date
    let urls: RandomURLS
    let user: UsersForRandom
}


struct UsersForRandom: Codable, Hashable{
    let username: String
    let links: linksOfUserForRandom
}


struct linksOfUserForRandom: Codable, Hashable{
    let html: String
}


struct RandomURLS: Codable, Hashable{
    let thumb: String
    let small: String
}

