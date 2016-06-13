//
//  ViewController.swift
//  Peticion al servidor
//
//  Created by Timo Siegle on 08.06.16.
//  Copyright © 2016 Timo Siegle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Campo de texto que permite la captura del ISBN
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var resultView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        inputField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text!.isEmpty {
            let alertController = UIAlertController(title: "Missing ISBN", message:
                "Please enter a ISBN and try again!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            textField.resignFirstResponder()
            let reachability: Reachability
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                return false
            }
            
            if reachability.isReachable() {
                self.fetchBookDetails(textField.text!)
            } else {
                
                // En caso de falla en Internet, se muestra una alerta indicando ese problema
                let alertController = UIAlertController(title: "Internet connection", message:
                    "Please check your connection and try again!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return true
        }
    }
    
    // La marca de "limpiar" en la caja de texto aparece todo el tiempo
    @IBAction func clearInput() {
        inputField.text = ""
        resultView.text = ""
    }
    
    func fetchBookDetails(isbn: String) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL: url!)
        let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        
        //Se muestra el resultado en concordancia al ISBN ingresado
        self.resultView.text = texto! as String
    }
}

