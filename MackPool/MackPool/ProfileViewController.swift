//
//  ProfileViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logOut(_ sender: Any) {
        let lougOutAlert = UIAlertController(title:"Sair do Mack Pool?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Sair", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            //Log out do aplicativo
            FirebaseController.instance.signUserOut()
            self.performSegue(withIdentifier: "Logout", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler: nil)
        lougOutAlert.view.tintColor = UIColor(hex: "e11423")
        lougOutAlert.addAction(cancelAction)
        lougOutAlert.addAction(okAction)
        lougOutAlert.preferredAction = cancelAction
        self.present(lougOutAlert, animated: true, completion: nil)
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}
