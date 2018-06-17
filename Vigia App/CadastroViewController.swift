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
        
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
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
