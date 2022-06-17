//
//  AddPhotoViewController.swift
//  Photo_Gallery
//
//  Created by Haryanto Salim on 06/04/22.
//

import UIKit
import PhotosUI

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var myPhoto: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    func setupForm(){
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapGesture(sender:)))
        myPhoto.isUserInteractionEnabled = true //because default is not userInteractionEnabled
        myPhoto.addGestureRecognizer(tapGesture)
    }
    
    @objc func handlePhotoTapGesture(sender: Any?){
        // Check the app's authorization status (either read/write or add-only access)
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        print(readWriteStatus.rawValue)

        // Request read-write access to the user's photo library.
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                // The user hasn't determined this app's access.
                print("notDetermined")
            case .restricted:
                // The system restricted this app's access.
                print("restricted")
            case .denied:
                // The user explicitly denied this app's access.
                print("denied")
            case .authorized:
                // The user authorized this app to access Photos data.
                print("authorized")
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.allowsEditing = true
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            case .limited:
                // The user authorized this app for limited Photos access.
                print("limited")
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .savedPhotosAlbum
                    vc.allowsEditing = true
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            @unknown default:
                fatalError()
            }
        }
    }
    
    @IBAction func pressCancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        myPhoto.image = image
    }
    
    @IBAction func pressSaveButton(_ sender: Any) {
        if titleTextField.text != "" && myPhoto.image != UIImage(systemName: "photo") {
            performSegue(withIdentifier: "backToMemoriesPage", sender: self)
        }
    }
}
