//
//  ViewController.swift
//  GithubSignup
//
//  Created by Swati Goel on 12/22/15.
//  Copyright © 2015 Zemoso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordValidOutlet: UILabel!
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var signUpButton: UIButton!       
    
    let viewModel = GithubValidationViewModel(
     API: GithubDefaultAPI.sharedAPI, validationService: DefaultGithubValidationService.sharedValidationService
    )
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        userNameField.rx_text.bindTo(viewModel.userName)
        .addDisposableTo(disposeBag)
        
        passwordField.rx_text.bindTo(viewModel.password)
        .addDisposableTo(disposeBag)
        
        confirmPasswordField.rx_text.bindTo(viewModel.confirmPassword)
        .addDisposableTo(disposeBag)
        
        
        
        viewModel.signUpEnabled.bindTo(signUpButton.rx_enabled)
        .addDisposableTo(disposeBag)
        
        signUpButton.rx_tap.subscribeNext(GithubDefaultAPI.signUp(GithubDefaultAPI.sharedAPI))
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

