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
    @IBOutlet weak var eventImageButton: UIButton!
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    var presenter: EventPresenter!
    
    @IBAction func cancelAction(_ sender: Any) {
        eventNameTextField.resignFirstResponder()
        routing(with: .dismiss)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        defer {
            eventNameTextField.resignFirstResponder()
            routing(with: .dismiss)
        }
        
        let image = eventImageButton.backgroundImage(for: .normal) ?? UIImage(named: "DefaultEventImage")
        
        let text = eventNameTextField.text ?? "New event"
       
        presenter.saveEvent(name: text, image: image!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.becomeFirstResponder()
        self.title = "New event"
        if let event = presenter.getEventViewData() {
            fill(from: event)
        }
    }

    func fill(from event: EventViewData){
        eventImageButton.setBackgroundImage(event.image, for: .normal)
        eventImageButton.setTitle("", for: .normal)
        eventNameTextField.text = event.name
        self.title = event.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Image selection
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        eventImageButton.setBackgroundImage(selectedImg.resize(), for: .normal)
        eventImageButton.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveAction(self)
        return true
    }

}
