//
//  CadastroViewController.swift
//  V8 Monitoramento
//
//  Created by Brendoon Ryos on 17/06/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rgTextField: UITextField!
    @IBOutlet weak var cpfTextField: UITextField!
    @IBOutlet weak var dataNascTextField: UITextField!
    @IBOutlet weak var telefone1TextField: UITextField!
    @IBOutlet weak var telefone2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cadastrarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cadastrarBtn.layer.cornerRadius = 20
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        
        rgTextField.delegate = self
        rgTextField.tag = 1
        
        cpfTextField.delegate = self
        cpfTextField.tag = 2
        
        dataNascTextField.delegate = self
        dataNascTextField.tag = 3
        
        telefone1TextField.delegate = self
        telefone1TextField.tag = 4
        
        telefone2TextField.delegate = self
        telefone2TextField.tag = 5
        
        emailTextField.delegate = self
        emailTextField.tag = 6

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CadastroViewController.keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CadastroViewController.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - IBActions
    @IBAction func cadastrarBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Atenção", message: "Insira o token referente ao seu condomínio:", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Verificar", style: .default, handler: { (action) in
            let loadingAlert = UIAlertController(title: nil, message: "Verificando...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = .gray
            loadingIndicator.startAnimating();
            loadingAlert.view.addSubview(loadingIndicator)
            DispatchQueue.main.async {
                self.present(loadingAlert, animated: true)
            }
            DataBase.CondominioManager.getCondominioForToken(token: (alert.textFields?.first?.text)!, completion: { (condCod) in
                DispatchQueue.main.async {
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
                guard let condCod = condCod else {
                    let alert = UIAlertController(title: "Atenção", message: "Token inválido!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                let alert = UIAlertController(title: "Atenção", message: "Token validado!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            rgTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            cpfTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            dataNascTextField.becomeFirstResponder()
        } else if textField.tag == 3 {
            telefone1TextField.becomeFirstResponder()
        } else if textField.tag == 4 {
            telefone2TextField.becomeFirstResponder()
        } else if textField.tag == 5 {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    //MARK: - Auxiliar Functions
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
}
