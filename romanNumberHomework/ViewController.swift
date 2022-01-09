//
//  ViewController.swift
//  romanNumberHomework
//
//  Created by Muhammed Süha Demirel on 9.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var romanNumberTextField: UITextField!
    @IBOutlet weak var resultViewLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(goToFavButtonClicked))
        // Do any additional setup after loading the view.
        romanNumberTextField.text = ""
        resultViewLabel.text = ""
    }
    
    @objc func goToFavButtonClicked(){
        performSegue(withIdentifier: "toFavVC", sender: nil)
    }

    @IBAction func addFavClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "FavItems", into: context)
        
        //Attributes
        
        if resultViewLabel.text != "" && resultViewLabel.text != "doğru formatta roman rakamı giriniz" {
            newFav.setValue(romanNumberTextField.text!, forKey: "romanNumber")
            newFav.setValue(resultViewLabel.text!, forKey: "normalNumber")
            newFav.setValue(UUID(), forKey: "id")
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
        }
    }
    
    @IBAction func convertClicked(_ sender: Any) {
        var romanianNumbDictionary = ["MU": "4000", "M": "1000", "CM": "900", "D": "500", "CD": "400", "C": "100", "XC": "90", "L": "50", "XL": "40", "X": "10", "IX": "9", "V":"5", "IV": "4", "I": "1"]
        
        let input: String = romanNumberTextField.text!
        resultViewLabel.text = romanianNumbDictionary[input]
        var i = 0
        var result = 0
        while i < input.count {
            var searchForTwo = input.prefix(i+2).suffix(2)
            var searchForOne = input.prefix(i+1).suffix(1)
            
            if i+1 < input.count && romanianNumbDictionary[String(searchForTwo)] != nil{
                print(searchForTwo)
                var subResult = Int(romanianNumbDictionary[String(searchForTwo)]!)!
                result += subResult
                resultViewLabel.text = String(result)
                romanianNumbDictionary = changeDicn(inpDict: romanianNumbDictionary, target: String(searchForTwo))
                i += 2
            }
            else if ( romanianNumbDictionary[String(searchForOne)] != nil){
                print(searchForOne)
                var subResult = Int(romanianNumbDictionary[String(searchForOne)]!)!
                result += subResult
                resultViewLabel.text = String(result)
                romanianNumbDictionary = changeDicn(inpDict: romanianNumbDictionary, target: String(searchForOne))
                i += 1
            }
            else{
                // Alert Olarak yapalım
                let alert = UIAlertController(title: "Wrong Format", message: "doğru formatta roman rakamı giriniz", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    self.romanNumberTextField.text = ""
                    self.resultViewLabel.text = ""
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)

                break;
            }
        }
    }
    
    func changeDicn (inpDict: [String: String], target: String) -> [String: String]{
        var resultDict = inpDict
        for key in resultDict.keys{
            if Int(resultDict[key]!)! > Int(resultDict[target]!)!  {
                resultDict.removeValue(forKey: key)
            }
        }
        return resultDict
    }
}
