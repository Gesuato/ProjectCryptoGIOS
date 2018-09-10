//
//  RecoverPasswordWithUserNameViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-04.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData

class RecoverPasswordWithUserNameViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var userName: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let fetchRequest:NSFetchRequest<Account> = Account.fetchRequest()
    var data:[Account] = []
    var lostAccount = Account()
    var isValide:Bool = false
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        loadLostAccount()
        if isValide == true {
        performSegue(withIdentifier: "kModifyDataLostAccount", sender: self)
        }
        
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadLostAccount(){
        let context = self.appDelegate.persistentContainer.viewContext
        do{
            
            guard let userName = userName.text else {return}
            
            let criteria = NSPredicate(format: "userName == %@",userName)
            fetchRequest.predicate = criteria
            self.data = try context.fetch(fetchRequest)
            
            if self.data.count > 0 {
                self.lostAccount = self.data[0]
                isValide = true
            }else{
                self.alert = UIAlertController(title: "Alerte !", message: "Ce nom d'utilisateur n'a pas été trouvé!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                self.alert.addAction(okAction)
                self.present(self.alert, animated: true, completion: nil)
            }
            
        }catch{
                print("Fetching Courses Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kModifyDataLostAccount"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ModifyLostAccountDataViewController
            controller.lostAccount = self.lostAccount
        }
    }
    
    func hideKeyboard(){
        userName.resignFirstResponder()
    }
    
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    

}
