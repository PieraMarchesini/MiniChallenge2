//
//  EmailMackenzistaViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 06/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class EmailMackenzistaViewController: UIViewController {
    
    @IBAction func accessURL(_ sender: Any) {
        //Mostra uma actionSheet
        let mackenzistaMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Ações da ActionSheet
        let activateAction = UIAlertAction(title: "Ativar e-mail Mackenzista", style: .default) {
            (alert: UIAlertAction!) in
            UIApplication.shared.open(URL(string: "http://gerti.mackenzie.br/tutoriais/windows-7/ativacao-do-e-mail-mackenzista-alunos/")!, options: [:], completionHandler: nil)
        }
        let logInAction = UIAlertAction(title: "Entrar no e-mail Mackenzista", style: .default) {
            (alert: UIAlertAction!) in
            UIApplication.shared.open(URL(string: "https://outlook.office365.com/owa/?realm=mackenzie.br")!, options: [:], completionHandler: nil)
        }
        //Ação de cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) {
            (alert: UIAlertAction!) in
            print("Cancelar")
        }
        //Adiciona as actions ao Alert
        mackenzistaMenu.addAction(activateAction)
        mackenzistaMenu.addAction(logInAction)
        mackenzistaMenu.addAction(cancelAction)
        //Mostrar o ActionSheet
        mackenzistaMenu.view.tintColor = UIColor(hex: "032749")
        self.present(mackenzistaMenu, animated: true, completion: nil)
    }
    override func viewDidLoad() {
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
