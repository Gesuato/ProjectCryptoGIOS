//
//  ChangePasswordViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData

class ChangePasswordViewController: UIViewController , UITextFieldDelegate {


    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var validation = ValidationClass()
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        currentPasswordTextField.delegate = self
        
        self.title = "Modifier le mot de passe"
    }

    @IBAction func btnDoneTapped(_ sender: Any) {
        allValidation()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func allValidation(){
        
        let validationCurrentPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.currentPasswordTextField.text!)
        let validationConfirmPassword = validation.validationConfirmPassword(password: self.newPasswordTextField.text!, confirmationPassword: self.passwordConfirmationTextField.text!)
        let validationNewPassword = validation.validationSizePassword(password: newPasswordTextField.text!)
        
        if validationCurrentPassword == true && validationConfirmPassword == true && validationNewPassword == true{
            self.appDelegate.accountLogged.password = newPasswordTextField.text
            self.appDelegate.saveContext()
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe a été change !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }else{
            alertError()
        }
    }
    
    func alertError(){
        let validationCurrentPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.currentPasswordTextField.text!)
        let validationConfirmPassword = validation.validationConfirmPassword(password: self.newPasswordTextField.text!, confirmationPassword: self.passwordConfirmationTextField.text!)
        let validationNewPassword = validation.validationSizePassword(password: newPasswordTextField.text!)
        
        if validationCurrentPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est incorret !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationConfirmPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La confirmation du nouveau mot de passe est incorret !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationNewPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est invalide, 6 caractère ou plus !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboard(){
        currentPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        passwordConfirmationTextField.resignFirstResponder()
    }
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}
