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

    @IBAction func resetPassword(_ sender: Any) {
        if tiaTextField.text != "" {
            firebase.resetPassword(forTia: tiaTextField.text!, yes: {
                //Foi enviado
                let resetPasswordAlert = UIAlertController(title: "Link enviado", message: "Verifique seu e-mail Mackenzista para redefinir sua senha.\nSe você tiver dúvida sobre como acessar o e-mail Mackenzista clique em \"Mais\"", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    //vai pra tela de login
                })
                let moreAction = UIAlertAction(title: "Mais", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    //Vai para a tela de explicação do e-mail
                })
                resetPasswordAlert.addAction(okAction)
                resetPasswordAlert.addAction(moreAction)
                self.present(resetPasswordAlert, animated: true, completion: nil)
            }, no: {
                //Não foi enviado
                let errorAlert = UIAlertController(title: "Erro", message: "Não foi possível identificar o TIA, digite novamente", preferredStyle: .alert)
                
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    print("Funcionouuuuuuu")
                })
                errorAlert.addAction(OkAction)
                self.present(errorAlert, animated: true, completion:nil)
            })
        } else {
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
