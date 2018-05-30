//
//  ContatoViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 29/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit
import MessageUI

class ContatoViewController: UIViewController {
    
    @IBOutlet weak var ligarButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ligarButton.layer.cornerRadius = 20
        emailButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ligarTapped(_ sender: UIButton) {
        guard let number = URL(string: "tel://11997953909") else {
            print("Erro ai criar URL do telefone")
            return
        }
        UIApplication.shared.open(number)
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        
        guard let email = URL(string: "mailto:contato@vigiaweb.com") else {
            fatalError("Erro ao criar URL de e-mail")
        }
        UIApplication.shared.open(email)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
