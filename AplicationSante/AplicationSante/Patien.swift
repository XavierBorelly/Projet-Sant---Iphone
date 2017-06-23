//
//  Patien.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import Foundation

/**
 * extension de la classe Patien pour les donner du CoreData (Réécriture du genre qui passe de Enum à Bool
 */
extension PatienData{
    func nomComplet (ordreName : Bool) -> String {
                
        let gender = genre 
    
        
        let particule : String
        
        if gender {
            particule =  "M."
        } else {
            particule = "Mme."
        }
                
        if ordreName {
            return particule + " " + prenom! + " " + nom!
        } else{
            return particule + " " + nom! + " " + prenom!
        }
    }
}

/**
 * classe Patien possédant un nom, un prenom, un commentaire en String et un genre (enum propre a la classe)
 */
class Patien{
    enum Genre:String {
        case homme = "M."
        case femme = "Mme."
    }
    
        
    let genre: Genre
    let nom: String
    let prenom: String
    let commentaire: String
    
    init(nom: String, prenom: String, genre: Genre, commentaire: String) {
        self.nom = nom
        self.prenom = prenom
        self.commentaire = commentaire
        self.genre = genre
            
    }
        
    func nomComplet (ordreName : Bool) -> String {
        if ordreName {
            return "\(genre.rawValue) \(prenom) \(nom)"
        } else{
            return "\(genre.rawValue) \(nom) \(prenom)"
        }
    }
    
    func commentaireShow() -> String {
        return self.commentaire
    }
}
