//
//  PermissaoViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 01/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PermissaoViewController: UIViewController, NovaPermissaoDelegate {
    
    var permissao: Permissao!
    
    //MARK: - IBOutlets
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var validade: UILabel!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var dias: UILabel!
    
    
    //MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        insertInfo()
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
        novaPermissaoTableViewController.delegate = self
    }
    
    //MARK: - NovaPermissaoDelegate
    func didUpdatePermissao() {
        DataBase.PermissaoManager.get(usuarioId: UserDefaults.standard.integer(forKey: "user_credencial_id")) { (permissoes) in
            for p in permissoes {
                if p.rg == self.permissao.rg && p.unidadesId == self.permissao.unidadesId {
                    self.permissao = p
                    self.insertInfo()
                    break
                }
            }
        }
    }
    
    //MARK: - Auxiliar Functions
    func insertInfo() {
        DispatchQueue.main.async {
            self.nome.text = self.permissao.nome
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.validade.text! = "Autorização válida de \(dateFormatter.string(from: self.permissao.inicioLiberacao)) a \(dateFormatter.string(from: self.permissao.fimLiberacao))"
            self.horario.text = "Horário permitido: das \(self.permissao.horaInicio!) às \(self.permissao.horaFim!)"
            let nomeDias = self.permissao.getNomesDias()
            self.dias.text = "Dias permitidos:"
            for i in 0..<nomeDias.count {
                if i != nomeDias.count-1 {
                    self.dias.text! += " \(nomeDias[i]),"
                } else {
                    self.dias.text! += " \(nomeDias[i])"
                    
                }
            }
        }
    }
    
}
