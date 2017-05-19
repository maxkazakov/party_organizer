//
//  EventViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var eventLabel: UITextField!

    @IBOutlet weak var eventImg: UIImageView!
    
    lazy var presenter: EventPresenter = {
        return EventPresenter(view: self)
    }()
    
    @IBAction func saveAction(_ sender: Any) {        
        presenter.changeEvent(name: eventLabel.text!, image: eventImg.image!)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let event = presenter.getEventViewData() else{
            return
        }
        
        fill(from: event)
    }

    func fill(from event: EventViewData){
        eventImg.image = event.image
        eventLabel.text = event.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


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
        eventImg.image = selectedImg.getImage(withQuality: UIImage.JPEGQuality.lowest)
        dismiss(animated: true, completion: nil)
    }
    

}
