//
//  Protocols.swift
//  GithubSignup
//
//  Created by Swati Goel on 12/22/15.
//  Copyright © 2015 Zemoso. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


enum ValidationResult{
    case OK
    case Validating
    case Empty
    case Failed
}

protocol GithubAPI{
    func userNameAvailable(userName:String)->Observable<Bool>
    func signUp(userName:String, password:String)->Observable<Bool>
}

protocol GithubValidationService{
    func validateUserName(userName:String) -> Observable<ValidationResult>
    func validatePassword(password:String) -> ValidationResult
    func validateConfirmPassword(password:String,repeatedPassword:String)-> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .OK:
            return true
        default:
            return false
        }
    }
}
