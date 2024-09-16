//
//  RegisterViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

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
        tf.placeholder = "enterYourNumber".localized()
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
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("register".localized(), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addGestureRecognizer()
        view.backgroundColor = .cyan.withAlphaComponent(0.15)
        [mainStackView].forEach({view.addSubview($0)})
        dateTextField.addSubview(datePicker)
        [nameTextField, numberTextField, dateTextField, registerButton].forEach({mainStackView.addArrangedSubview($0)})
        setupConstraints()
        mainStackView.setCustomSpacing(32, after: dateTextField)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
    }
}

extension RegisterViewController {
    
    @objc
    private func doneButtonTapped() {
        print("ok")
    }
    
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
            showAlert("Error", "Fill blanks")
            return
        }
        Task {
            do {
                try await vm.saveUserData(User(id: UUID().uuidString, name: name, number: number, birthDate: selectedDate))
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

