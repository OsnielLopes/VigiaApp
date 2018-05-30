//
//  PermissoesTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 01/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PermissoesTableViewController: UITableViewController {
    
    var permissoes = [Permissao]()
    
    override func viewWillAppear(_ animated: Bool) {
        let userId = UserDefaults.standard.integer(forKey: "user_id")
        DataBase.PermissaoManager.get(usuarioId: userId) { (p) in
            self.permissoes = p
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
        return permissoes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "permissao", for: indexPath)

        if let id = permissoes[indexPath.row].pessoasId {
            DataBase.PessoaManager.getNome(pessoaId: id) { (nome) in
                if let n = nome {
                    DispatchQueue.main.async {
                        cell.textLabel?.text = n
                    }
                }
            }
        }
    
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: - Como desativar uma permissao?
            let userId = UserDefaults.standard.integer(forKey: "user_id")
            
            DataBase.PermissaoManager.mudarStatus(pessoasId: permissoes[indexPath.row].pessoasId, salvopor: userId) { (completed) in
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
            permissaoViewController.permissao = permissoes[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }

}
