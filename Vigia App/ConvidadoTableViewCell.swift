//
//  ConvidadoTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class ConvidadoTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var rg: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nome.delegate = self
        nome.tag = 0
        rg.delegate = self
        rg.tag = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            rg.becomeFirstResponder()
        } else {
            rg.resignFirstResponder()
        }
        return false
    }

}
