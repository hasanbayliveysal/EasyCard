//
//  CardView.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import UIKit

final class CardFrontView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let cardLogo: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "carddetail".localized()
        label.textColor = .black
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubview(containerView)
        containerView.addSubview(numberLabel)
        containerView.addSubview(cardLogo)
        containerView.addSubview(detailLabel)
    }
    
    private func setupConstraints() {
      
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        cardLogo.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with card: Card) {
        let lastFourDigits = String(card.cardNumber.suffix(4))
        numberLabel.text = "• \(lastFourDigits)"
        print(card.type)
        cardLogo.image = UIImage(named: (card.type == "Visa") ? "visa" : "mastercard")
        containerView.backgroundColor = UIColor(named: (card.type == "Visa") ? "buttonBackground" : "mastercardColor")
        setupConstraints()
    }
    
}


final class CardBackView: UIView {
    
    private var isShown = false
    private var cvvCode: String?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .red
        return view
    }()
    
    private let viewForCVV: UIStackView = {
        let view = UIStackView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.spacing = 6
        view.axis = .horizontal
        return view
    }()
    
    private let cvvLabel: UILabel = {
        let label = UILabel()
        label.text = " CVV"
        label.textColor = .black
        return label
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black.withAlphaComponent(0.5)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.addTarget(self, action: #selector(didTapEyeButton), for: .touchUpInside)
        return button
    }()
    
    private let numberStackView: TitleSubtitleStackView = {
        let sv = TitleSubtitleStackView()
        return sv
    }()
    
    private let dateStackView: TitleSubtitleStackView = {
        let sv = TitleSubtitleStackView()
        return sv
    }()
    
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubview(containerView)
        containerView.addSubview(viewForCVV)
        containerView.addSubview(numberStackView)
        containerView.addSubview(dateStackView)
        containerView.addSubview(blackView)
        [cvvLabel, eyeButton].forEach({
            viewForCVV.addArrangedSubview($0)
        })
    }
    
    private func setupConstraints() {
     
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        
        viewForCVV.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.width.equalTo(75)
        }
        blackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(30)
            make.height.equalTo(30)
        }
        eyeButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    func configure(with card: Card) {
        numberStackView.configure(with: "cardNumber", and: card.cardNumber)
        dateStackView.configure(with: "usingDate", and: convertDate(dateString: card.date))
        containerView.backgroundColor = UIColor(named: (card.type == "Visa") ? "buttonBackground" : "mastercardColor")
        cvvCode = " \(card.cvv)"
        setupConstraints()
    }
    
    private func convertDate(dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/YY"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
    
    @objc
    private func didTapEyeButton() {
        guard let cvvCode else {return}
        cvvLabel.text = isShown ? cvvCode : " CVV"
        eyeButton.setImage(UIImage(systemName: isShown ?  "eye.slash.fill" :  "eye.fill"), for: .normal)
        isShown.toggle()
    }
}

class TitleSubtitleStackView: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 4
        alignment = .leading
        [titleLabel, subtitleLabel].forEach({
            addArrangedSubview($0)
        })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func configure(with title: String, and subtitle: String) {
        titleLabel.text = title.localized()
        subtitleLabel.text = subtitle
    }
}

