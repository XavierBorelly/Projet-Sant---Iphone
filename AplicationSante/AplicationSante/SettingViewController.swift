//
//  SettingViewController.swift
//  AplicationSante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var switchOrdre: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rapel de la variable de setting "isNameOrdre" dans le switch pour éviter de la modifier par mégarde
        let ordreName = UserDefaults.standard.value(forKey: "isNameOrdre") as? Bool ?? true

        switchOrdre.setOn(ordreName, animated: true)
        
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
    
    //sauvegarde de la variable de setting "isNameOrdre" en cas de modification du switch
    @IBAction func saveOrdre(_ sender: Any) {
        UserDefaults.standard.set(switchOrdre.isOn, forKey : "isNameOrdre")
    }

    @IBAction func closeSetting(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
