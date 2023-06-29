//
//  DetailViewController.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastKnowLabel: UILabel!
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var favImage: UIImageView!


    
    var charData:CharacterModel?
    var isFav: Bool = false
    var favList: [Int] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        favList = UserDefaults.standard.object(forKey: "myFavs") as? [Int] ?? []
        let favTapGesture = UITapGestureRecognizer(target: self, action: #selector(favTap(sender:)))
        favImage.isUserInteractionEnabled = true
        favImage.addGestureRecognizer(favTapGesture)
        updateUI()
        // Do any additional setup after loading the view.
        
    }
    
    func updateUI() {
        if let data = charData {
            if let URL = URL(string: data.image ?? "") {
                self.characterImage.kf.setImageWithRetry(with: URL)
            }
            nameLabel.text = data.name
            tagLabel.text = data.status
            lastKnowLabel.text = data.location?.name
            originButton.setTitle(data.location?.name, for: .normal)
            descriptionLabel.text = data.gender
            isFav = searchOnFavs()
            favImage.image = isFav ? UIImage(named:"removeFav") : UIImage(named:"addFav")
        }
    }
    
    @objc func favTap(sender: UITapGestureRecognizer) {
        isFav = !isFav
        favImage.image = isFav ? UIImage(named:"removeFav") : UIImage(named:"addFav")
        if isFav {
            favList.append(charData?.id ?? 1)
            UserDefaults.standard.set(favList, forKey: "myFavs")
        } else {
            favList = favList.filter { $0 != charData?.id }
            UserDefaults.standard.set(favList, forKey: "myFavs")
        }
        
    }
    
    func searchOnFavs() -> Bool {
        for fav in favList {
            if charData?.id == fav {
                return true
            }
        }
        return false

    }
    
    @IBAction func openDetail(_ sender: UIButton) {

    }
}
