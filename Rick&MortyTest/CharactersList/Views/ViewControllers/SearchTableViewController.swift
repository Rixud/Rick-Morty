//
//  SearchTableViewController.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation
import UIKit

class SearchTableViewController: UIViewController {
    
    //MARK: Variables
    private let cellIdenetifier = "characterCell"
    private let cellIdenetifierPag = "pagCell"
    @IBOutlet weak var characterTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterImage: UIImageView!
    var lastSearch: String = ""
    //var lastFilter = FilterModel()
    var perPage: Int = 25
    var viewModel: CharacterListViewModel?
    var dynamicCharArray:[CharacterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterTable.delegate = self
        characterTable.dataSource = self
        searchBar.delegate = self

        //let filtersTapGesture = UITapGestureRecognizer(target: self, action: #selector(filtersTap(sender:)))
//        filterImage.isUserInteractionEnabled = true
//        filterImage.addGestureRecognizer(filtersTapGesture)
        
        characterTable.backgroundColor = UIColor(named: "backgroundColor")
        self.registerTableViewCell()
        if viewModel?.characterApiModel.value.0?.results == nil {
            callAPI(scroll: false)
        } else {
            dynamicCharArray = viewModel?.characterApiModel.value.0?.results ?? []
        }
        
        self.viewModel?.characterApiModel.bind { (bindResponse) in
            if bindResponse.0 != nil {
                self.showUpdatedViews()
            }else if bindResponse.1 != nil {
                self.showUpdatedViews()
            }
        }
    }
    
    private func showUpdatedViews() {
        DispatchQueue.main.async {
            self.dynamicCharArray = self.viewModel?.characterApiModel.value.0?.results ?? []
            self.characterTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
//    @objc func filtersTap(sender: UITapGestureRecognizer) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.controller = self
//            vc.lastFilter = self.lastFilter
//            self.present(vc, animated: false, completion: nil)
//        }
//    }
    
    func callAPI(scroll:Bool) {
        self.viewModel?.getCharacterList(url: K.staticAPIUrl, filterString: "")
    }
    
    private func getMoreCharacters(nextPageUrl:String){
        self.viewModel?.getCharacterList(url: nextPageUrl, filterString: "")
    }
    
    
    
    func registerTableViewCell(){
        let cell = UINib(nibName: "CharacterTableViewCell", bundle: nil)
        self.characterTable.register(cell, forCellReuseIdentifier: cellIdenetifier)
    }
    


}

//MARK: - UITableViewDataSource
extension SearchTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dynamicCharArray.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenetifier, for: indexPath) as! CharacterTableViewCell
        cell.cellWidth.constant = tableView.frame.width
        if dynamicCharArray.count > 0 {
            let character = dynamicCharArray[indexPath.item]
            cell.data = character
        }
        cell.selectedBackgroundView = .none
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Re-labelize all scrolling labels on tableview scroll
        for cell in characterTable.visibleCells {
            if let cellCast = cell as? CharacterTableViewCell {
                cellCast.nameLabel.labelize = false
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell {
            cell.nameLabel.labelize = false
            let viewDetail = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            viewDetail.charData = viewModel?.characterApiModel.value.0?.results?[indexPath.item]
            self.navigationController?.pushViewController(viewDetail, animated: true)
        }

    }
}
//MARK: - UITableViewDelegate
extension SearchTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell {
            cell.nameLabel.labelize = false
            cell.nameLabel.restartLabel()
        }

        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if dynamicCharArray.count ?? 0 >= 20 {
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.characterTable.tableFooterView = spinner
                self.characterTable.tableFooterView?.backgroundColor = UIColor(named: "backgroundColor")
                self.characterTable.tableFooterView?.isHidden = false
                print("SPINER MORE PLEASE")
                if let nextPageInfo = viewModel?.characterApiModel.value.0?.info?.next {
                    self.getMoreCharacters(nextPageUrl: nextPageInfo)
                }
            } else {
                self.characterTable.tableFooterView?.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension SearchTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        lastSearch = textDidChange
        dynamicCharArray = (textDidChange.isEmpty ? viewModel?.characterApiModel.value.0?.results : viewModel?.characterApiModel.value.0?.results?.filter  { (char: CharacterModel) -> Bool in
            return
            char.name?.lowercased().contains(textDidChange.lowercased()) ?? false
        }) ?? []
        characterTable.reloadData()
        
    }
}
