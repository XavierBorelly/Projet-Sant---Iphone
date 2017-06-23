//
//  CreatePatienViewController.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit
import CoreData


protocol createPatienDelegate : AnyObject {
    func createPatien(prenom: String, name: String, urlImage: String)
}

class CreatePatienViewController: UIViewController {
    
    
    
    @IBOutlet weak var describe: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var urlImage: UITextField!
    
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
    
    /**
     * fonction permettant en cas de changement de donnée sur le UITextField (nom) de faire avancer la progressBar de complétion
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
    
    /**
     * fonction permettant en cas de changement de donnée sur le UITextField (prenom) de faire avancer la progressBar de complétion
     */
    @IBAction func fieldFirstName(_ sender: UITextField) {
        guard firstName.text != "" else {
            progressFirstName = 0
            progression()
            return
        }
        
        progressFirstName = 0.3
        progression()
    }
    
    /**
     * fonction permettant en cas de changement de donner sur le UITextField (description) de faire avancer la progressBar de complétion
     */
    @IBAction func fieldDescribe(_ sender: UITextField) {
        guard describe.text != "" else {
            progressDescribe = 0
            progression()
            return
        }
        
        progressDescribe = 0.4
        progression()
        
    }
    
    /**
     * factorisation de la fonction permettant de faire avancer la progressBar de complétion utiliser dans les code plus haut
     */
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
    
    /**
     * fonction permettant l'ajout du patien dans la base de donnée
     */
    @IBAction func addPatien(_ sender: Any) {
        
        //Si on a déjà appuyer sur le bouton, on le verrouille pour éviter des inserts multiples
        guard !addBlock else {
            return
        }
        addBlock = true;
        
        //désactivation du genre et de la description, non suporter par le serveur
        //let genre: Bool = gender.isOn
        //let description: String = describe.text!
        
        //récupération du nom, du prénom, et de l'URL de l'image
        let name: String = lastName.text!
        let prenom: String = firstName.text!
        let lienImage:String
        
        if self.urlImage.text != ""{
            lienImage = self.urlImage.text!
        }else{
            lienImage = "https://tchat.chaat.fr/kiwi/assets/plugins/avatar-undefined.jpg"
        }
        
        //Création d'un thread pour une tache asynchrone (remplissage d'une progressBar pour simuler un appel serveur)
        DispatchQueue.global(qos: .userInitiated).async {
            
            for _ in 0..<100{
                
            
                Thread.sleep(forTimeInterval : 0.05)
                
                let progression : Float
                
                progression = self.progressAppelServeur.progress + 0.01
                
                //Mais appel du thread main pour la modification graphique
                DispatchQueue.main.async {
                    
                    self.progressAppelServeur.setProgress(progression, animated: true)
                    
                    self.progressAppelServeur.progressTintColor = UIColor(red: CGFloat(1-progression), green: CGFloat(progression), blue: 0, alpha: 1.0)
                }
                
            }
            
            Thread.sleep(forTimeInterval : 0.75)
            
            
            //Puis on renvois les informations au delegate pour le traitement en BDD
            self.delegate?.createPatien(prenom: prenom, name: name, urlImage: lienImage)
            
        }
    }
}
