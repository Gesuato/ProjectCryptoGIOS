//
//  CountryOfVisitViewController.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit

class CountryOfVisitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imageCountryVisite: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var symbolCoutryLabel: UILabel!
    
    let locale = Locale.current
    var refreshData : UIRefreshControl!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getValueCoinsCurrentCountryRefreshData()
        self.imageCountryVisite.image = self.appDelegate.imageCountryVisite
        self.symbolCoutryLabel.text = locale.currencyCode
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        refreshData  = UIRefreshControl()
        refreshData.attributedTitle = NSAttributedString(string: "Actualiser les données")
        refreshData.addTarget(self, action: #selector(getValueCoinsCurrentCountryRefreshData), for: .valueChanged)
        self.tableView.refreshControl = refreshData
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getValueCoinsCurrentCountryRefreshData()
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getValueCoinsCurrentCountryRefreshData()
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 //height for cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.appDelegate.coinsFavorites.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let image = cell.contentView.viewWithTag(1) as! UIImageView
        let labelCurrencyConversionCountry = cell.contentView.viewWithTag(2) as! UILabel
        let labelNameMoney = cell.contentView.viewWithTag(3) as! UILabel
        let labelConversionValue = cell.contentView.viewWithTag(4) as! UILabel
        
        labelCurrencyConversionCountry.text = Locale.current.currencyCode!
        labelNameMoney.text = self.appDelegate.coinsFavorites[indexPath.row].coinName
        
        if self.appDelegate.coinsFavorites[indexPath.row].conversionCountryOfVisitValue != 0 {
           labelConversionValue.text =  "\(locale.currencySymbol!) \(self.appDelegate.coinsFavorites[indexPath.row].conversionCountryOfVisitValue)"
        }
        image.image = self.appDelegate.coinsFavorites[indexPath.row].iconMoney
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "La liste de favoris a \(self.appDelegate.coinsFavorites.count) item(s)"
    }
    
   @objc func getValueCoinsCurrentCountryRefreshData (){
        let locale = Locale.current
        
        for value in self.appDelegate.coinsFavorites{
            
            DispatchQueue.main.async {
                let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(value.symbol!)&tsyms=\(locale.currencyCode!)")
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
                            value.conversionCountryOfVisitValue = json[locale.currencyCode!]!
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
