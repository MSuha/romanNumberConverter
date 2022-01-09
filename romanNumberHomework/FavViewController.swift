//
//  FavViewController.swift
//  romanNumberHomework
//
//  Created by Muhammed Süha Demirel on 9.01.2022.
//

import UIKit
import CoreData

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favTableView: UITableView!
    
    var normalNumberArray = [String]()
    var romanNumberArray = [String]()
    var idArray = [UUID]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTableView.delegate = self
        favTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        normalNumberArray.removeAll(keepingCapacity: false)
        romanNumberArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavItems")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                                if let normalNumber = result.value(forKey: "normalNumber") as? String {
                                    self.normalNumberArray.append(normalNumber)
                                }
                                
                                if let romanNumber = result.value(forKey: "romanNumber") as? String {
                                    self.romanNumberArray.append(romanNumber)
                                }
                    
                                if let id = result.value(forKey: "id") as? UUID {
                                    self.idArray.append(id)
                                }
                                self.favTableView.reloadData()
                            }
            }
            

        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalNumberArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(romanNumberArray[indexPath.row]) -> \(normalNumberArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavItems")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                normalNumberArray.remove(at: indexPath.row)
                                romanNumberArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.favTableView.reloadData()
                                do {
                                    try context.save()
                                    
                                } catch {
                                    print("error")
                                }
                                
                                break
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
            } catch {
                print("error")
            }
        }
    }

}
