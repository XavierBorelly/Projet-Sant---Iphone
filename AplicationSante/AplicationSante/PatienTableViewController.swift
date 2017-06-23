//
//  PatienTableViewController.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit
import CoreData


class PatienTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<PatienData>!
    let apiPersonURL = "http://10.1.0.100:3000/persons"
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let buttonSetting = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showSettingViewController))
        
        self.navigationItem.leftBarButtonItem = buttonSetting
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateViewController))
        
        self.navigationItem.rightBarButtonItem = button
        
        
        
        let fetchRequest = NSFetchRequest<PatienData>(entityName: "PatienData")
        let sort = NSSortDescriptor(key: "nom", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: BDD.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "PersonData")
        
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BDD.refressFromServer()
    }
    
    func showCreateViewController(){
        let controller = CreatePatienViewController(nibName: "CreatePatienViewController", bundle: nil)
        
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func showSettingViewController(){
        let controller = SettingViewController(nibName: "SettingViewController", bundle: nil)
        
        
        self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patienCell", for: indexPath)

        
        let ordreName = UserDefaults.standard.value(forKey: "isNameOrdre") as? Bool ?? true
        
        // Configure the cell...
        let textCell: String = String(indexPath.row+1) + " " + fetchedResultController.object(at: indexPath).nomComplet(ordreName: ordreName)
        cell.textLabel?.text = textCell
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailViewController =  segue.destination as? DetailViewController {
            
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let persistentContainer = BDD.persistentContainer
            
            detailViewController.onDeletePersonne = {
                let patient = self.fetchedResultController.object(at: selectedIndexPath)
                persistentContainer.viewContext.delete(patient)
                
                do{
                    try persistentContainer.viewContext.save()
                }catch{
                    print(error)
                }
                
                self.tableView.reloadData()
                
                self.navigationController?.popViewController(animated: true)
            }
            
            detailViewController.patient = self.fetchedResultController.object(at: selectedIndexPath)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PatienTableViewController: createPatienDelegate{
    func createPatien(prenom: String, name: String, urlImage: String) {
        
        var json = [String:String]()
        json["surname"] = prenom
        json["lastname"] = name
        json["pictureUrl"] = urlImage
        
        var request = URLRequest(url:URL(string:self.apiPersonURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                guard (jsonDict as? [String : Any]) != nil else {
                    return
                }
                
                
                DispatchQueue.main.async{
                    
                    self.BDD.saveContext()
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
        task.resume()
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PatienTableViewController : NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}

