//
//  PermissoesTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 01/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PermissoesTableViewController: UITableViewController {
    
    var permissoes = [(Permissao, nome: String, rg: String)]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        let userId = UserDefaults.standard.integer(forKey: "user_credencial_id")
        DataBase.PermissaoManager.get(usuarioId: userId) { (p) in
            for i in 0..<p.count {
                DataBase.PessoaManager.getNome(pessoaId: p[i].pessoasId) { (nome) in
                    if let n = nome {
                        DataBase.PessoaManager.getRG(pessoaId: p[i].pessoasId) { (rg) in
                            if let rg = rg {
                                self.permissoes.append((p[i], nome: n, rg: rg))
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return permissoes.count //+ 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 //indexPath.row == 0 ? 281 : 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let bannerCell = tableView.dequeueReusableCell(withIdentifier: "banner")
//            return bannerCell!
//        }
        guard permissoes.count > 0 else  { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "permissao", for: indexPath) as? PermissaoTableViewCell else {
            fatalError("Incapable of dequeueing a UITableViewCell to PermissaoTableViewCell")
        }
        
        cell.nome.text = permissoes[indexPath.row].nome
        cell.rg.text = permissoes[indexPath.row].rg
        
//        if let id = permissoes[indexPath.row].pessoasId {
//            //TODO: Criar uma única requisição que retorne nome e rg
//            DataBase.PessoaManager.getNome(pessoaId: id) { (nome) in
//                if let n = nome {
//                    DispatchQueue.main.async {
//                        cell.nome.text = n
//                    }
//                }
//            }
//            DataBase.PessoaManager.getRG(pessoaId: id) { (rg) in
//                if let rg = rg {
//                    DispatchQueue.main.async {
//                        cell.rg.text = rg
//                    }
//                }
//            }
//        } else {
//            fatalError("Impossible to get the id for the \(indexPath.row)th permission")
//        }
        
        guard let inicioLiberacao = permissoes[indexPath.row].0.inicioLiberacao, let fimLiberacao = permissoes[indexPath.row].0.fimLiberacao else {
            fatalError("Impossible to get the initial or final date for the \(indexPath.row)th permission")

        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        cell.periodo.text = " \(dateFormatter.string(from: inicioLiberacao)) a \(dateFormatter.string(from: fimLiberacao))"
    
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: - Como desativar uma permissao?
            let userId = UserDefaults.standard.integer(forKey: "user_pessoas_id")
            
            DataBase.PermissaoManager.mudarStatus(pessoasId: permissoes[indexPath.row].0.pessoasId, salvopor: userId) { (completed) in
                if completed {
                    self.permissoes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Deletar"
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let permissaoViewController = segue.destination as? PermissaoViewController {
            permissaoViewController.permissao = permissoes[((tableView.indexPathForSelectedRow?.row)!)].0
        }
        
    }

}
