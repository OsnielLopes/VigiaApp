//
//  MenuVisitanteViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 02/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class MenuVisitanteViewController: UIViewController {
    
    @IBOutlet weak var acionarPortao: UIButton!
    
    var superViewController: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acionarPortao.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acionarPortaoTapped(_ sender: UIButton) {
        superViewController.performSegue(withIdentifier: "toCondominios", sender: nil)
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
