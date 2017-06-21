//
//  CreatePatienViewController.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit

protocol createPatienDelegate : AnyObject {
    func createPatien(patien :Patien)
}

class CreatePatienViewController: UIViewController {
    
    @IBOutlet weak var describe: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var gender: UISwitch!
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var progress: UIProgressView!
    //Rajout d'une progressBar pour simuler l'appel d'un serveur pour utiliser les threads
    @IBOutlet weak var progressAppelServeur: UIProgressView!
    
    var progressDescribe: Float = 0.0
    var progressLastName: Float = 0.0
    var progressFirstName: Float = 0.0
    
    var addBlock : Bool = false
    
    weak var delegate:createPatienDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
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
    
    @IBAction func fieldLastName(_ sender: UITextField) {
        guard lastName.text != "" else {
            progressLastName = 0
            progression()
            return
        }
        
        progressLastName = 0.3
        progression()
    }
    
    @IBAction func fieldFirstName(_ sender: UITextField) {
        guard firstName.text != "" else {
            progressFirstName = 0
            progression()
            return
        }
        
        progressFirstName = 0.3
        progression()
    }

    @IBAction func fieldDescribe(_ sender: UITextField) {
        guard describe.text != "" else {
            progressDescribe = 0
            progression()
            return
        }
        
        progressDescribe = 0.4
        progression()
        
    }
    
    func progression(){
        var progressGlobal: Float
        progressGlobal = progressDescribe + progressLastName + progressFirstName
        
        progress.setProgress(progressGlobal, animated: true)
        
        guard progress.progress != 1 else {
            buttonAdd.isEnabled = true;
            return
        }
        
        buttonAdd.isEnabled = false;

    }
    
    @IBAction func addPatien(_ sender: Any) {
        
        guard !addBlock else {
            return
        }
        
        addBlock = true;
        
        let genre: Patien.Genre
        
        if gender.isOn {
            genre = Patien.Genre.homme
        }else{
            genre = Patien.Genre.femme
        }
        let name: String = lastName.text!
        let prenom: String = firstName.text!
        let description: String = describe.text!
        
        let people = Patien(nom: name, prenom: prenom, genre: genre, commentaire: description)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            for _ in 0..<100{
                
                Thread.sleep(forTimeInterval : 0.05)
                
                let progression : Float
                
                progression = self.progressAppelServeur.progress + 0.01
                
                DispatchQueue.main.async {
                    
                    self.progressAppelServeur.setProgress(progression, animated: true)
                    
                    self.progressAppelServeur.progressTintColor = UIColor(red: CGFloat(1-progression), green: CGFloat(progression), blue: 0, alpha: 1.0)
                }
                
            }
            
            self.delegate?.createPatien(patien: people)
            
        }

    }
    
}
