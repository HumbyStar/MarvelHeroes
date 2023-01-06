//
//  HeroTableViewCell.swift
//  HeroisMarvel
//
//  Created by Humberto Rodrigues on 05/01/23.
//  Copyright © 2023 Eric Brito. All rights reserved.
//

import UIKit
import Kingfisher

class HeroTableViewCell: UITableViewCell {

    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with hero: Hero) {
        lbName.text = hero.name
        lbDescription.text = hero.description
        if let url = URL(string: hero.thumbnail.url) {
            ivThumbnail.kf.indicatorType = .activity
            ivThumbnail.kf.setImage(with: url)
        } else {
            ivThumbnail.image = nil
        }
        
        ivThumbnail.layer.cornerRadius = ivThumbnail.frame.size.height/2 //ARRENDONDAR
        ivThumbnail.layer.borderColor = UIColor.red.cgColor
        ivThumbnail.layer.borderWidth = 2
    
    }

}
