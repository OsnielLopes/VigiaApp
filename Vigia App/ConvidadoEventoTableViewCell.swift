//
//  ConvidadoEnventoTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class ConvidadoEventoTableViewCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var rg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
