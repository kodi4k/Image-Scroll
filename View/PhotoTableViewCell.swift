//
//  PhotoTableViewCell.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 28.04.2025.
//
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    static let identifier = "PhotoTableViewCell"
    
    private let photoImageView = UIImageView()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var currentTask: URLSessionDataTask?
    var onLikeButtonTapped: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        likeButton.tintColor = .black
        currentTask?.cancel()
    }
    
    private func setupUI() {
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .lightGray
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .black
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        commentButton.tintColor = .black
        
        shareButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        shareButton.tintColor = .black
        
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        photoImageView.addSubview(activityIndicator) 
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.2),
            
            likeButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
            commentButton.widthAnchor.constraint(equalToConstant: 44),
            commentButton.heightAnchor.constraint(equalToConstant: 44),
            
            shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 4),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
    
    @objc private func likeButtonTapped() {
        //likeButton.tintColor = likeButton.tintColor == .red ? .black : .red
        let newIsLiked = likeButton.tintColor == .red ? false : true
        likeButton.setImage(UIImage(systemName: newIsLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = newIsLiked ? .red : .black
        onLikeButtonTapped?(newIsLiked)
    }
    
    func configure(with photo: Photo) {
        photoImageView.image = nil
        currentTask?.cancel() // Отменяем предыдущую загрузку
        likeButton.setImage(UIImage(systemName: photo.isLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = photo.isLiked ? .red : .black
        activityIndicator.startAnimating() // Показываем индикатор
        if let cachedImage = ImageCache.getImage(forKey: photo.imageUrl) {
            photoImageView.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        guard let url = URL(string: photo.imageUrl) else {
            activityIndicator.stopAnimating()
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                return
            }
            if let image = UIImage(data: data) {
                ImageCache.setImage(image, forKey: photo.imageUrl) // Сохраняем в кэш
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        currentTask?.resume()
    }
}
