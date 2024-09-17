//
//  RegisterViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit
import SnapKit

final class RegisterViewController: BaseViewController<RegisterViewModel> {
    
    private var selectedDate: String = ""
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let nameTextField: InputTextField = {
        let tf = InputTextField()
        tf.placeholder = "enterYourName".localized()
        return tf
    }()
    
    private let numberTextField: InputTextField = {
        let tf = InputTextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "\("enterYourNumber".localized()) ( 0551234567 )"
        return tf
    }()
    
    private lazy var dateTextField: InputTextField = {
        let dateTF = InputTextField()
        dateTF.placeholder = "selectYourBirthDate".localized()
        return dateTF
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "buttonBackground")
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("register".localized(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
    }
    
    private func setupUI() {
        addGestureRecognizer()
        [mainStackView, activityIndicator].forEach { view.addSubview($0) }
        dateTextField.addSubview(datePicker)
        [nameTextField, numberTextField, dateTextField, registerButton].forEach { mainStackView.addArrangedSubview($0) }
        setupConstraints()
        mainStackView.setCustomSpacing(32, after: dateTextField)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension RegisterViewController {
    
   
    
    @objc
    private func didSelectDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = "yourBirthDate".localized()
    }
    
    @objc
    private func didTapRegister() {
        guard let name = nameTextField.text, !name.isEmpty,
              let number = numberTextField.text, !number.isEmpty,
              selectedDate != ""
        else {
            showAlert("error", "fillBlanks")
            return
        }
        activityIndicator.startAnimating()
        
        Task {
            do {
                try await vm.saveUserData(User(id: UUID().uuidString, name: name, number: number, birthDate: selectedDate))
                activityIndicator.stopAnimating()
                let vc = UINavigationController(rootViewController: router.homeVC())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } catch {
                activityIndicator.stopAnimating()
                showAlert("error", error.localizedDescription)
            }
        }
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }
}
