//
//  Patien.swift
//  AplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import Foundation

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
        
    func nomComplet () -> String {
        return "\(genre.rawValue) \(nom) \(prenom)"
    }
    
    func commentaireShow() -> String {
        return self.commentaire
    }
}
