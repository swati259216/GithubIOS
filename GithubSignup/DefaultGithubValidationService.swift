//
//  DefaultGithubValidationService.swift
//  GithubSignup
//
//  Created by Swati Goel on 12/22/15.
//  Copyright © 2015 Zemoso. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DefaultGithubValidationService : GithubValidationService{
    let API:GithubAPI
    
    static let sharedValidationService = DefaultGithubValidationService(
        API : GithubDefaultAPI.sharedAPI
        )
    
    init(API:GithubAPI){
        self.API=API
    }
    
    func validateUserName(userName: String) -> Observable<ValidationResult> {
        if(userName.characters.count==0){
            return just(.Empty)
        }
        
        let loadingValue = ValidationResult.Validating
        
        return API
            .userNameAvailable(userName)
            .map{ available in
                if available {
                    return .OK
                }
                else{
                    return .Failed
                }
            }
        .startWith(loadingValue)
        
    }
    
    func validatePassword(password: String) -> ValidationResult {
        let numPasswordChars = password.characters.count
        if(numPasswordChars==0){
            return .Empty
        }
        
        if(numPasswordChars<5){
            return .Failed
        }
        return .OK
    }
    
    func validateConfirmPassword(password: String, repeatedPassword: String) -> ValidationResult {
        if(repeatedPassword.characters.count==0){
            return .Failed
        }
        if(repeatedPassword==password){
            return .OK
        }
        return .Failed
    }
    
}

class GithubDefaultAPI:GithubAPI {
    let URLSession : NSURLSession
    
    static let sharedAPI = GithubDefaultAPI(
        URLSession: NSURLSession.sharedSession()
    )
    
    
    init(URLSession:NSURLSession){
        self.URLSession = URLSession
    }
    
    func userNameAvailable(userName: String) -> Observable<Bool> {
        
        let URL = NSURL(string: "https://github.com/\(userName)")!
        let request = NSURLRequest(URL: URL)
        
        return self.URLSession.rx_response(request)
            .map{(data,response) in
                return response.statusCode == 404
            }
        .catchErrorJustReturn(false)
        
    }
    
    func signUp(userName: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        return just(signupResult)
            .concat(never())
            .throttle(2, MainScheduler.sharedInstance)
            .take(1)

    }
    
}
