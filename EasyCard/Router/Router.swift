//
//  Router.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

protocol RouterProtocol {
    
    func welcomeVC () -> UIViewController
    func registerVC() -> UIViewController
    func homeVC () -> UIViewController
    func transactionVC() -> UIViewController
    func transferVC() -> UIViewController
}

class Router: RouterProtocol {
    
    func welcomeVC() -> UIViewController {
        return WelcomeViewController(vm: WelcomeViewModel(), router: self)
    }
  
    func registerVC() -> UIViewController {
        return RegisterViewController(vm: RegisterViewModel(), router: self)
    }
    
    func homeVC() -> UIViewController {
        return HomeViewController(vm: HomeViewModel(), router: self)
    }
    
    func transactionVC() -> UIViewController {
        return TransactionViewController(vm: TransactionViewModel(), router: self)
    }

    func transferVC() -> UIViewController {
        TransferViewController(vm: TransferViewModel(), router: self)
    }
    
}
