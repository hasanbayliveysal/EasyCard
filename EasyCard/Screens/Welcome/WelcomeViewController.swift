//
//  WelcomeViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import UIKit

class WelcomeViewController: BaseViewController<WelcomeViewModel> {
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        button.setTitle("becomeAClient".localized(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "buttonBackground")
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightBarButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchLogo")
        imageView.alpha = 0.3
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        setupConstrains()
    }
    
    private func setupConstrains() {
        view.addSubview(backgroundImageView)
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(100)
            make.height.equalTo(48)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
}

extension WelcomeViewController {
    
    @objc
    private func didTapSignUpButton() {
        navigationController?.pushViewController(router.registerVC(), animated: true)
    }
    
    @objc
    private func didTapMoreButton() {

        let alert = UIAlertController(title: "changeLanguage".localized(), message: "selectLanguage".localized(), preferredStyle: .actionSheet)
        let azButton = UIAlertAction(title: "Azərbaycan Dili", style: .default) { [weak self] _ in
            self?.vm.changeLanguage(.az)
            self?.changeButtonTitle()
        }
        let enButton = UIAlertAction(title: "English", style: .default) { [weak self] _ in
            self?.vm.changeLanguage(.en)
            self?.changeButtonTitle()
        }
        let cancelButton = UIAlertAction(title: "cancel".localized(), style: .destructive)
        [azButton,enButton, cancelButton].forEach({alert.addAction($0)})
        
        self.present(alert, animated: true)
    }
    
    private func changeButtonTitle() {
        signUpButton.setTitle("becomeAClient".localized(), for: .normal)
    }
}
