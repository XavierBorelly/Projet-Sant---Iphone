//
//  PatienTableViewController.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit

class PatienTableViewController: UITableViewController {

    var patients = [Patien]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let masculin = Patien.Genre.homme
        let feminin = Patien.Genre.femme
        
        let people1 = Patien(nom: "borelly", prenom: "martine", genre: feminin, commentaire: "Ab clementer nunc inlustris dictum discrevimus Hierapoli discrevimus clementer hac inlustris Osdroenam prima prima vetere Samosata Hierapoli Hierapoli nunc inlustris dictum civitatibus Euphratensis Euphratensis post hac Hierapoli quam clementer prima clementer ut civitatibus hac vetere nunc Nino et est discrevimus.")
        let people2 = Patien(nom: "borelly", prenom: "stephane", genre: masculin, commentaire: "Memoriam odium nostri depulisse idcirco constat praetereo relinquo ad dictionem leges acerbissimum dictionem et civitate.")
        
        patients.append(people1)
        patients.append(people2)
        
        self.tableView.reloadData()
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateViewController))
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    func showCreateViewController(){
        let controller = CreatePatienViewController(nibName: "CreatePatienViewController", bundle: nil)
        
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
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
        // #warning Incomplete implementation, return the number of rows
        return patients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patienCell", for: indexPath)

        // Configure the cell...
        let textCell: String = String(indexPath.row+1) + " " + patients[indexPath.row].nomComplet()
        cell.textLabel?.text = textCell
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailViewController =  segue.destination as? DetailViewController {
            
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            detailViewController.onDeletePersonne = {
                self.patients.remove(at: selectedIndexPath.row)
                self.tableView.reloadData()
                
                self.navigationController?.popViewController(animated: true)
            }
            
            detailViewController.patient = patients[selectedIndexPath.row]
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
    func createPatien(patien: Patien) {
        
        patients.append(patien)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
}
