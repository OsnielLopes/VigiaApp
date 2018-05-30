//
//  EditarEventoTableViewCoTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class EditarEventoTableViewController: UITableViewController, PickerDelegate {
    
    var cells: [[EditarEventoTableViewCellType]]!
    var sectionsHeaders: [String?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cells == nil {
            cells = [[.header],[.nomeEvento],[.dataEntrada,.dataSaida,.horaEntrada,.horaSaida],[.convidado,.novoConvidado]]
        }
        
        if sectionsHeaders == nil {
            sectionsHeaders = [nil,nil,"Autorizar e Notificar", "Convidados"]
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.section][indexPath.row] {
        case .header:
            return 225
        case .pickerData, .pickerHora:
            return 216
        case .convidado:
            return 88
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeaders[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType: EditarEventoTableViewCellType = cells[indexPath.section][indexPath.row]
        
        var cell: UITableViewCell!
        switch cellType {
        case .nomeEvento:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? NomeDoEventoTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            cell = newCell
        case .pickerData:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? PickerDataTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            newCell.row = indexPath.row
            newCell.delegate = self
            cell = newCell
        case .pickerHora:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? PickerHoraTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            newCell.row = indexPath.row
            newCell.delegate = self
            cell = newCell
        default:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            cell = newCell
        }
        
        if cellType == .dataEntrada || cellType == .dataSaida {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            cell.detailTextLabel?.text = formatter.string(from: Date())
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let cellType = cells[section][row]
        if cellType == .dataEntrada || cellType == .dataSaida {
            if row == cells[section].count-1 {
                cells[section].insert(.pickerData, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            } else
                if cells[section][row+1] != .pickerData {
                    cells[section].insert(.pickerData, at: row+1)
                    tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.automatic)
                    self.tableView.deselectRow(at: indexPath, animated: false)
                } else {
                    cells[section].remove(at: row+1)
                    tableView.deleteRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.top)
                    self.tableView.deselectRow(at: indexPath, animated: false)
            }
        } else if cellType == .horaEntrada || cellType == .horaSaida {
            
            if row == cells[section].count-1 {
                cells[section].insert(.pickerHora, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            } else if cells[section][row+1] != .pickerHora {
                cells[section].insert(.pickerHora, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
                
            else {
                cells[section].remove(at: row+1)
                tableView.deleteRows(at: [IndexPath(row: row+1, section: section)], with: UITableViewRowAnimation.top)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        } else if cellType == .novoConvidado {
            cells[cells.count - 1].insert(.convidado, at: row)
            tableView.insertRows(at: [IndexPath(row: row, section: cells.count - 1)], with: .automatic)
        }

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == cells.count - 1 && indexPath.row != cells[cells.count - 1].count-1 || indexPath.row == 0 && cells[cells.count - 1].count != 2 {
                return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cells[cells.count - 1].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func salvarTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelarTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //PickerDelegate
    func didSelect(date: Date, on row: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: row-1, section: 2))
        let formatter = DateFormatter()
        if cells[cells.count - 2][row-1] == .dataEntrada || cells[2][row-1] == .dataSaida {
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "pt_BR")
        }
        
        cell?.detailTextLabel?.text = formatter.string(from: date)
    }
    
}

enum EditarEventoTableViewCellType: String{
    case header, nomeEvento, dataEntrada, pickerData, dataSaida, horaEntrada, pickerHora, horaSaida, convidado, novoConvidado
}
