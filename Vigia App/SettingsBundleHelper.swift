//
//  SettingsBundleHelper.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 06/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let finalizarSessao = "finalizar_sessao"
    }
    
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.finalizarSessao) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.finalizarSessao)
            
            UserDefaults.standard.set(0, forKey: "user_id")
        }
    }
}
