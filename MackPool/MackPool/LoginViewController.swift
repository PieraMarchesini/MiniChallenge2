//
//  LoginViewController.swift
//  MackPool
//
//  Created by Julio Brazil on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let firebase = FirebaseController.instance
    @IBOutlet weak var tia: UITextField!
    @IBOutlet weak var senha: UITextField!

    @IBAction func enviarButtonWasPressed(_ sender: Any) {
        //        firebase.autenticateUser(email: "\(tia.text!)@mackenzista.com", senha: senha.text!)
        firebase.autenticateUser(email: "\(tia.text!)@mackenzista.com", senha: senha.text!, completion: {
            self.firebase.checkEmailVerification(yes: { () -> Void in
                self.performSegue(withIdentifier: "toHome", sender: self)
            }, no: { () -> Void in
                //self.performSegue(withIdentifier: "toEmailInfo", sender: self)
            })
        })
    }
    
    override func viewDidLoad() {
        FirebaseController.instance.signUserOut()
        
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

}
