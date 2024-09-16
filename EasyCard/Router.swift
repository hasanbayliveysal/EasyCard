//
//  Router.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

protocol RouterProtocol {
    
    func loginVC () -> UIViewController
    func registerVC() -> UIViewController
    func homeVC () -> UIViewController
    
}

class Router: RouterProtocol {
    
    func loginVC() -> UIViewController {
        return LoginViewController(vm: LoginViewModel(), router: self)
    }
    func registerVC() -> UIViewController {
        return RegisterViewController(vm: RegisterViewModel(), router: self)
    }
    func homeVC() -> UIViewController {
        return HomeViewController(vm: HomeViewModel(), router: self)
    }
    
}
