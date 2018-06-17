//
//  ListaDeEventoTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class ListaDeEventoTableViewController: UITableViewController {
    
    var eventos = [Evento]()
    
    override func viewWillAppear(_ animated: Bool) {
        DataBase.MoradorManager.getUnidade(for: UserDefaults.standard.integer(forKey: "user_pessoas_id"), completion: { (unidadeId) in
            DataBase.ListaEventoManager.get(salvopor: UserDefaults().integer(forKey: "user_credencial_id"), unidade: unidadeId!, completion: {(festas) in
                guard let festas = festas else { return }
                self.eventos = festas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        })
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
        return eventos.count+1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 217
        }
        return 88
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "festa", for: indexPath) as? ListaDeEventoTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "festa", for: indexPath)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            cell.data.text = dateFormatter.string(from: eventos[indexPath.row-1].data)
            cell.horario.text = eventos[indexPath.row-1].horaInicio
            cell.evento.text = eventos[indexPath.row-1].nome
            return cell
        }
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        self.performSegue(withIdentifier: "toEvento", sender: nil)
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let vc = segue.destination as? UINavigationController else {
            fatalError("Impossible to convert the destination view controller to UINavigationController")
        }
        guard let destinationVC = vc.topViewController as? EditarEventoTableViewController else {
            fatalError("Impossible to convert the top view controller to EditarEventoTableViewController")
        }
        destinationVC.navigationItem.title = "Editar Evento"
        destinationVC.cells = [[.nomeEvento],[.dataEntrada,.horaEntrada,.horaSaida],[.convidado,.novoConvidado]]
        destinationVC.sectionsHeaders = [nil,"Autorizar e Notificar", "Convidados"]
        destinationVC.evento = eventos[indexPath.row-1]
    }
}


