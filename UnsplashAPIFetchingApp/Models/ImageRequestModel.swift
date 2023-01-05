//
//  ImageRequestModel.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import Foundation


struct imageResult: Codable{
  
    let location: LocationData
    let downloads: Int?
}


struct LocationData: Codable, Hashable{
    let name: String?
   
}
