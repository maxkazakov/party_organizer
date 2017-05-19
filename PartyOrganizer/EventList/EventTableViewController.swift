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

protocol EventTableView: class{
    func getTableView() -> UITableView
}

class EventTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var presenter: EventTablePresenter!
    var events = [EventViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = EventTablePresenter(view: self)        
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
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destController = segue.destination as? EventViewController  else {
            return
        }

        if segue.identifier == "editEvent"{
            guard let selectedCell = sender as? EventTableViewCell else{
                return
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                return
            }

            destController.presenter.event = presenter.getEvent(indexPath: indexPath)
        }
     }
    
    // MARK: EventTableView Protocol
    func getTableView() -> UITableView{
        return self.tableView
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
   
}
