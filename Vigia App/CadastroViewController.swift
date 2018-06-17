//
//  CadastroViewController.swift
//  V8 Monitoramento
//
//  Created by Brendoon Ryos on 17/06/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
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
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.shootPhoto()
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action) in
            self.photoFromLibrary()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
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
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
            picker.mediaTypes = [mediaTypes.first] as! [String]
            present(picker, animated: true, completion: nil)
        }
    }
    
    func shootPhoto() {
        picker.allowsEditing = false
        picker.sourceType = .camera
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
            picker.mediaTypes = [mediaTypes.first] as! [String]
            present(picker, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Erro. Não conseguiu ler a image")
            dismiss(animated:true, completion: nil)
            return
        }
        
        imageView.image = chosenImage
        imageView.alpha = 1
        addPhotoBtn.isHidden = true
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
        print("Usuário cancelou")
    }
    
}
