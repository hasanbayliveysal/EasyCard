//
//  BaseViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

class BaseViewController<VM>: UIViewController {
    
    var vm: VM
    var router: Router
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(view.bounds.height/4)
        }
    }
   
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.1
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let backButtonTitle = "back".localized()
        let backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    init(vm: VM, router: Router) {
        self.vm = vm
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title.localized(), message: message.localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .destructive))
        if title == "success" {
            let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
        }
        self.present(alert, animated: true)
    }
}
