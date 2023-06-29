//
//  LocationInfoModel.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation

struct LocationInfoModel: Codable {
    var name: String?
    var url: String?
    


    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
       
    }
    
}
