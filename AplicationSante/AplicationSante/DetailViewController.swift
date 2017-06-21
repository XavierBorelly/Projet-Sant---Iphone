//
//  DetailViewController.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var onDeletePersonne: (() -> ())?
    
    var patient: Patien!
    @IBOutlet weak var avatar: UIImageView!
    
    
    @IBOutlet weak var commentaireLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = patient.nomComplet()
        commentaireLabel.text = patient.commentaireShow()
        
        if patient.genre == Patien.Genre.homme {
            
            avatar.image = #imageLiteral(resourceName: "masculin")
        }else{
            
            avatar.image = #imageLiteral(resourceName: "feminin")
        }
        
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePatien))
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    func deletePatien(){
        
        let alert = UIAlertController(title: "Alert", message: nil, preferredStyle: UIAlertControllerStyle.alert)

        let destroyAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { action in
            self.onDeletePersonne?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        
        alert.addAction(cancelAction)
        alert.addAction(destroyAction)
        
        self.present(alert, animated: true)
        //o
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
