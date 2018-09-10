//
//  modifyLostAccountDataViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData

class ModifyLostAccountDataViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var secretQuestionLabel: UILabel!
    @IBOutlet weak var secretAnswerTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmationNewPasswordTextField: UITextField!
    
    @IBOutlet weak var labelUserName: UILabel!
    
    var lostAccount = Account()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    var alert:UIAlertController!
    var validation = ValidationClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secretAnswerTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmationNewPasswordTextField.delegate = self
        
        self.secretQuestionLabel.text = lostAccount.secretQuestion
        labelUserName.text = ("Nom d'utilisateur : \(lostAccount.userName!)")
        
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
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        allValidation()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validationSecretAnswer() -> Bool{

        var isValideSecretAnswer:Bool = true

        if lostAccount.secretAnswer != secretAnswerTextField.text{
            isValideSecretAnswer = false
        }
        return isValideSecretAnswer
    }
    
    func allValidation(){
        let validationConfirmPassword = validation.validationConfirmPassword(password: newPasswordTextField.text!, confirmationPassword: confirmationNewPasswordTextField.text!)
        let validationSizePassword = validation.validationSizePassword(password: newPasswordTextField.text!)
        
        if validationConfirmPassword == true && validationSizePassword == true && validationSecretAnswer() == true {
            self.lostAccount.password = self.newPasswordTextField.text
            self.appDelegate.accountLogged = lostAccount
            self.appDelegate.isLogged = true
            defaults.set(self.appDelegate.isLogged, forKey: "isLogged")
            defaults.set(self.appDelegate.accountLogged.userName, forKey: "accountLogged")
            self.appDelegate.coinsFavorites.removeAll()
            self.appDelegate.saveContext()
            self.alert = UIAlertController(title: "Alerte !", message: "Informations modifiées avec succès !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
                self.performSegue(withIdentifier: "kLoggedLostAccount", sender: self)
            }
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else{
            alertError()
        }
    }

    func alertError(){
        
        var validation = ValidationClass()
        
        if validation.validationSecretQuestion(secretQuestion: secretAnswerTextField.text!) == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La réponse secrète est incorrecte !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validation.validationSizePassword(password: newPasswordTextField.text!) == false{
            self.alert = UIAlertController(title: "Alerte !", message: "Le mot de passe est invalide, 6 caractère ou plus !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }else if validation.validationConfirmPassword(password: newPasswordTextField.text!, confirmationPassword: confirmationNewPasswordTextField.text!) == false{
            self.alert = UIAlertController(title: "Alerte !", message: "La confirmation du mot de passe est invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
        
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
    
    func hideKeyboard(){
        secretAnswerTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmationNewPasswordTextField.resignFirstResponder()
    }
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

}
