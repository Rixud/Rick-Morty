//
//  API_RickMorty.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation

protocol ObservableAPIProtocol {
    func callApi(_ urlApi:String, filterString:String, completionHandler: @escaping (CharacterApiModel?, Error?) -> Void)
    
    func callFavoritesApi(_ urlApi:String, completionHandler: @escaping ([CharacterModel]?, Error?) -> Void)
}

class API_RickMorty:ObservableAPIProtocol {
    var stringURL:String = K.staticAPIUrl
    var APIModel : CharacterApiModel?
    
    
    func callApi(_ urlApi:String, filterString:String = "", completionHandler: @escaping (CharacterApiModel?, Error?) -> Void) {
        let url = URL(string: urlApi+filterString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        guard let data = data else { return }
        do {
            self.APIModel = try? JSONDecoder().decode(CharacterApiModel.self, from: data)
          if let APIModel = self.APIModel {
            completionHandler(APIModel, nil)
          }
          
        } catch let parseErr {
          print("JSON Parsing Error", parseErr)
            completionHandler(nil, parseErr)
        }
      })
      
      task.resume()
    }
    
    func callFavoritesApi(_ urlApi:String, completionHandler: @escaping ([CharacterModel]?, Error?) -> Void) {
        let url = URL(string: urlApi)!
        print(url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        guard let data = data else { return }
        do {
           let results = try? JSONDecoder().decode([CharacterModel].self, from: data)
            completionHandler(results, nil)
          
        } catch let parseErr {
          print("JSON Parsing Error", parseErr)
            completionHandler(nil, parseErr)
        }
      })
      
      task.resume()
    }
    
    
    func updateURLWithSearchBar (searchStr:String, perPage:String) {
        let strWithoutSpaces = searchStr.replacingOccurrences(of: " ", with: "_")
        stringURL = K.staticAPIUrl+"food="+strWithoutSpaces+"&per_page="+perPage
    }
    
    func updateURLWithPage(page:String, lastSearch:String, perPage:String) {
        if lastSearch.count != 0 {
            stringURL = K.staticAPIUrl+"food="+lastSearch+"&page="+page+"&per_page="+perPage
        } else {
            stringURL = K.staticAPIUrl+"page="+page+"&per_page="+perPage
        }
    }
    
}

