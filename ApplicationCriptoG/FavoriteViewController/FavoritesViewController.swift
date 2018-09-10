//
//  FavoritesViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FavoritesViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var btnImageCanada: UIButton!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var btnImageBrl: UIButton!
    @IBOutlet weak var labelCAD: UILabel!
    @IBOutlet weak var labelBRL: UILabel!
    
    var refreshData : UIRefreshControl!
    
    var currentConversionCountryString:String = "CAD"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate.getValueCoins()
        self.favoritesTableView.reloadData()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        self.title = "Mes favoris"
        
        refreshData  = UIRefreshControl()
        refreshData.attributedTitle = NSAttributedString(string: "Actualiser les données")
        refreshData.addTarget(self, action: #selector(getValueCoinsRefreshData), for: .valueChanged)
        self.favoritesTableView.refreshControl = refreshData
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.getValueCoins()
        self.favoritesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.appDelegate.isLogged == true{
            if defaults.object(forKey: "currentConversionPaysString" + self.appDelegate.accountLogged.userName!) != nil {
                currentConversionCountryString = defaults.object(forKey: "currentConversionPaysString" + self.appDelegate.accountLogged.userName!) as! String
            }
            if currentConversionCountryString == "CAD"{
                btnCanadaTapped(self)
            }else{
                btnBrasilTapped(self)
            }
        }else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
            if defaults.object(forKey: "currentConversionPaysStringAccountFacebook" + self.appDelegate.accountFacebookLogged.id!) != nil {
                currentConversionCountryString = defaults.object(forKey: "currentConversionPaysStringAccountFacebook" + self.appDelegate.accountFacebookLogged.id!) as! String
            }
            if currentConversionCountryString == "CAD"{
                btnCanadaTapped(self)
            }else{
                btnBrasilTapped(self)
            }
            
        }
        
        self.appDelegate.getValueCoins()
        self.favoritesTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCanadaTapped(_ sender: Any) {
        btnImageBrl.setBackgroundImage(#imageLiteral(resourceName: "imageBrasilNotSelected"), for: UIControlState.normal)
        btnImageCanada.setBackgroundImage(#imageLiteral(resourceName: "imageCanada"), for: UIControlState.normal)
        labelCAD.textColor = UIColor.blue
        labelBRL.textColor = UIColor.black
        currentConversionCountryString = "CAD"
        saveCurrentConversionPaysStringInUsersDefauts()
        self.favoritesTableView.reloadData()
    }
    
    @IBAction func btnBrasilTapped(_ sender: Any) {
        btnImageCanada.setBackgroundImage(#imageLiteral(resourceName: "imageCanada NotSelected"), for: UIControlState.normal)
        btnImageBrl.setBackgroundImage(#imageLiteral(resourceName: "imageBrasil"), for: UIControlState.normal)
        labelBRL.textColor = UIColor.blue
        labelCAD.textColor = UIColor.black
        currentConversionCountryString = "BRL"
        
        saveCurrentConversionPaysStringInUsersDefauts()
        self.favoritesTableView.reloadData()
    }
    
    @IBAction func clickAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "kAdd", sender: self)
    }
    
    //MARK: TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.coinsFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFavorites", for: indexPath)
        
        let image = cell.contentView.viewWithTag(1) as! UIImageView
        let labelCurrencyConversionCountry = cell.contentView.viewWithTag(2) as! UILabel
        let labelNameMoney = cell.contentView.viewWithTag(3) as! UILabel
        let labelConversionValue = cell.contentView.viewWithTag(4) as! UILabel
        
        labelCurrencyConversionCountry.text = currentConversionCountryString
        labelNameMoney.text = self.appDelegate.coinsFavorites[indexPath.row].coinName
        
        
        if(self.currentConversionCountryString == "CAD"){
            if self.appDelegate.coinsFavorites[indexPath.row].conversionValueCAD != 0{
                labelConversionValue.text =  "CA$ \(self.appDelegate.coinsFavorites[indexPath.row].conversionValueCAD)"
            }
            
        }else{
            if self.appDelegate.coinsFavorites[indexPath.row].conversionValueBRL != 0{
                labelConversionValue.text =  "R$ \(self.appDelegate.coinsFavorites[indexPath.row].conversionValueBRL)"
            }
        }
        
        image.image = self.appDelegate.coinsFavorites[indexPath.row].iconMoney
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 //height for cell
    }
    
    
    // MARK : Editing
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let objectMove = self.appDelegate.coinsFavorites[fromIndexPath.row]
        self.appDelegate.coinsFavorites.remove(at: fromIndexPath.row)
        self.appDelegate.coinsFavorites.insert(objectMove, at: to.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing && !self.favoritesTableView.isEditing {
            self.favoritesTableView.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }else{
            self.favoritesTableView.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    
    // MARK: Remove
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoritesTableView.beginUpdates()
            self.favoritesTableView.deleteRows(at: [indexPath], with: .none)
            if self.appDelegate.isLogged == true {
                removeCoinCoreData(coinName: self.appDelegate.coinsFavorites[indexPath.row].coinName!)
            }else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
                removeCoinCoreDataFacebook(coinName: self.appDelegate.coinsFavorites[indexPath.row].coinName!)
            }
            
            self.appDelegate.coinsFavorites.remove(at: indexPath.row)
            self.favoritesTableView.endUpdates()
        }
    }
    
    func removeCoinCoreData(coinName:String){
        
        for item in self.appDelegate.accountLogged.favoritesCoins!{
            let coin = item as! FavoriteCoin
            if coin.coinName == coinName{
                self.appDelegate.accountLogged.removeFromFavoritesCoins(coin)
                break
            }
        }
        self.appDelegate.saveContext()
    }
    
    func removeCoinCoreDataFacebook(coinName:String){
        
        for item in self.appDelegate.accountFacebookLogged.favoriteCoins!{
            let coin = item as! FavoriteCoin
            if coin.coinName == coinName{
                self.appDelegate.accountFacebookLogged.removeFromFavoriteCoins(coin)
                break
            }
        }
        self.appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "La liste de favoris a \(self.appDelegate.coinsFavorites.count) item(s)"
    }
    
    // MARK
    
    
    func saveCurrentConversionPaysStringInUsersDefauts(){
        if self.appDelegate.isLogged == true{
            defaults.set(currentConversionCountryString, forKey: "currentConversionPaysString" + self.appDelegate.accountLogged.userName!)
        }else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
            defaults.set(currentConversionCountryString, forKey: "currentConversionPaysStringAccountFacebook" + self.appDelegate.accountFacebookLogged.id!)
        }
    }
    
    @objc func getValueCoinsRefreshData(){
        
        for value in self.appDelegate.coinsFavorites{
            
            DispatchQueue.main.async {
                let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(value.symbol!)&tsyms=CAD,BRL")
                URLSession.shared.dataTask(with:url!) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        do {
                            guard let data = data else{
                                return
                            }
                            
                            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Double]
                                else{
                                    return
                            }
                            
                            value.conversionValueCAD = json["CAD"]!
                            value.conversionValueBRL = json["BRL"]!
                            
                            DispatchQueue.main.async {
                                self.favoritesTableView.reloadData()
                                self.refreshData.endRefreshing()
                            }
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    }.resume()
            }
            
        }
    }
}
