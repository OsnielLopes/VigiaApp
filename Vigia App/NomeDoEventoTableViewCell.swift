//
//  NomeDoEventoTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class NomeDoEventoTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nomeDoEvento: UITextField!
    
    weak var delegate: EventDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nomeDoEvento.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text {
           delegate?.getName(name)
        }
        textField.resignFirstResponder()
        return false
    }

}
