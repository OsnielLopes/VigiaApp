//
//  ListaDeFestaTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class ListaDeFestaTableViewCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var evento: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var horario: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
