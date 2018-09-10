//
//  AppDelegate.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-24.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coins = [Coin]()
    var coinsFavorites = [Coin]()
    var accountLogged = Account()
    var accountFacebookLogged = AccountFacebook()
    var imageCountryVisite:UIImage?
    var isLogged:Bool = false
    var isDarkMode:Bool = false
    var isLoggedFacebook:Bool = false
    
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
        getAttributesOfAllCoins()
        getFlagCountryVisite()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ApplicationCriptoG")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

    func getAttributesOfAllCoins (){
        let urlString = "https://min-api.cryptocompare.com/data/all/coinlist"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                let quoteDictionary = parsedData["Data"] as! [String:AnyObject]
                
            for item in quoteDictionary {

                DispatchQueue.main.async {
                    let coin = Coin()
                        coin.coinName = (item.value["CoinName"] as! String)
                        coin.symbol = (item.value["Symbol"] as! String)
                        coin.imageUrl = (item.value["ImageUrl"] as? String)
                    
                        self.coins.append(coin)
                    
                }
            }
                    
                } catch let error as NSError {
                    print(error.localizedDescription) 
                }
            }
            
            }.resume()
    }
    
    func getValueCoins (){
        
        for value in coinsFavorites{
            
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
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    }.resume()
            }
        }
    }
    
   func getValueCoinsCurrentCountry (){
        let locale = Locale.current
        
        for value in coinsFavorites{
            
            DispatchQueue.main.async {
            
                let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(value.symbol!)&tsyms=\(locale.currencyCode!)")
                URLSession.shared.dataTask(with:url!) { (data, response, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        
                        guard let data = data else{
                            return
                        }
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Double]
                                else{
                                    return
                            }
                            value.conversionCountryOfVisitValue = json[locale.currencyCode!]!
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    }.resume()
            }
        }
    }
    
    func getFlagCountryVisite(){
        let locale = Locale.current
        let urlCoinConvertionString:String = ("http://www.countryflags.io/\(locale.regionCode!)/flat/64.png")
        let urlImage = urlCoinConvertionString
        
        if let imageURL = URL(string: urlImage){
            DispatchQueue.global().async {
                
                let data = try? Data(contentsOf: imageURL)
                self.imageCountryVisite = UIImage(data: data!)
    
            }
        }
        
    }
    
    func darkMode(){
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.orange
        
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.orange]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.orange]
    }
    
    func normalMode(){
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.init(red: 31.0/255.0, green: 134.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.init(red: 31.0/255.0, green: 134.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
   
}

