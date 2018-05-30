//
//  Extensions.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 13/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
