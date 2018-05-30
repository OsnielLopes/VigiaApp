//
//  NovaPermissaoTableViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 29/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

protocol NovaPermissaoDelegate {
    func didSave()
}

class NovaPermissaoTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Variables
    var permissao: Permissao!
    var delegate: NovaPermissaoDelegate!
    
    //MARK: - IBOutlets
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var rgTextField: UITextField!
    @IBOutlet weak var entradaDatePicker: UIDatePicker!
    @IBOutlet weak var dataEntradaCell: UITableViewCell!
    @IBOutlet weak var saidaDatePicker: UIDatePicker!
    @IBOutlet weak var dataSaidaCell: UITableViewCell!
    @IBOutlet weak var entradaHourPicker: UIDatePicker!
    @IBOutlet weak var horaEntradaCell: UITableViewCell!
    @IBOutlet weak var saidaHourPicker: UIDatePicker!
    @IBOutlet weak var horaSaidaCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeTextField.delegate = self
        nomeTextField.tag = 0
        rgTextField.delegate = self
        rgTextField.tag = 1
        
        entradaDatePicker.isHidden = true
        entradaDatePicker.minimumDate = Date()
        saidaDatePicker.isHidden = true
        saidaDatePicker.minimumDate = Date()
        entradaHourPicker.isHidden = true
        saidaHourPicker.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dataEntradaCell.detailTextLabel?.text = dateFormatter.string(from: Date())
        dataSaidaCell.detailTextLabel?.text = dateFormatter.string(from: Date())
        
        horaEntradaCell.detailTextLabel?.text = "08:00"
        horaSaidaCell.detailTextLabel?.text = "18:00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let permissao = self.permissao else {
            return
        }
        
        DataBase.PessoaManager.getNome(pessoaId: permissao.pessoasId) { (nome) in
            DispatchQueue.main.async {
                self.nomeTextField.text = nome
            }
        }
        
        DataBase.PessoaManager.getRG(pessoaId: permissao.pessoasId) { (rg) in
            DispatchQueue.main.async {
                self.rgTextField.text = rg
            }
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dataEntradaCell.detailTextLabel?.text = dateFormatter.string(from: permissao.inicioLiberacao)
        dataSaidaCell.detailTextLabel?.text = dateFormatter.string(from: permissao.fimLiberacao)
        
        horaEntradaCell.detailTextLabel?.text = permissao.horaFim
        horaSaidaCell.detailTextLabel?.text = permissao.horaInicio
        
        for i in 0..<permissao.diasLiberacao.count {
            if permissao.diasLiberacao[i] == "1" {
                let indexPath = IndexPath(row: i, section: 2)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                if let cell = self.tableView.cellForRow(at: indexPath){
                    cell.accessoryType = .checkmark
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let permissao = permissao else { return }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 8
        } else if section == 2 {
            return 7
        }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            
            if  indexPath.row == 1 {
                return entradaDatePicker.isHidden ? 0.0 : 162.0
            } else if indexPath.row == 3 {
                return saidaDatePicker.isHidden ? 0.0 : 162.0
            } else if indexPath.row == 5 {
                return entradaHourPicker.isHidden ? 0.0 : 162.0
            } else if indexPath.row == 7 {
                return saidaHourPicker.isHidden ? 0.0 : 162.0
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func deselectRow(){
            UIView.animate(withDuration: 0.3) {
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if entradaDatePicker.isHidden {
                    entradaDatePicker.isHidden = false
                    saidaDatePicker.isHidden = true
                    entradaHourPicker.isHidden = true
                    saidaHourPicker.isHidden = true
                } else {
                    entradaDatePicker.isHidden = true
                }
                deselectRow()
            } else if indexPath.row == 2 {
                if saidaDatePicker.isHidden {
                    entradaDatePicker.isHidden = true
                    saidaDatePicker.isHidden = false
                    entradaHourPicker.isHidden = true
                    saidaHourPicker.isHidden = true
                } else {
                    saidaDatePicker.isHidden = true
                }
                deselectRow()
            } else if indexPath.row == 4 {
                if entradaHourPicker.isHidden {
                    entradaDatePicker.isHidden = true
                    saidaDatePicker.isHidden = true
                    entradaHourPicker.isHidden = false
                    saidaHourPicker.isHidden = true
                } else {
                    entradaHourPicker.isHidden = true
                }
                deselectRow()
            } else if indexPath.row == 6 {
                if saidaHourPicker.isHidden {
                    entradaDatePicker.isHidden = true
                    saidaDatePicker.isHidden = true
                    entradaHourPicker.isHidden = true
                    saidaHourPicker.isHidden = false
                } else {
                    saidaHourPicker.isHidden = true
                }
                deselectRow()
            }
        } else if indexPath.section == 2 {
            if let cell = self.tableView.cellForRow(at: indexPath){
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let cell = self.tableView.cellForRow(at: indexPath){
                cell.accessoryType = .none
            }
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    @IBAction func salvarTapped(_ sender: Any) {
        
        print("salvar tapped")
        
        guard let nome = self.nomeTextField.text else {
            return
        }
        
        guard let rg = self.rgTextField.text else {
            return
        }
        
        guard let horarioInicio = self.horaEntradaCell.detailTextLabel?.text else {
            return
        }
        
        guard let horarioFim = self.horaSaidaCell.detailTextLabel?.text else {
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        DataBase.MoradorManager.getUnidade(for: UserDefaults().integer(forKey: "user_id"), completion: { id in
            
            print("DID GET THE USER ID")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: (self.dataEntradaCell.detailTextLabel?.text!)!)
            let inicioLiberacao = formatter.string(from: date!)
            
            let date2 = dateFormatter.date(from: (self.dataSaidaCell.detailTextLabel?.text!)!)
            let fimLiberacao = formatter.string(from: date2!)
            
            let json: [String: Any] = ["nome": nome,
                                       "rg": rg,
                                       "inicioliberacao": "\(inicioLiberacao) 10:00:00",
                "fimliberacao": "\(fimLiberacao) 10:00:00",
                "diasliberacao": self.getDiasLiberacao(),
                "horainicio": "\(horarioInicio):00",
                "horafim":"\(horarioFim):00",
                "unidades_id": id,
                "bases_id": String(UserDefaults().integer(forKey: "user_bases_id")),
                "salvopor": UserDefaults().integer(forKey: "user_id")
            ]
            DataBase.PermissaoManager.create(json: json, completion: { (didSave) in
                print("DID GET THE SAVE OR NOT RESPONSE")
                print(didSave)
            })
        })
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelarTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - IBActions
    
    @IBAction func entradaDatePickerDidChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dataEntradaCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    @IBAction func saidaDatePickerDidChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dataSaidaCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    @IBAction func entradaHourPickerDidChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        horaEntradaCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    @IBAction func saidaHourPickerDidChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        horaSaidaCell.detailTextLabel?.text = formatter.string(from: sender.date)
    }
    
    //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            rgTextField.becomeFirstResponder()
        } else {
            rgTextField.resignFirstResponder()
        }
        return false
    }
    
    //MARK: - Auxiliar Functions
    func getDiasLiberacao()->String{
        
            guard let indexPaths = self.tableView.indexPathsForSelectedRows else {
                return("0000000")
                
            }
            var dias = ""
            for cell in 0..<7{
                if indexPaths.contains(IndexPath(row: cell, section: 2)){
                    dias += "1"
                } else {
                    dias += "0"
                }
            }
            
            return(dias)
        
    }
    
    
    
    
}
