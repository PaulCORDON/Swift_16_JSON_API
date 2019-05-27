//
//  ViewController.swift
//  Currency Converter
//
//  Created by MAC-DIN-002 on 23/05/2019.
//  Copyright © 2019 MAC-DIN-002. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    /*cette fonction est appellée quand on appuie sur la loupe de la bar de recherche*/
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getCurrency(currency : searchBar.text!)
        searchBar.text = ""
    }
    
    func getCurrency(currency : String){
        let accessKey = "5ffc4d3810743c0ba70949371a8801a5"
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=\(accessKey)&symbols=USD,CAD,CHF,EUR&format=1&base=\(currency)")
        /*Pour autoriser l'accès aux sites http il faut aller dans Info.plist ajouter App Transport Security Settings puis y ajouter Allow Arbitrary Loads et mettre YES */
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "problème de récupération des données", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true , completion: nil)
            }else{
                if data != nil{
                    do{
                        /*on récupère les données*/
                        let jSONResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                        /*cette fonction est appellée une fois les données récupérées*/
                        DispatchQueue.main.async {
                            print(jSONResult)
                            /*exemple de jSONResult :
                             ["timestamp": 1558599785, "rates": {
                             CAD = "1.499237";
                             CHF = "1.124052";
                             EUR = 1;
                             USD = "1.113722";
                             }, "base": EUR, "date": 2019-05-23, "success": 1]*/
                            
                            /*on traite les données*/
                            //print(jSONResult["base"]!)
                            /*exemple de jSONResult ["base"] : EUR */
                            if let rates = jSONResult["rates"] as? [String : AnyObject]{
                                let usd = String(describing: rates["USD"]!)
                                self.usdLabel.text = "USD : \(usd)"
                                
                                let cad = String(describing: rates["CAD"]!)
                                self.cadLabel.text = "CAD : \(cad)"
                                
                                let chf = String(describing: rates["CHF"]!)
                                self.chfLabel.text = "CHF : \(chf)"
                                
                                let eur = String(describing: rates["EUR"]!)
                                self.eurLabel.text = "EUR : \(eur)"
                            }else{
                                var msg = ""
                                if let error = jSONResult["error"] as? [String : AnyObject]{
                                    msg = error["type"] as! String
                                }else{
                                    msg = "erreur avec l'API"
                                }
                                let alert = UIAlertController(title: "Error API", message: msg, preferredStyle: UIAlertController.Style.alert)
                                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert,animated: true , completion: nil)
                            }
                        }

                    } catch{
                        
                    }
                }
                
            }
        }
        task.resume()
    }

}

