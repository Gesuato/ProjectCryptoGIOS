//
//  SettingsViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchDarkMode: UISwitch!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    var alert:UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.appDelegate.isDarkMode == true{
            switchDarkMode.isOn = true
        }else{
            switchDarkMode.isOn =  false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func darkModeTapped(_ sender: Any) {
    
        if self.appDelegate.isLogged{
        if switchDarkMode.isOn{
        self.appDelegate.isDarkMode = true
        self.appDelegate.darkMode()
        defaults.set(self.appDelegate.isDarkMode, forKey: self.appDelegate.accountLogged.userName!)
        self.appDelegate.coinsFavorites.removeAll()
            
        self.alert = UIAlertController(title: "Alerte !", message: "L'application va redémarrer pour passer en mode noire !", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
        self.alert.addAction(okAction)
        self.present(self.alert, animated: true, completion: nil)
        }else{
        self.appDelegate.normalMode()
        self.appDelegate.isDarkMode = false
            defaults.set(self.appDelegate.isDarkMode, forKey: self.appDelegate.accountLogged.userName!)
            self.appDelegate.coinsFavorites.removeAll()
            
            self.alert = UIAlertController(title: "Alerte !", message: "L'application va redémarrer pour passer en mode normal !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
                
            }
            self.alert.addAction(okAction)
            self.present(self.alert, animated: true, completion: nil)
        }
            
        }else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
            if switchDarkMode.isOn{
                self.appDelegate.isDarkMode = true
                self.appDelegate.darkMode()
                defaults.set(self.appDelegate.isDarkMode, forKey: self.appDelegate.accountFacebookLogged.id!)
                self.appDelegate.coinsFavorites.removeAll()
                
                self.alert = UIAlertController(title: "Alerte !", message: "L'application va redémarrer pour passer en mode noire !", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                self.alert.addAction(okAction)
                self.present(self.alert, animated: true, completion: nil)
            }else{
                self.appDelegate.normalMode()
                self.appDelegate.isDarkMode = false
                defaults.set(self.appDelegate.isDarkMode, forKey: self.appDelegate.accountFacebookLogged.id!)
                self.appDelegate.coinsFavorites.removeAll()
                
                self.alert = UIAlertController(title: "Alerte !", message: "L'application va redémarrer pour passer en mode normal !", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (alert:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                    
                }
                self.alert.addAction(okAction)
                self.present(self.alert, animated: true, completion: nil)
        }
      }
    }
}
