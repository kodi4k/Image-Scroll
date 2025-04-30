//
//  GridPhotoCell.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 29.04.2025.
//

import UIKit
import SDWebImage

class GridPhotoCell: UICollectionViewCell {
    static let identifier = "GridPhotoCell"
    
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with photo: Photo) {
        activityIndicator.startAnimating()
        
        if let url = URL(string: photo.imageUrl) {
            imageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: [.retryFailed],
                completed: { [weak self] _, error, _, _ in
                    self?.activityIndicator.stopAnimating()
                }
            )
        } else {
            imageView.image = UIImage(named: "defaultImage")
            activityIndicator.stopAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.startAnimating()
        imageView.sd_cancelCurrentImageLoad()
    }
}
