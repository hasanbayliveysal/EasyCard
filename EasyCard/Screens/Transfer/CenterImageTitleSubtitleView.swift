//
//  CenterImageTitleSubtitleView.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//


import UIKit

final class CenterImageTitleSubtitleView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "imageBackground")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(stackView)
        [imageView,titleLabel,subtitleLabel].forEach({stackView.addArrangedSubview($0)})
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
    
    func configure(with card: Card) {
        Task {
            do {
                let user = try await UserService.shared.getUserData(with: card.ownerID)
                imageView.image = UIImage(named: card.type == "Visa" ? "visa" : "mastercard")
                titleLabel.text =  "• \(card.cardNumber.suffix(4))"
                subtitleLabel.text = user.name
            } catch {
                print(error)
            }
        }
       
    }
    
}
