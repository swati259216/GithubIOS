//
//  GithubValidationViewModel.swift
//  GithubSignup
//
//  Created by Swati Goel on 12/23/15.
//  Copyright © 2015 Zemoso. All rights reserved.
//

import Foundation
import RxSwift

class GithubValidationViewModel {
    
    private let API : GithubAPI
    private let validationService : GithubValidationService
    
    let userName = Variable("")
    let password = Variable("")
    let confirmPassword = Variable("")
    
    let validatedUserName :Observable<ValidationResult>
    let validatedPassword :Observable<ValidationResult>
    let validatedConfirmPassword : Observable<ValidationResult>
    
    let signUpEnabled: Observable<Bool>
    init(API: GithubAPI,validationService : GithubValidationService){
        self.API = API
        self.validationService = validationService
        
        validatedUserName = userName.flatMapLatest{
            userName in
            return validationService.validateUserName(userName)
                .observeOn(MainScheduler.sharedInstance)
                .catchErrorJustReturn(.Failed)
        }
        validatedPassword = password
            .map{ passWord in
                return validationService.validatePassword(passWord)
        }
        
        validatedConfirmPassword = combineLatest(password, confirmPassword, resultSelector: validationService.validateConfirmPassword)
        
        signUpEnabled = combineLatest(
            validatedUserName,
            validatedPassword,
            validatedConfirmPassword
            ){
                userName,password,confirmPassword in
                userName.isValid &&
                password.isValid &&
                confirmPassword.isValid
        }
        }
        
    
    
    
    
    
    
    
    
    
}