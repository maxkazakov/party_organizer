//
//  EventViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate{
    
    // MARK: Outlets
    
    @IBOutlet weak var eventLabel: UITextField!
    @IBOutlet weak var eventImg: UIImageView!
    
    @IBAction func viewPhoto(_ sender: Any) {
        let newImageView = UIImageView(image: eventImg.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    lazy var presenter: EventPresenter = {
        return EventPresenter(view: self)
    }()
    
    @IBAction func cancelAction(_ sender: Any) {
        eventLabel.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        eventLabel.resignFirstResponder()
        presenter.saveEvent(name: eventLabel.text!, image: eventImg.image!)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventLabel.delegate = self
        
        self.title = "New event"
        if let event = presenter.getEventViewData() {
            fill(from: event)
        }
    }

    func fill(from event: EventViewData){
        eventImg.image = event.image
        eventLabel.text = event.name
        self.title = event.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Image selection
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        eventImg.resignFirstResponder()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        eventImg.image = selectedImg.resize()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventLabel.resignFirstResponder()
        return true
    }

}
