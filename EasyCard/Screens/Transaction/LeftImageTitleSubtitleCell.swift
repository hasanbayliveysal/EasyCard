//
//  LeftImageTitleSubtitleCell.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class LeftImageTitleSubtitleCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mastercardColor")
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let cardLogoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        [cardLogoImageView, titleLabel].forEach({leftStackView.addArrangedSubview($0)})
        [leftStackView, subtitleLabel].forEach({mainStackView.addArrangedSubview($0)})
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        cardLogoImageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
    }
    
    func configure(with card: Card) {
        Task {
            do {
                let user = try await UserService.shared.getUserData(with: card.ownerID)
                titleLabel.text = user.name
                subtitleLabel.text = "• \(card.cardNumber.suffix(4))"
                cardLogoImageView.image = UIImage(named: (card.type == "Visa") ? "visa" : "mastercard")
            } catch {
                print(error)
            }
        }
    }
}
