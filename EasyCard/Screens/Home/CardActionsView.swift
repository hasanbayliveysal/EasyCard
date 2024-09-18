//
//  CardActionsView.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

typealias emptyClosure = (()->Void)
final class CardActionsView: UIView {
    
    var deleteButtonClicked: emptyClosure?
    var transactionButtonClicked: emptyClosure?
    
    private lazy var transactionButton: UIButton = {
        let button = UIButton()
        button.setTitle("transactions".localized(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor(named: "buttonBackground")
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapTransaction), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("deletecard".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor(named: "deleteColor")
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(transactionButton)
        addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        transactionButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(transactionButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    @objc private func didTapTransaction() {
        transactionButtonClicked?()
    }
    
    @objc private func didTapDelete() {
        deleteButtonClicked?()
    }
}
