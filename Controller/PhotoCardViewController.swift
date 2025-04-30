//
//  PhotoCardViewController.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 29.04.2025.
//

import UIKit
import SDWebImage

class PhotoCardViewController: UIViewController {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var photo: Photo
    var onLikeTapped: ((Photo) -> Void)?
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
        
        // тут указываем что создаем кастомную презентацию
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        // Настройки контейнера (карточки)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .lightGray
        
        likeButton.setImage(UIImage(systemName: photo.isLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = photo.isLiked ? .red : .black
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        commentButton.tintColor = .black
        
        shareButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        shareButton.tintColor = .black
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        
        containerView.addSubview(imageView)
        containerView.addSubview(likeButton)
        containerView.addSubview(commentButton)
        containerView.addSubview(shareButton)
        containerView.addSubview(closeButton)
        imageView.addSubview(activityIndicator)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.2),
            
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            likeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            commentButton.widthAnchor.constraint(equalToConstant: 44),
            commentButton.heightAnchor.constraint(equalToConstant: 44),
            
            shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 8),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
       
        if let url = URL(string: photo.imageUrl) {
            activityIndicator.startAnimating()
            imageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: [.retryFailed],
                completed: { [weak self] _, error, _, _ in
                    self?.activityIndicator.stopAnimating()
                }
            )
        }
    }
    
    @objc private func likeButtonTapped() {
        photo.isLiked.toggle()
        likeButton.setImage(UIImage(systemName: photo.isLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = photo.isLiked ? .red : .black
        onLikeTapped?(photo)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// Тут указываем саму презентацию
extension PhotoCardViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class CardPresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting: UIViewController?) {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        
        // Анимация затемнения фона
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            })
        } else {
            dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Анимация исчезновения фона
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            }) { _ in
                self.dimmingView.removeFromSuperview()
            }
        } else {
            dimmingView.alpha = 0
            dimmingView.removeFromSuperview()
        }
    }
}
