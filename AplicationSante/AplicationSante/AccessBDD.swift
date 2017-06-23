//
//  accessBDD.swift
//  AplicationSante
//
//  Created by Admin on 22/06/2017.
//  Copyright © 2017 com.formation. All rights reserved.
//

import Foundation
import CoreData

/**
 * classe d'acces à la base de donnée externe permettant de gerer des objet PatienData
 */
class AccessBDD {
    
    var persistentContainer: NSPersistentContainer
    // MARK: - Core Data Saving support
    
    init() {
        
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.persistentContainer = container
        
        
    }
    
    let apiPersonURL = "http://10.1.0.100:3000/persons"
    
    func refressFromServer(){
        
        let url = URL(string:apiPersonURL)!
        
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            
            guard let data = data else {
                return
            }
            
            let dictionnary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            guard let jsonDict = dictionnary as? [[String : Any]] else {
                return
            }
            
            self.updateFromJsonData(json: jsonDict)
            
        }
        
        task.resume()
    }
    
    
    func updateFromJsonData (json: [[String : Any]]){
        
        
    
        let fetchRequest = NSFetchRequest<PatienData>(entityName: "PatienData")
        let sort = NSSortDescriptor(key: "nom", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let persons = try! persistentContainer.viewContext.fetch(fetchRequest)
        
        for person in persons{
            persistentContainer.viewContext.delete(person)
        }
        
        do{
            try persistentContainer.viewContext.save()
        }catch{
            print(error)
        }
        
        for dict in json{
            
            print(dict)
            let firstName = dict["surname"] as? String ?? "Error"
            let lastName = dict["lastname"] as? String ?? "Error"
            let pictureURL = dict["pictureUrl"] as? String ?? "https://tchat.chaat.fr/kiwi/assets/plugins/avatar-undefined.jpg"
            let id = dict["id"] as? Int64 ?? 0
            
            let isMale = dict["gender"] as? Bool ?? true
            let commentaire = dict["commentaire"] as? String ?? ""
            
            let people = PatienData(entity: PatienData.entity(), insertInto: persistentContainer.viewContext)
            people.prenom = firstName
            people.nom = lastName
            people.genre = isMale
            people.pictureURL = pictureURL
            people.commentaire = commentaire
            people.serveurId = id
            
            
        }
        
        do{
            try persistentContainer.viewContext.save()
        }catch{
            print(error)
        }

    }
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
