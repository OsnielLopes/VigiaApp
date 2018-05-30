 //
//  EditarEventoNavigationController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 30/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class EditarEventoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? EditarEventoTableViewController else {
            fatalError("Impossible to convert the destination view controller to EditarEventoTableViewController")
        }
        vc.navigationItem.title = "Editar Evento"
        vc.cells = [[.nomeEvento],[.dataEntrada,.dataSaida,.horaEntrada,.horaSaida],[.convidado,.novoConvidado]]
    }

}
