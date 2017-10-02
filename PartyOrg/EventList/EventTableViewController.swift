//
//  EventTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData
import ImageSource

struct EventViewData{
    var name: String
    var image: UIImage
    var budget: Double
    var source: LocalImageSource?
    
    static let zero = EventViewData(name: "", image: UIImage(named: "DefaultEventImage")!, budget: 0.0, source: nil)
} 

class EventTableViewController: UITableViewController, UITextFieldDelegate {

    var presenter: EventTablePresenter!
    var newIndexPath: IndexPath?
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        if presenter.getEventsCount() == 0 {
            return
        }
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        editButton.image = isEditing ? #imageLiteral(resourceName: "edit_bar") :  #imageLiteral(resourceName: "cancel_bar")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        setupStyle()
        
        title = "Event list".tr()
        presenter.setFetchControllDelegate(delegate: self)
        
        editButton.image = #imageLiteral(resourceName: "edit_bar")
        self.navigationItem.leftBarButtonItem = editButton
        
        
        addNewEventButton.callback = {
            [unowned self] in
            self.routing(with: .createOrEditEvent)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // автоматически открываем редактирование
        if let path = newIndexPath{
            self.presenter.selectRow(path)
            routing(with: .selectEvent)
        }
        newIndexPath = nil
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count  = presenter.getEventsCount()
        if count == 0 {
            editButton.image = #imageLiteral(resourceName: "edit_bar")
            tableView.backgroundView = addNewEventButton
            tableView.separatorStyle = .none
        }
        else {
            tableView.backgroundView = nil 
            tableView.separatorStyle = .singleLine
        }
        return count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = presenter.getEventViewData(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell", for: indexPath) as! EventTableViewCell
        
        cell.configure(data: event)
        cell.name.text = event.name
        cell.img.image = event.image

        return cell
    }
    
    
    
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            presenter.delete(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectRow(indexPath)
        routing(with: .selectEvent)
    }
    
    
    
    // MARK: Outlets
    
    @IBAction func newEventAction(_ sender: Any) {
        routing(with: .createOrEditEvent)
    }
    
    
    
    // MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: -Private
    
    private let addNewEventButton = AddNewItemButton(type: .bill, accentText: "no_events".tr())
}




extension EventTableViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let path = newIndexPath else{
                return
            }
            tableView.insertRows(at: [path], with: .automatic)
            self.newIndexPath = path
            
        case .update:
            guard let path = newIndexPath else{
                return
            }
            
            self.tableView.reloadRows(at: [path], with: .automatic)
            
        case .delete:
            guard let path = indexPath else{
                return
            }
            tableView.deleteRows(at: [path], with: .automatic)
            
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
