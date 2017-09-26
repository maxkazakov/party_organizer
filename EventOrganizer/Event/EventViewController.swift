//
//  EventViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventImageButton: UIImageView!
    
    var presenter: EventPresenter!
    
    private var image: UIImage?
    
    @IBAction func cancelAction(_ sender: Any) {
        eventNameTextField.resignFirstResponder()
        routing(with: .dismiss)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        defer {
            eventNameTextField.resignFirstResponder()
            routing(with: .dismiss)
        }
        var eventName = "New event".tr()
        if let text = eventNameTextField.text, !text.isEmpty {
           eventName = text
        }
        
        presenter.saveEvent(name: eventName, image: image)
    }
    
    
    @IBAction func tapToImageAction(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.becomeFirstResponder()
        eventNameTextField.delegate = self
        eventImageButton.layer.cornerRadius = 50
        eventImageButton.layer.masksToBounds = true
        eventImageButton.layer.borderWidth = 0.5
        
        let event = presenter.getEventViewData() ?? EventViewData.zero
        fill(from: event)
    }

    
    
    func fill(from event: EventViewData){
        eventImageButton.image = event.image
        eventNameTextField.text = event.name
        
        self.title = event.name.isEmpty ? "New event".tr() : event.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Image selection
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.image = RBSquareImageTo(image: selectedImg, size: CGSize(width: 300, height: 300))
        eventImageButton.image = self.image
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveAction(self)
        return true
    }

}
