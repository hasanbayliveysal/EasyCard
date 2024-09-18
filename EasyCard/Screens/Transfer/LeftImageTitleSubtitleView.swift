//
//  LeftImageTitleSubtitleView.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class LeftImageTitleSubtitleView: UIView {
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "imageBackground")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(bottomStackView)
        [titleLabel, subtitleLabel].forEach({centerStackView.addArrangedSubview($0)})
        [leftImageView, centerStackView].forEach({leftStackView.addArrangedSubview($0)})
        [leftStackView, rightLabel].forEach({bottomStackView.addArrangedSubview($0)})
        setupConstraints()
    }
    
    private func setupConstraints() {
        bottomStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftImageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
    
    func configure(with card: Card) {
        leftImageView.image = UIImage(named: card.type == "Visa" ? "visa" : "mastercard")
        titleLabel.text = (card.type == "Visa") ? "Visa" : "Mastercard"
        subtitleLabel.text = "AZN \(card.balance)"
        rightLabel.text =  "• \(card.cardNumber.suffix(4))"
    }
    
}
