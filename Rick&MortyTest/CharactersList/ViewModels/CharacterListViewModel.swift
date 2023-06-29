//
//  CharacterListViewModel.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 29/6/23.
//

import Foundation
import UIKit

enum UnwindTransactionsAction {
    case refreshBalances
    case refreshButtons
    
    case none
}

protocol ObservableCharacterListProtocol {
    func getCharacterList(url:String,filterString: String)
    func getFavoriteList(idListString: String)
    
    var characterApiModel: Observable<(CharacterApiModel?, Error?)> { get set }
}

class CharacterListViewModel : NSObject, ObservableCharacterListProtocol {
    //MARK: - Requests
    func getCharacterList(url:String, filterString: String) {
        ApiService?.callApi(url, filterString: filterString, completionHandler:{ APIModel, error in
            if let list = self.characterApiModel.value.0?.results {
                self.characterApiModel.value.0?.info! = APIModel?.info ?? PaginationInfo()
                self.characterApiModel.value.0?.results! += APIModel?.results ?? []
            } else {
                self.characterApiModel.value = (APIModel, error)
            }
            
          })
    }
    
    func getFavoriteList(idListString: String) {
        ApiService?.callFavoritesApi(K.staticAPIUrl+idListString, completionHandler:{ charList, error in
            if let charList = charList {
                if charList.count > 0 {
                    print(charList)
                    self.characterApiModel.value.0 = CharacterApiModel()
                    self.characterApiModel.value.0?.results = charList
                }
            }
          })
    }
    
    func getFilterString(_ name:String?, _ status:String?, species:String?) -> String {
        var filterString = ""
        guard let name = name, let status = status, let species = species  else { return filterString}
        do {
            filterString += "?"
            if name != "" { filterString += "&name="+name}
            if status != "" { filterString += "&status="+status}
            if species != "" { filterString += "&species="+species }
          return filterString
        }
    }
    
    var characterApiModel: Observable<(CharacterApiModel?, Error?)>
    var ApiService: ObservableAPIProtocol?
    
    init(_ api: ObservableAPIProtocol){
        self.characterApiModel = Observable((nil, nil))
        self.ApiService = api
    }

}


