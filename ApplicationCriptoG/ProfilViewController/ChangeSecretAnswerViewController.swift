//
//  ChangeSecretAnswerViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit

class ChangeSecretAnswerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newSecretAnswerTextField: UITextField!
    @IBOutlet weak var currentSecretAnswerTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var validation = ValidationClass()
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newSecretAnswerTextField.delegate = self
        currentSecretAnswerTextField.delegate = self
        currentPasswordTextField.delegate = self
        
        self.title = "Modifier la réponse secret"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnDoneTapped(_ sender: Any) {
        allValidation()
    }

    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func allValidation(){
        
        let validationNewSecretAnwer = validation.validationSecretAnswer(secretAnswer: newSecretAnswerTextField.text!)
        let validationSecretAnswer = validation.validationSecretAnswerInLoggedAccount(appDelegate: self.appDelegate, secretAnswer: currentSecretAnswerTextField.text!)
        let validationPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: currentPasswordTextField.text!)
        
        if validationSecretAnswer == true && validationPassword == true && validationNewSecretAnwer == true{
            self.appDelegate.accountLogged.secretAnswer = self.newSecretAnswerTextField.text
            self.appDelegate.saveContext()
            self.alert = UIAlertController(title: "Alerte !", message: "La réponse secrète a été change !", preferredStyle: .alert)
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
        let validationNewSecretAnwer = validation.validationSecretAnswer(secretAnswer: newSecretAnswerTextField.text!)
        let validationSecretAnswer = validation.validationSecretAnswerInLoggedAccount(appDelegate: self.appDelegate, secretAnswer: currentSecretAnswerTextField.text!)
        let validationPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: currentPasswordTextField.text!)
        
        if validationPassword == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est incorret !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }else if validationSecretAnswer == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La réponse secrète est incorrecte !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }else if validationNewSecretAnwer == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La nouvelle réponse secrète est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboard(){
        newSecretAnswerTextField.resignFirstResponder()
        currentSecretAnswerTextField.resignFirstResponder()
        currentPasswordTextField.resignFirstResponder()
    }
    
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
