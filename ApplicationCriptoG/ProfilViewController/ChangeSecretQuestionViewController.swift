//
//  ChangeSecretQuestionViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit

class ChangeSecretQuestionViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var newSecretQuestionTextField: UITextField!
    @IBOutlet weak var secretAnswerTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var validation = ValidationClass()
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newSecretQuestionTextField.delegate = self
        self.secretAnswerTextField.delegate = self
        self.passwordTextField.delegate = self
        self.title = "Modifier la question secret"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        allValidation()
    }
    
    func allValidation(){
        
        let validationPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.passwordTextField.text!)
        let validationSecretAnswer = validation.validationSecretAnswerInLoggedAccount(appDelegate: self.appDelegate, secretAnswer: secretAnswerTextField.text!)
        let validationNewSecretQuestion = validation.validationSecretQuestion(secretQuestion: self.newSecretQuestionTextField.text!)
        
        if validationPassword == true && validationSecretAnswer == true && validationNewSecretQuestion == true{
            self.appDelegate.accountLogged.secretQuestion = newSecretQuestionTextField.text
            self.appDelegate.saveContext()
            self.alert = UIAlertController(title: "Alerte !", message: "La question secrète a été change !", preferredStyle: .alert)
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
        let validationPassword = validation.validationPasswordInAccountLogged(appDelegate: self.appDelegate, password: self.passwordTextField.text!)
        let validationSecretAnswer = validation.validationSecretAnswerInLoggedAccount(appDelegate: self.appDelegate, secretAnswer: secretAnswerTextField.text!)
        let validationNewSecretQuestion = validation.validationSecretQuestion(secretQuestion: self.newSecretQuestionTextField.text!)
        
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
        }else if validationNewSecretQuestion == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La nouvelle question secrète est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }    
    
    func hideKeyboard(){
        newSecretQuestionTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        secretAnswerTextField.resignFirstResponder()
    }
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
