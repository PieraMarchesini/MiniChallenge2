//
//  CadatroViewController.swift
//  MackPool
//
//  Created by Julio Brazil on 03/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreLocation

class CadatroViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tia: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var nascimento: UIDatePicker!
    @IBOutlet weak var senha1: UITextField!
    @IBOutlet weak var senha2: UITextField!
    
    @IBAction func sendButtonWasClicked(_ sender: Any) {
        var ok = true
        
//        if self.tia.text == "" {
//            self.tiaAviso.alpha = 1
//            ok = false
//        } else {
//            self.tiaAviso.alpha = 0
//        }
//        
//        if self.nome.text == "" {
//            self.nomeAviso.alpha = 1
//            ok = false
//        } else {
//            self.nomeAviso.alpha = 0
//        }
//        
//        if self.senha1.text == "" {
//            self.senhaAviso.alpha = 1
//            ok = false
//        } else {
//            self.senhaAviso.alpha = 0
//        }
//        
//        if senha1.text != senha2.text {
//            self.senhasAviso.alpha = 1
//            ok = false
//        } else {
//            self.senhasAviso.alpha = 0
//        }
        
        if ok {
            let user = Usuario(tia: self.tia.text!, nome: self.nome.text!, email: "\(self.tia.text!)@mackenzista.com.br", dataNascimento: Utils.stringToDate("\(self.nascimento.date)"), foto: "", currentLocation: CLLocation())
            
            FirebaseController.instance.registerUser(usuario: user, senha: self.senha1.text!)
        }
    }

    // Mark: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tia.delegate = self
        self.nome.delegate = self
        self.senha1.delegate = self
        self.senha2.delegate = self
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(hex: "FDFDFD")]
        
        super.viewDidLoad()
        nascimento.setValue(UIColor.white, forKeyPath: "textColor")
        nascimento.datePickerMode = .date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
