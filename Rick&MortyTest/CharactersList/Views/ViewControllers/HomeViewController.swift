//
//  HomeViewController.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 28/6/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var logoGif: GifImageView!
    var viewModel: CharacterListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        logoGif.prepareForAnimation(withGIFNamed: "logo")
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoGif.animate(withGIFNamed: "logo")
        viewModel = CharacterListViewModel(API_RickMorty())
        viewModel?.getCharacterList(url: K.staticAPIUrl, filterString: "")
        logoGif.startAnimating()


    }
    
    @IBAction func openCatalogue(_ sender: Any) {
        performSegue(withIdentifier: "toCatalogue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toCatalogue" {
               if let vc = segue.destination as? SearchTableViewController{
                vc.viewModel = self.viewModel
               }
           }
       }


}



