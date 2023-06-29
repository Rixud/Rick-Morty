//
//  CharacterModel.swift.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation

struct CharacterModel: Codable {
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: LocationInfoModel?
    var location: LocationInfoModel?
    var image: String?
    var episodes: [String]?
    var url: String?
    var date: String?


    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episodes = "episodes"
        case url = "url"
        case date = "date"
    }
    
}
