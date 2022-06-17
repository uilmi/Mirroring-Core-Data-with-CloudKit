//
//  CollectionViewController.swift
//  Photo_Gallery
//
//  Created by David Gunawan on 28/03/22.
//

import UIKit



private let reuseIdentifier = "collectionCell"

class CollectionViewController: UICollectionViewController {
    let photoDAO = PhotoDAO()
    let product = ProductModel()
    var photos: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserverForNotification()
        setupData()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupData() {
        photos = product.populatePhotos()
        let photosFromCoreData = photoDAO.fetchPhotos()
        photos.insert(contentsOf: photosFromCoreData, at: photos.count)
    }
    
    private func setupObserverForNotification(){
        let persistentContainer=photoDAO.coreDataHelper.container
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchChanges),
            name: .NSPersistentStoreRemoteChange,
            object: persistentContainer?.persistentStoreCoordinator
        )
    }
    @objc
    func fetchChanges (){
        print( "Just received a NSPersistentStoreRemoteChange notification")
    //setupData()
        DispatchQueue.main.async{
            self.setupData()
            self.collectionView.reloadData()
        }
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        collectionView
            .setCollectionViewLayout(layout, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        performSegue(withIdentifier: "detailVC", sender: photo)
    }
    
    @IBAction func pressAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addPhotoVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let nextView = segue.destination as? DetailPhotoViewController
            nextView?.initData(product: (sender as? ProductModel)!)
        } else if segue.identifier == "addPhotoVC" {
            let nextView = segue.destination as? AddPhotoViewController
            nextView?.title = "Add Photo"
        }
    }
    
    @IBAction func performUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let newPhotoVC = sender.source as? AddPhotoViewController else { return }
        let title = newPhotoVC.titleTextField.text
        let image = newPhotoVC.myPhoto.image
        photos.append(ProductModel(photoImage: image, photoTitle: title))
        photoDAO.insertPhoto(title: title, image: image?.pngData())
        collectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell)!
        let chosenPhoto = photos[indexPath.row]
        cell.photoImage.image = chosenPhoto.photoImage
        cell.photoTitle.text = chosenPhoto.photoTitle
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout

        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 16, height: 190)
    }
    
    
}



