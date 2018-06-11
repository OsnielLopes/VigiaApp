//
//  MenuMoradorViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 02/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class MenuMoradorViewController: UIViewController {

    var superViewController: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func permissaoTapped(_ sender: UIButton) {
        superViewController.performSegue(withIdentifier: "toPermissao", sender: nil)
    }
    
    @IBAction func listaDeEventoTapped(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Atenção", message: "Está função está em processo de implementação e será liberada em breve!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true)
        superViewController.performSegue(withIdentifier: "toListaDeEvento", sender: nil)
    }
    
    @IBAction func historicoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Atenção", message: "Está função está em processo de implementação e será liberada em breve!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
//        superViewController.performSegue(withIdentifier: "toPermissao", sender: nil)
    }
    
    @IBAction func acionarPortaoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Atenção", message: "Está função está em processo de implementação e será liberada em breve!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
//        superViewController.performSegue(withIdentifier: "toCondominios", sender: nil)
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
