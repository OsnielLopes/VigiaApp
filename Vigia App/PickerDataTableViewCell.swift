//
//  PickerDataTableViewCell.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

protocol PickerDelegate {
    func didSelect(date: Date, on picker: Int)
}

class PickerDataTableViewCell: UITableViewCell {

    @IBOutlet weak var picker: UIDatePicker!
    
    var row: Int!
    
    var delegate: PickerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.minimumDate = Date()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didSelectData(_ sender: UIDatePicker) {
        self.delegate.didSelect(date: sender.date, on: row)
    }
    

}
