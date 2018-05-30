//
//  PickerHoraTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PickerHoraTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var delegate: PickerDelegate!
    
    var row: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didSelect(_ sender: UIDatePicker) {
        self.delegate.didSelect(date: sender.date, on: row)
    }

}
