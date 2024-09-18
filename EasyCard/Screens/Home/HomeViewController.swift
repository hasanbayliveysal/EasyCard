//
//  HomeViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    private var isShowingBack = false
    
    private let leftTitleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "welcome".localized()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightBarButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cardFrontView: CardFrontView = {
        let view = CardFrontView()
        view.isHidden = true
        return view
    }()
    
    private let cardBackView: CardBackView = {
        let view = CardBackView()
        view.isHidden = true
        return view
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let cardActionsView: CardActionsView = {
        let view = CardActionsView()
        view.isHidden = true
        return view
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isHidden = true
        return blurView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLeftAndRightBarButton()
        view.backgroundColor = UIColor(named: "backgroundColor")
        buttonActions()
        setupConstraints()
        setupActivityIndicator()
        addGestureRecognizer()
    }
    
    private func setupConstraints() {
        [reloadButton, rightBarButton].forEach({topStackView.addArrangedSubview($0)})
        containerView.addSubview(cardFrontView)
        containerView.addSubview(cardBackView)
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(activityIndicator)
        [emptyView, containerView, balanceLabel, cardActionsView].forEach({ mainStackView.addArrangedSubview($0) })
        view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        cardFrontView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
    
    private func buttonActions() {
        emptyView.plusButtonClicked = {
            self.blurEffectView.isHidden = false
            self.activityIndicator.startAnimating()
            self.present(self.vm.showAlertForSelection(), animated: true)
            self.vm.selectedCardType = { [weak self] cardType in
                Task {
                    do {
                        try await self?.vm.generateCard(with: cardType)
                        self?.reloadAllViewElements()
                    }
                }
            }
            
        }
        
        vm.cancelButtonClicked = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.blurEffectView.isHidden = true
        }
        
        cardActionsView.deleteButtonClicked = {
            self.activityIndicator.startAnimating()
            self.blurEffectView.isHidden = false
            self.present(self.vm.showAlertForDeleteCard(), animated: true)
            self.vm.reloadData = { [weak self] in
                DispatchQueue.main.async {
                    self?.reloadAllViewElements()
                }
            }
        }
        
        cardActionsView.transactionButtonClicked = { [weak self] in
            let vc = self?.router.transactionVC()
            self?.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
        }
    }
    
    private func setupActivityIndicator() {
        blurEffectView.isHidden = true
    }
    
    private func loadData() {
        Task {
            do {
                let user = try await vm.fetchUser()
                guard let cardID = user.cardID else {
                    emptyView.isHidden = false
                    print("here empty view")
                    emptyView.configure(with: user.name)
                    cardActionsView.isHidden = true
                    balanceLabel.isHidden = true
                    return
                }
                cardActionsView.isHidden = false
                balanceLabel.isHidden = false
                let card = try await vm.fetchUserCard(with: cardID)
                cardFrontView.configure(with: card)
                cardBackView.configure(with: card)
                balanceLabel.text = "\("yourbalance".localized()): \(card.balance) AZN"
                cardFrontView.isHidden = false
            } catch {
                print("Failed to fetch card details: \(error)")
            }
        }
    }
    
    private func reloadAllViewElements() {
        emptyView.isHidden = true
        cardFrontView.isHidden = true
        cardBackView.isHidden = true
        
        loadData()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.blurEffectView.isHidden = true
        }
    }
    
    @objc
    private func handleTapGesture() {
        flipCard()
    }
    
    @objc
    private func didTapMoreButton() {
        
        let alert = UIAlertController(title: "logout".localized(), message: "doyouwantlogout".localized(), preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.vm.setUserLoggedOut()
            let vc = UINavigationController(rootViewController: self?.router.welcomeVC() ?? UIViewController())
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        alert.addAction(okButton)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .destructive))
        self.present(alert, animated: true)
        
    }
    
    @objc
    private func didTapReloadButton() {
        reloadAllViewElements()
    }
    
    private func flipCard() {
        let fromView = isShowingBack ? cardBackView : cardFrontView
        let toView = isShowingBack ? cardFrontView : cardBackView
        
        UIView.transition(from: fromView, to: toView, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        isShowingBack.toggle()
    }
    
    private func createLeftAndRightBarButton() {
        let leftBarButtonItem = UIBarButtonItem(customView: leftTitleView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: topStackView)
    }
    
    private func addGestureRecognizer() {
        let longPressGestureForBack = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        let longPressGestureForFront = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        cardFrontView.addGestureRecognizer(longPressGestureForFront)
        cardBackView.addGestureRecognizer(longPressGestureForBack)
        cardFrontView.isUserInteractionEnabled = true
        cardBackView.isUserInteractionEnabled = true
    }
    
}
