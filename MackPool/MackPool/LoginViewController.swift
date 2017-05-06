//
//  LoginViewController.swift
//  MackPool
//
//  Created by Julio Brazil on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var showPassword : Bool!
    let firebase = FirebaseController.instance
    @IBOutlet weak var tia: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var imagePassword: UIImageView!

    @IBAction func forgotPasswordPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: self)
    }
    
    @IBAction func seePassword(_ sender: Any) {
        if !self.showPassword {
            senha.isSecureTextEntry = false
            self.showPassword = true
            self.imagePassword.image = UIImage(named: "notSee.png")
            self.imagePassword.frame.origin.x -= 2
            self.imagePassword.frame.origin.y -= 3
            self.imagePassword.frame.size.height += 6
            self.imagePassword.frame.size.width += 4
        } else {
            senha.isSecureTextEntry = true
            self.showPassword = false
            self.imagePassword.image = UIImage(named: "eye.png")
            self.imagePassword.frame.size.height -= 6
            self.imagePassword.frame.size.width -= 4
            self.imagePassword.frame.origin.x += 2
            self.imagePassword.frame.origin.y += 3
        }
    }
    @IBAction func enviarButtonWasPressed(_ sender: Any) {
        //        firebase.autenticateUser(email: "\(tia.text!)@mackenzista.com", senha: senha.text!)
        firebase.autenticateUser(email: "\(tia.text!)@mackenzista.com.br", senha: senha.text!, completion: {
            self.firebase.checkEmailVerification(yes: { () -> Void in
                self.performSegue(withIdentifier: "toHome", sender: self)
            }, no: { () -> Void in
                //self.performSegue(withIdentifier: "toEmailInfo", sender: self)
            })
        })
    }
    
    override func viewDidLoad() {
        FirebaseController.instance.signUserOut()
        showPassword = false
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        UIApplication.shared.delegate?.window??.backgroundColor = UIColor(hex: "990011")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForgotPassword" {
            if segue.destination is ForgotPasswordViewController {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = false
    }

}
