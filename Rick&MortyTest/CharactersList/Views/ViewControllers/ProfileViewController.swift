//
//  ProfileViewController.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 29/6/23.
//

import UIKit
class ProfileViewController: UIViewController {

    @IBOutlet weak var logoGif: GifImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoGif.animate(withGIFNamed: "logo")

        logoGif.startAnimating()

    }
    



}

