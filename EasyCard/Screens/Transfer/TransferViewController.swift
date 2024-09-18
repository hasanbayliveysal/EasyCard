//
//  TransferViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class TransferViewController: BaseViewController<TransferViewModel> {
    
    var selectedCard: Card?
    private var currentUserBalance: Double = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "transactions".localized()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let label = UITextField()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.addTarget(self, action: #selector(didChangeInputValue(_ :)), for: .allEditingEvents)
        label.keyboardType = .numberPad
        label.placeholder = "0.0"
        return label
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let centerView: CenterImageTitleSubtitleView = {
        let view = CenterImageTitleSubtitleView()
        return view
    }()
    
    
    private let bottomView: LeftImageTitleSubtitleView = {
        let view = LeftImageTitleSubtitleView()
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("send".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        inputTextField.becomeFirstResponder()
        self.navigationItem.titleView = titleLabel
        setupUI()
    }
    
    private func  setupUI() {
        view.addSubview(bottomView)
        view.addSubview(centerView)
        view.addSubview(inputTextField)
        view.addSubview(limitLabel)
        view.addSubview(sendButton)
        view.addSubview(activityIndicator)
        guard let selectedCard else {
            return
        }
       
        Task {
            do {
                let card = try await vm.getCurrentUserCard()
                bottomView.configure(with: card)
                centerView.configure(with: selectedCard)
                limitLabel.text = "Max \(card.balance) AZN"
                currentUserBalance = card.balance
            } catch {
                self.showAlert("error", error.localizedDescription)
            }
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        centerView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(centerView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(view.bounds.width/3)
        }
        
        limitLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(view.bounds.width/3)
            make.top.equalTo(inputTextField.snp.bottom).offset(5)
        }
        
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(bottomView.snp.bottom).offset(20)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func didChangeInputValue(_ sender: UITextField) {
        guard let stringNum = sender.text,
              let doubleNum = Double(stringNum) else {
            return
        }
        sender.textColor = (doubleNum > currentUserBalance) ? .red : .white
        sendButton.backgroundColor = (doubleNum <= currentUserBalance && currentUserBalance > 0) ? .systemBlue : .systemGray
        sendButton.isEnabled = (doubleNum <= currentUserBalance && currentUserBalance > 0)
    }
    
    @objc
    private func didTapSend() {
        activityIndicator.startAnimating()
        guard let stringNum = inputTextField.text,
              let doubleNum = Double(stringNum),
              let selectedCard
        else {
            return
        }
        Task {
            do {
                try await vm.sendMoney(to: selectedCard, amount: doubleNum)
                navigationController?.viewControllers = [router.homeVC()]
                activityIndicator.stopAnimating()
            } catch {
                self.showAlert("error", error.localizedDescription)
                activityIndicator.stopAnimating()
            }
        }
       
        
        
    }
}

