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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightBarButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
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
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isHidden = true
        return blurView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLeftAndRightBarButton()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupConstraints()
        setupActivityIndicator()
        addGestureRecognizer()
    }
    
    private func setupConstraints() {
        containerView.addSubview(cardFrontView)
        containerView.addSubview(cardBackView)
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(activityIndicator)
        [emptyView, containerView, balanceLabel].forEach({ mainStackView.addArrangedSubview($0) })
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
        
        emptyView.plusButtonClicked = {
            self.blurEffectView.isHidden = false
            self.activityIndicator.startAnimating()
            Task {
                do {
                    try await self.vm.generateCard(with: .MASTERCARD)
                    self.reloadAllViewElements()
                }
            }
            
        }
        loadData()
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
                    return
                }
                
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
        // Show blur effect and activity indicator
        // Reset views to their initial states
        emptyView.isHidden = true
        cardFrontView.isHidden = true
        cardBackView.isHidden = true
        
        // Reload data
        loadData()
        
        // Hide blur effect and activity indicator after data is reloaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Adjust delay as needed
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
        
        //        blurEffectView.isHidden = false
        //        activityIndicator.startAnimating()
        //
        //        Task {
        //            do {
        //                try await vm.deleteCard()
        //                reloadAllViewElements()
        //            }
        //        }
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
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
