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
    
    var patient: PatienData!
    @IBOutlet weak var avatar: UIImageView!
    
    
    @IBOutlet weak var commentaireLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ordreName = UserDefaults.standard.value(forKey: "isNameOrdre") as? Bool ?? true
        
        self.title = patient.nomComplet(ordreName: ordreName)
        
        commentaireLabel.text = patient.commentaire
        
        
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePatien))
        
        self.navigationItem.rightBarButtonItem = button
        
        /*var urlRequest = URLRequest(url: URL(string: patient.pictureURL!)!)
        
        urlRequest.httpMethod = "get"
        
        
        URLSession.shared.downloadTask(with: urlRequest) {(fileURL, URLResponse, error)
            in
            
            if let fileURL = fileURL, let image = UIImage(contentsOfFile: fileURL.absoluteString){
                
                self.avatar.image = image
            }
            
            print(error)
            print(URLResponse)
        }*/
        
        URLSession.shared.dataTask(with: URL(string: patient.pictureURL!)!){(data, response, error) in
            print(Thread.isMainThread)
            
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    
                    print(Thread.isMainThread)

                    self.avatar.image = image
                }
            }
        }.resume()
        
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
