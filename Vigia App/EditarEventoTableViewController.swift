//
//  EditarEventoTableViewCoTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

protocol EventDelegate: class {
    func getName(_ name: String)
}


class EditarEventoTableViewController: UITableViewController, PickerDelegate, EventDelegate {
    
    //MARK: - Variables
    var cells: [[EditarEventoTableViewCellType]]!
    var sectionsHeaders: [String?]!
    var evento: Evento?
    var convidados: [Convidado]?
    
    var nomeEvento: String?
    var unidadeID: Int?
    var data: Date?
    var horaInicio: String?
    var horaFim: String?
    var salvoPor: String?
    
    //Formaters
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    let hourFormatter: DateFormatter = {
        let hf = DateFormatter()
        hf.dateFormat = "HH:mm"
        return hf
    }()
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        if evento != nil {
            DataBase.ListaEventoManager.getConvidados(to: evento!.id!) { (convidados) in
                if convidados != nil {
                    self.convidados = convidados
                    self.cells[self.cells.count-1].insert(contentsOf: Array(repeating: EditarEventoTableViewCellType.convidado, count: convidados!.count), at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cells == nil {
            cells = [[.header],[.nomeEvento],[.dataEntrada,.horaEntrada,.horaSaida],[.convidado,.novoConvidado]]
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
    
    //MARK: - TableViewDelegate
    
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
            newCell.delegate = self
            if evento != nil {
                newCell.nomeDoEvento.text = evento?.nome
            } else {
                
                
            }
            cell = newCell
        case .pickerData:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? PickerDataTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            
            newCell.delegate = self
            newCell.row = indexPath.row
            newCell.delegate = self
            cell = newCell
        case .pickerHora:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? PickerHoraTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            newCell.delegate = self
            newCell.row = indexPath.row
            newCell.delegate = self
            cell = newCell
        case .dataEntrada:
            let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
            if evento != nil {
                newCell.detailTextLabel?.text = dateFormatter.string(from: (evento?.data)!)
            } else {
                newCell.detailTextLabel?.text = dateFormatter.string(from: Date())
            }
            cell = newCell
        case .horaEntrada:
            let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
            if evento != nil {
                let endIndex = evento!.horaInicio.index(evento!.horaInicio.endIndex, offsetBy: -4)
                newCell.detailTextLabel?.text = String((evento?.horaInicio[...endIndex])!)
            }
            cell = newCell
        case .horaSaida:
            let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
            if evento != nil {
                let endIndex = evento!.horaFim.index((evento?.horaFim.endIndex)!, offsetBy: -4)
                newCell.detailTextLabel?.text = String((evento?.horaFim[...endIndex])!)
            }
            cell = newCell
            
        case .convidado:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? ConvidadoTableViewCell else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            if convidados != nil {
                if convidados!.count > indexPath.row {
                    newCell.nome.text = convidados![indexPath.row].nome
                    newCell.rg.text = convidados![indexPath.row].rg
                }
            }
            cell = newCell
        default:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) else {
                fatalError("Impossible to dequeue the cell as \(cellType.rawValue)")
            }
            cell = newCell
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let cellType = cells[section][row]
        if cellType == .dataEntrada {
            if row == cells[section].count-1 {
                cells[section].insert(.pickerData, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: .automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            } else
                if cells[section][row+1] != .pickerData {
                    cells[section].insert(.pickerData, at: row+1)
                    tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: .automatic)
                    self.tableView.deselectRow(at: indexPath, animated: false)
                } else {
                    cells[section].remove(at: row+1)
                    tableView.deleteRows(at: [IndexPath(row: row+1, section: section)], with: .top)
                    self.tableView.deselectRow(at: indexPath, animated: false)
            }
        } else if cellType == .horaEntrada || cellType == .horaSaida {
            
            if row == cells[section].count-1 {
                cells[section].insert(.pickerHora, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: .automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            } else if cells[section][row+1] != .pickerHora {
                cells[section].insert(.pickerHora, at: row+1)
                tableView.insertRows(at: [IndexPath(row: row+1, section: section)], with: .automatic)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
                
            else {
                cells[section].remove(at: row+1)
                tableView.deleteRows(at: [IndexPath(row: row+1, section: section)], with: .top)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        } else if cellType == .novoConvidado {
            cells[cells.count - 1].insert(.convidado, at: row)
            tableView.insertRows(at: [IndexPath(row: row, section: cells.count - 1)], with: .automatic)
        } else if cellType == .convidado {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == cells.count - 1 && indexPath.row != cells[cells.count - 1].count-1 /*|| indexPath.row == 0 && cells[cells.count - 1].count != 2*/ {
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
        
        let alert = UIAlertController(title: nil, message: "Salvando...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        if evento != nil {
            
        } else {
            var nome: String!
            var data: String!
            var inicio: String!
            var fim: String!
            for i in 0..<cells.count {
                for j in 0..<cells[i].count {
                    switch cells[i][j] {
                    case .nomeEvento:
                        let indexPath = IndexPath(row: j, section: i)
                        guard let cell = tableView.cellForRow(at: indexPath) as? NomeDoEventoTableViewCell else {
                            fatalError("Impossible to downgrade the cell to a NomeDoEventoTableViewCell")
                        }
                        nome = cell.nomeDoEvento.text
                    case .dataEntrada:
                        let indexPath = IndexPath(row: j, section: i)
                        let cell = tableView.cellForRow(at: indexPath)
                        data = cell?.detailTextLabel?.text
                    case .horaEntrada:
                        let indexPath = IndexPath(row: j, section: i)
                        let cell = tableView.cellForRow(at: indexPath)
                        inicio = cell?.detailTextLabel?.text
                    case .horaSaida:
                        let indexPath = IndexPath(row: j, section: i)
                        let cell = tableView.cellForRow(at: indexPath)
                        fim = cell?.detailTextLabel?.text
                    default: break
                    }
                }
            }
            
            DataBase.MoradorManager.getUnidade(for: UserDefaults.standard.integer(forKey: "user_pessoas_id")) { (id) in
                DataBase.ListaEventoManager.create(nome: nome, unidadeid: id!, date: data, inicio: inicio, fim: fim, salvopor: UserDefaults.standard.integer(forKey: "user_credencial_id"), completion: { (didSave) in
                    //TODO: Salvar os convidados de uma festa
                    if didSave {
//                        for i in 0..<self.cells[self.cells.count-1].count-1{
//                            let indexPath = IndexPath(row: i, section: self.cells.count-1)
//                            guard let cell = self.tableView.cellForRow(at: indexPath) as? ConvidadoTableViewCell else {
//                                fatalError("Impossible to downgrade a TableViewCell to ConvidadeTableViewcell")
//                            }
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "dd/MM/yyyy"
//                            let datePlaceholder = dateFormatter.date(from: data)
//                            dateFormatter.dateFormat = "yyyy-MM-dd"
//                            let inicioLiberacao = dateFormatter.string(from: datePlaceholder)
//                            if !((cell.nome.text?.isEmpty)!) && !((cell.rg.text?.isEmpty)!) {
//                                let json: [String: Any] = ["nome": cell.nome.text,
//                                                           "sobrenome": "",
//                                                           "rg": cell.rg.text,
//                                                           "inicioliberacao": "\(inicioLiberacao) 10:00:00",
//                                    "fimliberacao": "\(inicioLiberacao) 10:00:00",
//                                    "diasliberacao": self.getDiasLiberacao(),
//                                    "horainicio": horarioInicio,
//                                    "horafim": horarioFim,
//                                    "unidades_id": id!,
//                                    "bases_id": String(UserDefaults().integer(forKey: "user_bases_id")),
//                                    "salvopor": UserDefaults().integer(forKey: "user_credencial_id"),
//                                    "auth": 0
//                                ]
//                                DataBase.PermissaoManager.create(json: json, completion: { (didSave) in
//                                    DispatchQueue.main.async {
//                                        alert.dismiss(animated: true, completion: {
//                                            if didSave {
//                                                if let delegate = self.delegate {
//                                                    delegate.didUpdatePermissao()
//                                                }
//                                                self.dismiss(animated: true, completion: nil)
//                                            } else {
//                                                let alert = UIAlertController(title: "Atenção", message: "Não foi possível salvar essa permissão.", preferredStyle: .alert)
//                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                                self.present(alert, animated: true)
//                                            }
//                                        })
//                                    }
//
//                                })
//                            }
//                        }
                    }
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: {
                            if didSave {
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func cancelarTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - PickerDelegate
    func didSelect(date: Date, on row: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: row-1, section: cells.count-2))
        let formatter = DateFormatter()
        if cells[cells.count - 2][row-1] == .dataEntrada || cells[cells.count - 2][row-1] == .dataSaida {
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "pt_BR")
        }
        
        cell?.detailTextLabel?.text = formatter.string(from: date)
        
        
        if cells[cells.count - 2][row-1] == .horaEntrada {
            self.horaInicio = formatter.string(from: date)
            
        } else if cells[cells.count - 2][row-1] == .horaSaida {
            self.horaFim = formatter.string(from: date)
        } else if cells[cells.count - 2][row-1] == .dataEntrada {
            self.data = date
        }
    }
    
    //MARK: - EventDelegate
    func getName(_ name: String) {
        self.nomeEvento = name
    }
    
}

enum EditarEventoTableViewCellType: String{
    case header, nomeEvento, dataEntrada, pickerData, dataSaida, horaEntrada, pickerHora, horaSaida, convidado, novoConvidado
}
