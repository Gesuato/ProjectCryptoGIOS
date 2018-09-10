//
//  LoginViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var alertIncorrectAccount: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var alert:UIAlertController!
    
    var dataAccountCoreData:[Account] = []
    var dataAccountCoreDataFacebook:[AccountFacebook] = []
    let fetchRequest:NSFetchRequest<Account> = Account.fetchRequest()
    let fetchRequestFacebookAccount:NSFetchRequest<AccountFacebook> = AccountFacebook.fetchRequest()
    var defaults = UserDefaults.standard
    var userInfoFacebook = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLostPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "kRecoverPasswordWithUserName", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLogged()
    }
    
    @IBAction func btnLoginNotAccount(_ sender: Any) {
        self.appDelegate.normalMode()
        performSegue(withIdentifier: "kAccount", sender: self)
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        if loadAccount() == true{
            self.userNameTextField.text = ""
            self.passwordTextField.text = ""
            performSegue(withIdentifier: "kAccount", sender: self)
        }else{
           
            self.alert = UIAlertController(title: "Alerte !", message: "Nom d'utilisateur ou mot de passe invalide !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func btnLoginFacebookTapped(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
    
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self){(result,error) in
            
            if error != nil{
              
            }else if result!.isCancelled{
              
            }else{
                self.getUserinfoFacebook()
            }
        }
    }
    
    func getUserinfoFacebook(){
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,email,name,first_name,last_name,picture.type(large),gender,hometown,location"]);
        request?.start(completionHandler: {(connection,result,error) in
            if error == nil {
                self.userInfoFacebook = result as! NSDictionary
                print(self.userInfoFacebook)
                let userId:String = self.userInfoFacebook["id"] as! String
                let userEmail:String = self.userInfoFacebook["email"] as! String
                let userPicture = self.userInfoFacebook["picture"] as! [String:AnyObject]
                
                self.checkDarkMode(key: userId)
                
                for item in userPicture{
                    if item.value["url"] != nil{
                        print(item.value["url"] as! String)
                    self.getProfilPictureFacebook(url: item.value["url"] as! String)
                    }
                    break
                }
                
                self.getAccountFacebookInCoreData(id: userId,email: userEmail)
                
            }else{
                print("FB Error : \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func getProfilPictureFacebook(url:String){
        var picturePicture:UIImage?
        if let imageURL = URL(string: url){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                picturePicture = UIImage(data: data!)!
                self.appDelegate.accountFacebookLogged.profilPicture = UIImagePNGRepresentation((picturePicture)!)
                self.appDelegate.saveContext()
            }
        }
    }
    
    func getAccountFacebookInCoreData(id:String,email:String){
       let context = self.appDelegate.persistentContainer.viewContext
    
        do{
          let criteria = NSPredicate(format: "id == %@",id)
          fetchRequestFacebookAccount.predicate = criteria
          self.dataAccountCoreDataFacebook = try context.fetch(fetchRequestFacebookAccount)
            if self.dataAccountCoreDataFacebook.count > 0 {
                print("tem conta")
                self.appDelegate.accountFacebookLogged = dataAccountCoreDataFacebook[0]
                if self.appDelegate.accountFacebookLogged.favoriteCoins != nil{
                    
                    self.appDelegate.coinsFavorites.removeAll()
                    
                    for item in self.appDelegate.accountFacebookLogged.favoriteCoins!{
                        let favoriteCoinCoreData = item as! FavoriteCoin
                        let favoriteCoinDelegate = Coin()
                        favoriteCoinDelegate.coinName = favoriteCoinCoreData.coinName
                        favoriteCoinDelegate.symbol = favoriteCoinCoreData.symbol
                        favoriteCoinDelegate.imageUrl = favoriteCoinCoreData.imageUrl
                        favoriteCoinDelegate.conversionValueBRL = favoriteCoinCoreData.conversionValueBRL
                        favoriteCoinDelegate.conversionValueCAD = favoriteCoinCoreData.conversionValueCAD
                        
                        if let data = favoriteCoinCoreData.iconMoney as Data?{
                            favoriteCoinDelegate.iconMoney = UIImage(data: data)
                        }
                        self.appDelegate.coinsFavorites.append(favoriteCoinDelegate)
                    }
                    
                    self.appDelegate.getValueCoins()
                    self.appDelegate.getValueCoinsCurrentCountry()
                    performSegue(withIdentifier: "kAccount", sender: self)
                }
                
            }else{
                print("Nao tem conta")
                
                let accountFacebook = AccountFacebook(context: context)
                accountFacebook.id = id
                accountFacebook.email = email

                self.appDelegate.accountFacebookLogged = accountFacebook
                self.appDelegate.coinsFavorites.removeAll()
                self.appDelegate.saveContext()
                performSegue(withIdentifier: "kAccount", sender: self)
            }
        }catch{
            print("Error getAccountFacebookInCoreData")
        }
    }
    
    @IBAction func btnCreateAcountTapped(_ sender: Any) {
        performSegue(withIdentifier: "kCreateAccountLoguin", sender: self)
    }
    
    func loadAccount() -> Bool{
        var isValideAccount:Bool = false
        let context = self.appDelegate.persistentContainer.viewContext
        do{
            
          let userName = userNameTextField.text
          let  password = passwordTextField.text
            
            let criteria = NSPredicate(format: "userName == %@ AND password == %@",userName!,password!)
            fetchRequest.predicate = criteria
            self.dataAccountCoreData = try context.fetch(fetchRequest)
            
            if self.dataAccountCoreData.count > 0 {
                self.checkDarkMode(key: userName!)
                self.appDelegate.accountLogged = self.dataAccountCoreData[0]
                
                defaults.set(self.appDelegate.accountLogged.userName, forKey: "accountLogged")
                
                if self.appDelegate.accountLogged.favoritesCoins != nil{
                    
                    // Precisa remover tudo por que tava duplicando, o delegate continua cheio mesmo deslogando
                    self.appDelegate.coinsFavorites.removeAll()
                    
                    for item in self.appDelegate.accountLogged.favoritesCoins!{
                        let favoriteCoinCoreData = item as! FavoriteCoin
                        let favoriteCoinDelegate = Coin()
                        favoriteCoinDelegate.coinName = favoriteCoinCoreData.coinName
                        favoriteCoinDelegate.symbol = favoriteCoinCoreData.symbol
                        favoriteCoinDelegate.imageUrl = favoriteCoinCoreData.imageUrl
                        favoriteCoinDelegate.conversionValueBRL = favoriteCoinCoreData.conversionValueBRL
                        favoriteCoinDelegate.conversionValueCAD = favoriteCoinCoreData.conversionValueCAD
                        
                        if let data = favoriteCoinCoreData.iconMoney as Data?{
                          favoriteCoinDelegate.iconMoney = UIImage(data: data)
                        }
                
                        self.appDelegate.coinsFavorites.append(favoriteCoinDelegate)
                    }
                    
                    self.appDelegate.getValueCoins()
                    self.appDelegate.getValueCoinsCurrentCountry()
                    
                    self.appDelegate.isLogged = true
                    defaults.set(self.appDelegate.isLogged, forKey: "isLogged")
                    isValideAccount = true
                }
                
            }
          
        }
        catch{
            print("Fetching Courses Failed")
        }
        return isValideAccount
    }
    
    func loadAccountLogged(){
        
        let context = self.appDelegate.persistentContainer.viewContext
        do{
            var userName = ""
            if defaults.object(forKey: "accountLogged") != nil {
                userName = defaults.object(forKey: "accountLogged") as! String
            }
            
            let criteria = NSPredicate(format: "userName == %@",userName)
            fetchRequest.predicate = criteria
            self.dataAccountCoreData = try context.fetch(fetchRequest)
            
            if self.dataAccountCoreData.count > 0 {
                checkDarkMode(key: userName)
                self.appDelegate.accountLogged = self.dataAccountCoreData[0]
                
                if self.appDelegate.accountLogged.favoritesCoins != nil{
                    
                    for item in self.appDelegate.accountLogged.favoritesCoins!{
                        let favoriteCoinCoreData = item as! FavoriteCoin
                        let favoriteCoinDelegate = Coin()
                        favoriteCoinDelegate.coinName = favoriteCoinCoreData.coinName
                        favoriteCoinDelegate.symbol = favoriteCoinCoreData.symbol
                        favoriteCoinDelegate.imageUrl = favoriteCoinCoreData.imageUrl
                        favoriteCoinDelegate.conversionValueBRL = favoriteCoinCoreData.conversionValueBRL
                        favoriteCoinDelegate.conversionValueCAD = favoriteCoinCoreData.conversionValueCAD
                        
                        if let data = favoriteCoinCoreData.iconMoney as Data?{
                            favoriteCoinDelegate.iconMoney = UIImage(data: data)
                        }
                        
                        self.appDelegate.coinsFavorites.append(favoriteCoinDelegate)
                    }
                    
                    self.appDelegate.getValueCoins()
                    self.appDelegate.getValueCoinsCurrentCountry()
                }
            }
            
        }
        catch{
            print("Fetching Courses Failed")
        }
    }
    
    func checkDarkMode(key:String){
        if defaults.bool(forKey: key) == true {
            self.appDelegate.isDarkMode = defaults.bool(forKey: key)
            self.appDelegate.darkMode()
        }
    }
    
    func checkLogged(){
        if defaults.bool(forKey: "isLogged") == true {
            self.appDelegate.isLogged = defaults.bool(forKey: "isLogged")
            loadAccountLogged()
            performSegue(withIdentifier: "kAccount", sender: self)
        }else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
            getUserinfoFacebook()
        }
    }
    
    
    //MARK : KeyBoard Configuration // voltar quando clicar Return
    func hideKeyboard(){
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @IBAction func EndKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
