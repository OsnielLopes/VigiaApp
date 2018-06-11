//
//  PermissaoTableViewCell.swift
//  V8 Monitoramento
//
//  Created by Osniel Lopes Teixeira on 07/06/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PermissaoTableViewCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var rg: UILabel!
    @IBOutlet weak var periodo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
