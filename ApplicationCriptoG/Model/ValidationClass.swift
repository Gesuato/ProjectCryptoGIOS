//
//  validationClass.swift
//  ApplicationCriptoG
//
//  Created by Victor Gesuato on 2018-06-05.
//  Copyright © 2018 DevGesuato. All rights reserved.
//

import Foundation

struct ValidationClass{
    
    func validationSizePassword(password:String) -> Bool{
        var isValidePassword = false
        
            if (password.characters.count) >= 6{
                isValidePassword = true
            }
        return isValidePassword
    }
    
    func validationConfirmPassword(password:String,confirmationPassword:String) -> Bool{
        var isValideConfirmPassword = false
        if password == confirmationPassword{
            isValideConfirmPassword = true
            
        }
        return isValideConfirmPassword
    }
    
    func validationUserName(appDelegate:AppDelegate,userName:String) -> Bool{
        var isValideUserName = true
        var accounts:[Account] = []
        let context = appDelegate.persistentContainer.viewContext
        do {
            accounts = try context.fetch(Account.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
        for item in accounts{
            if item.userName == userName{
                isValideUserName = false
                break
            }
        }
        if userName.characters.count <= 0{
            isValideUserName = false
        }
        
        return isValideUserName
    }
    
    func validationSecretQuestion(secretQuestion:String) -> Bool{
        var isValideQuestion = false
        if secretQuestion.characters.count > 0{
            isValideQuestion = true
        }
        
        return isValideQuestion
    }
    
    func validationSecretAnswer(secretAnswer:String) -> Bool{
        var isValideAnswer = false
        if secretAnswer.characters.count > 0{
            isValideAnswer = true
        }
        
        return isValideAnswer
    }
    
    func validationPasswordInAccountLogged(appDelegate:AppDelegate,password:String) -> Bool{
        var isValidePassword:Bool = true

        if appDelegate.accountLogged.password != password{
            isValidePassword = false
        }
        return isValidePassword
    }
    
    func validationSecretAnswerInLoggedAccount(appDelegate:AppDelegate,secretAnswer:String) -> Bool{
        
        var isValideSecretAnswer:Bool = true
        
        if appDelegate.accountLogged.secretAnswer != secretAnswer{
            isValideSecretAnswer = false
        }
        return isValideSecretAnswer
    }
    
}
