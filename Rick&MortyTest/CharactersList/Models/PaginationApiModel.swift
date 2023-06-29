//
//  PaginationApiModel.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation

struct CharacterApiModel: Codable {
    var info: PaginationInfo?
    var results: [CharacterModel]?
    


    
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
       
    }
    
}

struct PaginationInfo: Codable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
    


    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
       
    }
    
}
