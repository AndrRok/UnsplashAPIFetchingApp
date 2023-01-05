//
//  RequestModel.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import Foundation

struct APIResponse: Codable, Hashable{
    let results: [imagesResult]
}


struct imagesResult: Codable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case  id, likes, user, updatedAt, urls }
    
    let id: String
    let likes: Int
    let updatedAt: Date
    let urls: URLS
    let user: UsersByRequest
}

extension imagesResult: Hashable{
    static func ==(lhs: imagesResult, rhs: imagesResult) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


struct UsersByRequest:Codable, Hashable{
    let username: String
    let links: linksOfUserForRequest
}


struct linksOfUserForRequest: Codable, Hashable{
    let html: String
}


struct URLS: Codable, Hashable{
    let thumb: String
    let small: String
}

