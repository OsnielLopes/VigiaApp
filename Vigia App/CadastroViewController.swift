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
    @IBOutlet weak var sobrenomeTextField: UITextField!
    @IBOutlet weak var apelidoTextField: UITextField!
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
        
        guard let dataNascimento = self.dataNascTextField.text else{
            print("Data de nascimento invalida")
            return
        }
        
        //yyyy/mm/dd
        let separator1 = dataNascimento.index(dataNascimento.startIndex, offsetBy: 4)
        let separator2 = dataNascimento.index(separator1, offsetBy: 3)
        if dataNascimento[separator1] != "-" || dataNascimento[separator2] != "-"{
            let alert = UIAlertController(title: "Atenção", message: "A data de nascimento deve seguir o formato aaaa-mm-dd", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        } else {
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
                    
                    //                var imgString: String?
                    //                if let imageData = UIImagePNGRepresentation(self.imageView.image!) {
                    //                    imgString = imageData.base64EncodedString()
                    //                }
                    var indexEndOfText: String.Index!
                    var name: String!
                    var rg: String!
                    var senha: String!
                    DispatchQueue.main.async {
                        indexEndOfText = self.nameTextField.text!.index((self.nameTextField.text?.startIndex)!, offsetBy: 4)
                        name = self.nameTextField.text!
                        rg = self.rgTextField.text!
                        let senhaA = name[..<indexEndOfText]
                        let senhaB = rg[..<indexEndOfText]
                        senha = String(senhaA)+String(senhaB)
                    }
                    
                    DataBase.UnidadeManager.getUnidades(for: condCod, completion: { (unidades) in
                        guard let unidades = unidades else {
                            fatalError("Impossible to get unidades")
                        }
                        let json: [String: Any] = ["nome": name,
                                                   "sobrenome": self.sobrenomeTextField.text!,
                                                   "apelido": self.apelidoTextField.text!,
                                                   "rg": rg,
                                                   "DATANAS": "\(self.dataNascTextField.text!) 10:00:00",
                            "telefone1": self.telefone1TextField.text,
                            "telefone2": self.telefone2TextField.text,
                            "email": self.emailTextField.text,
                            "cpf": self.cpfTextField.text,
                            "condCod": condCod,
                            "bloco": unidades.first?.bloco,
                            "unidade": unidades.first?.unidade,
                            "usuario": self.rgTextField.text,
                            "senha": senha
                        ]
                        
                        DataBase.PermissaoManager.createMorador(with: json, completion: { (didSave) in
                            if didSave != nil {
                                if didSave! {
                                    print("MORADOR CRIADO")
                                } else {
                                    print("nao foi possivel criar Morador")
                                }
                            } else {
                                print("nao foi possivel criar Morador")
                            }
                            let alert = UIAlertController(title: "Atenção", message: "Cadastro realizado!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { (action) in
                                DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: nil)
                                }
                            }))
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                        
                    })
                })
            }))
            alert.addTextField(configurationHandler: nil)
            present(alert, animated: true, completion: nil)
        }
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
