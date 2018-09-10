//
//  AddTableViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Kingfisher

class AddTableViewController: UITableViewController,UISearchBarDelegate {
    
    var coinsFilter = [Coin]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayImages:[UIImageView] = []
    var isEqualsMoney:Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    struct MoneyBRL:Codable {
        var BRL:Double
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        coinsFilter = appDelegate.coins
        self.title = "Ajouter une devise"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsFilter.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let imageCell = cell.contentView.viewWithTag(1) as! UIImageView
        let moneyName = cell.contentView.viewWithTag(2) as! UILabel
    
        if appDelegate.coins[indexPath.row].imageUrl != nil{
            let urlImage = "https://www.cryptocompare.com\(String(describing: coinsFilter[indexPath.row].imageUrl!))"
            let imageURL = URL(string: urlImage)
            imageCell.kf.setImage(with: imageURL)
        }
        
        moneyName.text = coinsFilter[indexPath.row].coinName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for value in self.appDelegate.coinsFavorites{
            if value.coinName == self.coinsFilter[indexPath.row].coinName{
                isEqualsMoney = true
                break
            }
        }
        
        if isEqualsMoney == false{
            if self.appDelegate.isLogged == true{
            saveFavoriteCoinInCoredata(index: indexPath.row)
            } else if FBSDKAccessToken.currentAccessTokenIsActive() == true{
                saveFavoriteCoinFacebookInCoredata(index: indexPath.row)
            }
            let urlImage = "https://www.cryptocompare.com\(String(describing: self.coinsFilter[indexPath.row].imageUrl!))"
            let imageURL = URL(string: urlImage)
            let data = try? Data(contentsOf: imageURL!)
            self.coinsFilter[indexPath.row].iconMoney = UIImage(data: data!)
            self.appDelegate.coinsFavorites.insert(self.coinsFilter[indexPath.row], at: 0)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "La liste des devises a \(self.coinsFilter.count) item(s)"
    }
    
    @IBAction func ClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveFavoriteCoinInCoredata(index:Int){
        
        if coinsFilter[index].imageUrl != nil{
            DispatchQueue.global().async {
                let urlImage = "https://www.cryptocompare.com\(String(describing: self.coinsFilter[index].imageUrl!))"
                let imageURL = URL(string: urlImage)
                let data = try? Data(contentsOf: imageURL!)
                self.coinsFilter[index].iconMoney = UIImage(data: data!)
                
                if self.coinsFilter[index].iconMoney != nil{
                    let favoriteCoreData = FavoriteCoin(context: self.appDelegate.persistentContainer.viewContext)
                    favoriteCoreData.coinName = self.coinsFilter[index].coinName
                    favoriteCoreData.symbol = self.coinsFilter[index].symbol
                    favoriteCoreData.imageUrl = self.coinsFilter[index].imageUrl
                    favoriteCoreData.iconMoney = UIImagePNGRepresentation(self.coinsFilter[index].iconMoney!)
                    self.appDelegate.accountLogged.addToFavoritesCoins(favoriteCoreData)
                    self.appDelegate.saveContext()
                }
                
            }
        }
        
    }
    
    func saveFavoriteCoinFacebookInCoredata(index:Int){        
        if coinsFilter[index].imageUrl != nil{
            DispatchQueue.global().async {
                let urlImage = "https://www.cryptocompare.com\(String(describing: self.coinsFilter[index].imageUrl!))"
                let imageURL = URL(string: urlImage)
                let data = try? Data(contentsOf: imageURL!)
                self.coinsFilter[index].iconMoney = UIImage(data: data!)
                
                if self.coinsFilter[index].iconMoney != nil{
                    let favoriteCoreData = FavoriteCoin(context: self.appDelegate.persistentContainer.viewContext)
                    favoriteCoreData.coinName = self.coinsFilter[index].coinName
                    favoriteCoreData.symbol = self.coinsFilter[index].symbol
                    favoriteCoreData.imageUrl = self.coinsFilter[index].imageUrl
                    favoriteCoreData.iconMoney = UIImagePNGRepresentation(self.coinsFilter[index].iconMoney!)
                    self.appDelegate.accountFacebookLogged.addToFavoriteCoins(favoriteCoreData)
                    self.appDelegate.saveContext()
                }
            }
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            coinsFilter = appDelegate.coins
            tableView.reloadData()
            self.view.endEditing(true)
        }else{
        filterCoinsBySearch(coinsStringFilter: searchText)
        }
        
    }
    func filterCoinsBySearch(coinsStringFilter:String){

        coinsFilter = coinsFilter.filter({(mod) -> Bool in
            return mod.coinName!.lowercased().contains(coinsStringFilter.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
}
