//
//  CharacterTableViewCell.swift
//  Rick&MortyTest
//
//  Created by luisguerradm on 29/6/23.//
//

import UIKit
import MarqueeLabel

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var nameLabel: MarqueeLabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!

    
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    @IBOutlet weak var conceptWidth: NSLayoutConstraint!
    @IBOutlet weak var dateWidth: NSLayoutConstraint!
    
    var data: Codable? {
        didSet {
            self.updateUI()
        }
    }
    
    override required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           //commonInit()
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        
        if self.data != nil {
            if let dataCasted = data as? CharacterModel {
                if let URL = URL(string: dataCasted.image ?? "") {
                    self.statusImage.kf.setImageWithRetry(with: URL)
                }
                
                
                self.statusLabel.text = "\(dataCasted.status ?? "Unknow") "
                self.speciesLabel.text = "\(dataCasted.species ?? "Unknow")"
                self.nameLabel.text = dataCasted.name
                self.nameLabel.labelize = true
                self.nameLabel.restartLabel()
                
            }

        }
    }
    
}
