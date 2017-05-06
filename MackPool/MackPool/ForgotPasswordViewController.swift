//
//  ForgotPasswordViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 05/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    let firebase = FirebaseController.instance
    @IBOutlet weak var tiaTextField: UITextField!
    @IBOutlet weak var tiaView: UIView!
    
    @IBAction func resetPassword(_ sender: Any) {
        if tiaTextField.text != "" && tiaTextField.text?.characters.count == 8 {
            firebase.resetPassword(forTia: tiaTextField.text!, yes: {
                //Foi enviado
                let resetPasswordAlert = UIAlertController(title: "Link enviado", message: "\nVerifique seu e-mail Mackenzista para redefinir sua senha.\n\nSe você tiver dúvida sobre como acessar clique em \"Mais\"", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    //vai pra tela de login
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                })
                let moreAction = UIAlertAction(title: "Mais", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    //Vai para a tela de explicação do e-mail
                    self.performSegue(withIdentifier: "toEmailMackenzista", sender: self)
                })
                resetPasswordAlert.view.tintColor = UIColor(hex: "e11423")
                resetPasswordAlert.addAction(moreAction)
                resetPasswordAlert.addAction(okAction)
                resetPasswordAlert.preferredAction = okAction
                self.present(resetPasswordAlert, animated: true, completion: nil)
            }, no: {
                //Não foi enviado
                let errorAlert = UIAlertController(title: "Erro", message: "Não foi possível identificar o número do TIA, digite novamente", preferredStyle: .alert)
                errorAlert.view.tintColor = UIColor(hex: "e11423")
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                errorAlert.addAction(OkAction)
                self.present(errorAlert, animated: true, completion:nil)
            })
        } else {
            //Mostrar aviso que errou
            tiaView.shake()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
