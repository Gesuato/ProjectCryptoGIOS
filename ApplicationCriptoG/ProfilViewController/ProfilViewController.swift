//
//  ProfilViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import Photos
import FBSDKLoginKit
import FBSDKCoreKit

class ProfilViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewPhotoProfil: UIImageView!
    @IBOutlet weak var btnImageProfil: UIButton!
    @IBOutlet weak var btnDisconnection: UIButton!
    
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayTitlesTableView:[String] = ["Nom d'utilisateur :","Mot de passe :","Question secrète :", "Réponse secrète :"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if self.appDelegate.isLogged == false && FBSDKAccessToken.currentAccessTokenIsActive() == false{
        btnDisconnection.setTitle("Connexion", for: .normal)
        }else{
        btnDisconnection.setTitle("Se déconnecter", for: .normal)
        
        if self.appDelegate.isLogged == true{
         if let data = self.appDelegate.accountLogged.profilePicture as Data?{
           self.imageViewPhotoProfil.image = UIImage(data: data)
            }
        } else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
            if let data = self.appDelegate.accountFacebookLogged.profilPicture as Data?{
                self.imageViewPhotoProfil.image = UIImage(data: data)
            }
            }
     }
        
        
        self.btnImageProfil.layer.cornerRadius = 50
        self.btnImageProfil.layer.masksToBounds = true
        
        self.imageViewPhotoProfil.layer.cornerRadius = 50
        self.imageViewPhotoProfil.layer.masksToBounds = true
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDisconnectTapped(_ sender: Any) {
        
        if FBSDKAccessToken.currentAccessTokenIsActive() == true{
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        }
        
        self.appDelegate.isLogged = false
        self.appDelegate.isLoggedFacebook = false
        defaults.set(self.appDelegate.isLogged, forKey: "isLogged")
        defaults.removeObject(forKey: "accountLogged")
        self.appDelegate.coinsFavorites.removeAll()
        self.appDelegate.accountLogged = Account()
        self.appDelegate.accountFacebookLogged = AccountFacebook()
        self.appDelegate.normalMode()
        self.appDelegate.isDarkMode = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let title = cell.viewWithTag(1) as! UILabel
        let informationToChange = cell.viewWithTag(2) as! UILabel
        
        title.text = arrayTitlesTableView[indexPath.row]
        
        if self.appDelegate.isLogged == true{
        switch indexPath.row {
        case 0:
           informationToChange.text = self.appDelegate.accountLogged.userName!
           break;
        case 1:
            informationToChange.text = "*******"
            break;
        case 2:
            informationToChange.text = self.appDelegate.accountLogged.secretQuestion!
            break;
        case 3:
            informationToChange.text = "*******"
            break;
        default:
            break
        }
        }else if FBSDKAccessToken.currentAccessTokenIsActive() == true {
            if indexPath.row == 0{
              informationToChange.text = self.appDelegate.accountFacebookLogged.email
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.appDelegate.isLogged == true{
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "kchangeUsername", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "kchangePassword", sender: self)
            break
            
        case 2:
            performSegue(withIdentifier: "kchangeSecretQuestion", sender: self)
            break
            
        case 3:
            performSegue(withIdentifier: "kchangeSecretAnswer", sender: self)
            break
        default:
            break
        }
        }
    }
    @IBAction func btnChangePhotoProfilTapped(_ sender: Any) {
        if self.appDelegate.isLogged == true{
        checkPermission()
        }
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
}
extension ProfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageViewPhotoProfil.image = pickedImage
            self.appDelegate.accountLogged.profilePicture = UIImagePNGRepresentation(self.imageViewPhotoProfil.image!)
            self.appDelegate.saveContext()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
