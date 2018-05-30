//
//  PermissaoViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 01/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit



class PermissaoViewController: UIViewController {
    
    var permissao: Permissao!
    
    //MARK: - IBOutlets
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var validade: UILabel!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var dias: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        DataBase.PessoaManager.getNome(pessoaId: permissao.pessoasId) { (nome) in
            DispatchQueue.main.async {
                self.nome.text = nome
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.validade.text! += " \(dateFormatter.string(from: permissao.inicioLiberacao)) a \(dateFormatter.string(from: permissao.fimLiberacao))"
        let hourFormatter = DateFormatter()
        hourFormatter.dateStyle = .none
        hourFormatter.timeStyle = .short
        self.horario.text! += " das \(permissao.horaInicio!) às \(permissao.horaFim!)"
        let nomeDias = permissao.getNomesDias()
        for i in 0..<nomeDias.count {
            if i != nomeDias.count-1 {
                self.dias.text! += " \(nomeDias[i]),"
            } else {
                self.dias.text! += " \(nomeDias[i])"
            }
            
        }
        
    }
    
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
        guard let navController = segue.destination as? UINavigationController else {
            fatalError("Impossible to convert the destination view controller as a UINavigationController")
        }
        guard let novaPermissaoTableViewController = navController.topViewController as? NovaPermissaoTableViewController else {
            fatalError("Impossible to convert the topViewController as a NovaPermissaoTableViewController")
        }
        novaPermissaoTableViewController.permissao = self.permissao
        novaPermissaoTableViewController.navigationItem.title = "Editar permissão"
    }

}
