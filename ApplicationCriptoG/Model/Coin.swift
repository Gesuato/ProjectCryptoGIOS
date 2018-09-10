//
//  Coin.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-05-28.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import UIKit

class Coin:NSObject{

    var coinName:String?
    var symbol:String?
    var imageUrl:String?
    var iconMoney:UIImage?
    var conversionValueCAD:Double = 0
    var conversionValueBRL:Double = 0
    var conversionCountryOfVisitValue:Double = 0
    
    init(CoinName:String,Symbol:String,ImageUrl:String,IconMoney:UIImage,ConversionValue:Double) {
        self.coinName = CoinName
        self.symbol = Symbol
        self.imageUrl = ImageUrl
        self.iconMoney = IconMoney
        self.conversionCountryOfVisitValue = ConversionValue
        
    }
    override init() {
        
    }
}
