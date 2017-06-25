//
//  EventTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData

struct EventViewData{    
    var name: String
    var image: UIImage        
}

class EventTableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {

    var presenter: EventTablePresenter!
    var events = [EventViewData]()
    var newIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = EventTablePresenter(view: self)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // автоматически открываем редактирование
        if let path = newIndexPath{
            routing(with: .selectEvent(path))
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
        return presenter.getEventsCount()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = presenter.getEventViewData(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell", for: indexPath) as! EventTableViewCell
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
        routing(with: .selectEvent(indexPath))
    }
    
   
    // MARK: NSFetchedResultsControllerDelegate
    
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
            
            let event = presenter.getEventViewData(indexPath: path)
            let cell = tableView.cellForRow(at: path) as! EventTableViewCell
            cell.name.text = event.name
            cell.img.image = event.image
            
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
    
    // MARK: Outlets
    
    @IBAction func newEventAction(_ sender: Any) {
        routing(with: .newEvent)
    }
    
    // MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
