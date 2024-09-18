//
//  EmptyView.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class EmptyView: UIView {
    var plusButtonClicked: emptyClosure?
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.backgroundColor = .white.withAlphaComponent(0.15)
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(plusButton)
        containerView.addSubview(bottomLabel)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        plusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
        bottomLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    func configure(with userName: String) {
        bottomLabel.text = "\(userName), " + "youdonthave".localized()
    }
    
    @objc
    private func didTapPlusButton() {
        plusButtonClicked?()
    }
}

