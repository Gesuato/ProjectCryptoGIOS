//
//  ChangeUsernameViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData

class ChangeUsernameViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data:[Account] = []
    var defaults = UserDefaults.standard
    var alert:UIAlertController!
    var validation = ValidationClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Modifier le nom d'utilisateur"
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelChangeUserName(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        allValidation()
    }
    
    func allValidation(){
        let validationCurrentPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.passwordTextField.text!)
        let validationConfirmPassword = validation.validationConfirmPassword(password: self.passwordTextField.text!, confirmationPassword: self.passwordConfirmationTextField.text!)
        let validationNewUserName = validation.validationUserName(appDelegate: self.appDelegate, userName: self.userNameTextField.text!)
        
        if validationCurrentPassword == true && validationConfirmPassword == true && validationNewUserName == true{
            self.appDelegate.accountLogged.userName = userNameTextField.text
            self.appDelegate.saveContext()
            defaults.set(self.appDelegate.accountLogged.userName, forKey: "accountLogged")
            self.alert = UIAlertController(title: "Alerte !", message: "Le nom d'utilisateur a été change !", preferredStyle: .alert)
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
        
        let validationCurrentPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.passwordTextField.text!)
        let validationConfirmPassword = validation.validationConfirmPassword(password: self.passwordTextField.text!, confirmationPassword: self.passwordConfirmationTextField.text!)
        let validationNewUserName = validation.validationUserName(appDelegate: self.appDelegate, userName: self.userNameTextField.text!)
        
        if validationCurrentPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est incorret !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationConfirmPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La confirmation du mot de passe est incorret !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validationNewUserName == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Nom d'utilisateur invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboard(){
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
