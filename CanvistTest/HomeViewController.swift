//
//  ViewController.swift
//  CanvistTest
//
//  Created by Mahmudul Hasan on 8/12/23.
//

import UIKit
import PhotosUI

class HomeViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImagesFromUserDefaults()
    }


    @IBAction func AddPhotosButton(_ sender: UIBarButtonItem) {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 4
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
        
    }
}

extension HomeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imageArray.append(image)
                }
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadData()
                }
                
                self.saveImagesToUserDefaults()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        imageArray.count
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.photoImageView.image = imageArray[indexPath.row]
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 3 , height: collectionView.frame.size.height / 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension HomeViewController {
    func saveImagesToUserDefaults() {
        let imageDataArray: [Data] = imageArray.map { image in
            if let imageData = image.pngData() {
                return imageData
            }
            return Data()
        }

        UserDefaults.standard.set(imageDataArray, forKey: "savedImages")
    }
    
    func loadImagesFromUserDefaults() {
           if let imageDataArray = UserDefaults.standard.array(forKey: "savedImages") as? [Data] {
               let loadedImages: [UIImage] = imageDataArray.compactMap { data in
                   UIImage(data: data)
               }

               imageArray = loadedImages

               photoCollectionView.reloadData()
           }
       }
}
