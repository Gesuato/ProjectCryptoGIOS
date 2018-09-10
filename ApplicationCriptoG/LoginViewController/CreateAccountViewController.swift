//
//  CreateAccountViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-29.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import Photos

class CreateAccountViewController: UIViewController ,UITextFieldDelegate {


    @IBOutlet weak var secretAnswerTextField: UITextField!
    @IBOutlet weak var secretQuestionTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var alertErrorLabel: UILabel!
    @IBOutlet weak var imageViewPhotoProfil: UIImageView!
    
    @IBOutlet weak var btnImageProfil: UIButton!
    var accounts : [Account] = []
    var isValideUserName:Bool = true
    var isValidePassword:Bool = false
    var isValideQuestion:Bool = false
    var isValideAnswer:Bool = false
    var alertMessageNumber:Int = 0
    var validation = ValidationClass()
    let defaults = UserDefaults.standard
    var alert:UIAlertController!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        textFieldPassword.delegate = self
        textFieldConfirmPassword.delegate = self
        secretQuestionTextField.delegate = self
        secretAnswerTextField.delegate = self
        
        
        self.btnImageProfil.layer.cornerRadius = 50.0
        self.btnImageProfil.layer.masksToBounds = true
        
        self.imageViewPhotoProfil.layer.cornerRadius = 50.0
        self.imageViewPhotoProfil.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillChangeFrame,object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnGetPhotoProfilTapped(_ sender: Any) {
        checkPermission()
    }
    
    func checkPermission() {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = UIImagePickerControllerSourceType.photoLibrary
                image.allowsEditing = true
                self.present(image, animated: true, completion: nil)
                
            } else {
                
            }
        })
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnConfirmAccountTapped(_ sender: Any) {
        if validateAllAttributesForToCreateTheAccount() == true{
            self.alert = UIAlertController(title: "Alerte !", message: "Le compte est créer !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            }
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else{
            alertErrorCreateAccount()
        }
    }
    
    func validateAllAttributesForToCreateTheAccount() -> Bool{
        
        var isValide:Bool = false
        let validationUserName:Bool = validation.validationUserName(appDelegate: appDelegate, userName: userNameTextField.text!)
        let validationPassword:Bool = validation.validationSizePassword(password: textFieldPassword.text!)
        let validationSecretQuestion:Bool = validation.validationSecretQuestion(secretQuestion: secretQuestionTextField.text!)
        let validationSecretAnswer:Bool = validation.validationSecretAnswer(secretAnswer: secretAnswerTextField.text!)
        let validationConfirmPassword:Bool = validation.validationConfirmPassword(password: textFieldPassword.text!, confirmationPassword: textFieldConfirmPassword.text!)
        
        if validationUserName == true && validationPassword == true && validationSecretQuestion == true && validationSecretAnswer == true && validationConfirmPassword == true{
            createAccount(userName: userNameTextField.text!, password: textFieldPassword.text!,secretQuestion: secretQuestionTextField.text!,secretAnswer: secretAnswerTextField.text!)
            isValide = true
        }
        return isValide
    }
    
    func alertErrorCreateAccount(){

        let validationUserName:Bool = validation.validationUserName(appDelegate: appDelegate, userName: userNameTextField.text!)
        let validationPassword:Bool = validation.validationSizePassword(password: textFieldPassword.text!)
        let validationSecretQuestion:Bool = validation.validationSecretQuestion(secretQuestion: secretQuestionTextField.text!)
        let validationSecretAnswer:Bool = validation.validationSecretAnswer(secretAnswer: secretAnswerTextField.text!)
        let validationConfirmPassword:Bool = validation.validationConfirmPassword(password: textFieldPassword.text!, confirmationPassword: textFieldConfirmPassword.text!)
        
        if validationUserName == false{
            
            self.alert = UIAlertController(title: "Alerte !", message: "Nom d'utilisateur invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est invalide, 6 caractère ou plus !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationConfirmPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La confirmation de mot de passe est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationSecretQuestion == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La question secrète est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationSecretAnswer == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La réponse secrète est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }
    }
    
    
    // MARK : Keyboard

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()

        return true
    }
    
    func hideKeyboard(){
        userNameTextField.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldConfirmPassword.resignFirstResponder()
        secretAnswerTextField.resignFirstResponder()
        secretQuestionTextField.resignFirstResponder()
        
    }
    @IBAction func EndKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
        view.frame.origin.y = -keyboardRect.height
        }else{
          view.frame.origin.y = 0
        }
 
    }
    
    func createAccount(userName:String, password:String, secretQuestion:String, secretAnswer:String){
        let context = self.appDelegate.persistentContainer.viewContext
        
        let account = Account(context: context)
        account.userName = userName
        account.password = password
        account.secretQuestion = secretQuestion
        account.secretAnswer = secretAnswer
        account.profilePicture = UIImagePNGRepresentation(self.imageViewPhotoProfil.image!)
        self.appDelegate.accountLogged = account
        self.appDelegate.isLogged = true
        defaults.set(self.appDelegate.isLogged, forKey: "isLogged")
        defaults.set(self.appDelegate.accountLogged.userName, forKey: "accountLogged")
        self.appDelegate.coinsFavorites.removeAll()
        self.appDelegate.saveContext()
    }

}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageViewPhotoProfil.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
