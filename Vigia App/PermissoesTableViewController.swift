//
//  PermissoesTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 01/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class PermissoesTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var permissoes = [Permissao]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPermissoes = [Permissao]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = UserDefaults.standard.integer(forKey: "user_credencial_id")
        DataBase.PermissaoManager.get(usuarioId: userId) { (p) in
            self.permissoes = p
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar permissão"
        searchController.searchBar.setValue("Cancelar", forKey: "_cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Nome", "Inicio Liberação"]
        searchController.searchBar.delegate = self
        
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
        if isFiltering() {
            return filteredPermissoes.count
        }
        return permissoes.count
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
        
        
        var permissao: Permissao!
        if isFiltering() {
            permissao = filteredPermissoes[indexPath.row]
        } else {
            permissao = permissoes[indexPath.row]
        }
        
        cell.nome.text = permissao.nome
        cell.rg.text = permissao.rg
        
        guard let inicioLiberacao = permissao.inicioLiberacao, let fimLiberacao = permissao.fimLiberacao else {
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
            let userId = UserDefaults.standard.integer(forKey: "user_pessoas_id")
            
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
            if isFiltering() {
                permissaoViewController.permissao = filteredPermissoes[((tableView.indexPathForSelectedRow?.row)!)]
            } else {
                permissaoViewController.permissao = permissoes[((tableView.indexPathForSelectedRow?.row)!)]
            }
        }
    }
    
    //MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    //MARK: - Auxiliar Functions
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Nome") {
        filteredPermissoes = permissoes.filter({( permissao : Permissao) -> Bool in
            if scope == "Nome" {
                return (permissao.nome?.lowercased().contains(searchText.lowercased()))!
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.string(from: permissao.inicioLiberacao).contains(searchText)
            }
            
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
