//
//  FavoritesViewController.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    private let cellIdenetifier = "characterCell"
    @IBOutlet weak var charTable: UITableView!
    var viewModel: CharacterListViewModel?
    var favList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charTable.delegate = self
        charTable.dataSource = self
        favList = UserDefaults.standard.object(forKey: "myFavs") as? [Int] ?? []

        self.viewModel = CharacterListViewModel(API_RickMorty())
        charTable.backgroundColor = UIColor(named: "backgroundColor")
        self.registerTableViewCell()
        
        self.viewModel?.characterApiModel.bind { (bindResponse) in
            if bindResponse.0 != nil {
                self.showUpdatedViews()
            }else if bindResponse.1 != nil {
                self.showUpdatedViews()
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favList = UserDefaults.standard.object(forKey: "myFavs") as? [Int] ?? []
        print(favList)
        if favList.count !=  self.viewModel?.characterApiModel.value.0?.results?.count {
            updateCharacterList()
        }
        
    }
    
    
    private func showUpdatedViews() {
        DispatchQueue.main.async {
            self.charTable.reloadData()
        }
    }
    
    func updateCharacterList() {
        var favString = "/"
        for fav in favList {
            favString += "\(fav),"
        }
        callAPI(id: favString)
    }
    
    func registerTableViewCell(){
        let cell = UINib(nibName: "CharacterTableViewCell", bundle: nil)
        self.charTable.register(cell, forCellReuseIdentifier: cellIdenetifier)
    }
    
    func callAPI(id:String) {
        viewModel?.getFavoriteList(idListString: id)
    }
}




//MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel?.characterApiModel.value.0?.results?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenetifier, for: indexPath) as! CharacterTableViewCell
        cell.cellWidth.constant = tableView.frame.width
        if self.viewModel?.characterApiModel.value.0?.results?.count ?? 0 > 0 {
            if let charData = self.viewModel?.characterApiModel.value.0?.results?[indexPath.item] {
                cell.data = charData
            }
        }
        cell.selectedBackgroundView = .none
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Re-labelize all scrolling labels on tableview scroll
        for cell in charTable.visibleCells {
            if let cellCast = cell as? CharacterTableViewCell {
                cellCast.nameLabel.labelize = false
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell {
            cell.nameLabel.labelize = false
            let viewDetail = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            viewDetail.charData = self.viewModel?.characterApiModel.value.0?.results?[indexPath.item]
            self.navigationController?.pushViewController(viewDetail, animated: true)
        }

    }
}
//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell {
            cell.nameLabel.labelize = false
            cell.nameLabel.restartLabel()
        }

        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
