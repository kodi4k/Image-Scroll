//
//  GridViewController.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 28.04.2025.
//

import UIKit

class GridViewController: UIViewController {
    
    private let collectionView: UICollectionView
    private var photos: [Photo] = []
    private var currentPage = 1
    private var isLoading = false
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPhotos()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Photo Grid"
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.register(GridPhotoCell.self, forCellWithReuseIdentifier: GridPhotoCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let newPhotos = (1...21).map { _ in //(для загрузки первой части изображений коллекции)
                Photo(imageUrl: "https://picsum.photos/200/300?random=\(Int.random(in: 1...1000))")
            }
//            var newPhotos: [Photo] = []
//            for _ in 1...21 {
//                let url = "https://picsum.photos/200/300?random=\(Int.random(in: 1...1000))"
//                let photo = Photo(imageUrl: url)
//                newPhotos.append(photo)
//            }
            self.photos.append(contentsOf: newPhotos)
            self.currentPage += 1
            self.isLoading = false
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPhotoCell.identifier, for: indexPath) as! GridPhotoCell
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let cardVC = PhotoCardViewController(photo: photo)
        cardVC.onLikeTapped = { [weak self] updatedPhoto in
            self?.photos[indexPath.item] = updatedPhoto
            collectionView.reloadItems(at: [indexPath])
        }
        present(cardVC, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8 * 4 // Отступы для 3 столбцов
        let width = (collectionView.frame.width - padding) / 3 //ширина ячейки
        return CGSize(width: width, height: width * 1.5)
    }
}

// MARK: - UIScrollViewDelegate
extension GridViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        if offsetY > contentHeight - scrollViewHeight * 2 {
            loadPhotos()
        }
    }
}
