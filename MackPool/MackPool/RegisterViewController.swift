//
//  RegisterViewController.swift
//
//
//  Created by Piera Marchesini on 06/05/17.
//
//

import UIKit
import CoreLocation

class RegisterViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    var showPassword = false
    var showPassword2 = false
    
    @IBOutlet weak var nameWarning: UIImageView!
    @IBOutlet weak var tiaWarning: UIImageView!
    @IBOutlet weak var dateOfBirthWarning: UIImageView!
    @IBOutlet weak var passwordWarning: UIImageView!
    @IBOutlet weak var password2Warning: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tia: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    @IBOutlet weak var passwordEyeImage: UIImageView!
    @IBOutlet weak var password2EyeImage: UIImageView!
    
    @IBAction func viewPassword(_ sender: Any) {
        if !self.showPassword {
            password.isSecureTextEntry = false
            self.showPassword = true
            self.passwordEyeImage.image = UIImage(named: "notSee.png")
            self.passwordEyeImage.frame.origin.x -= 2
            self.passwordEyeImage.frame.origin.y -= 3
            self.passwordEyeImage.frame.size.height += 6
            self.passwordEyeImage.frame.size.width += 4
        } else {
            password.isSecureTextEntry = true
            self.showPassword = false
            self.passwordEyeImage.image = UIImage(named: "eye.png")
            self.passwordEyeImage.frame.size.height -= 6
            self.passwordEyeImage.frame.size.width -= 4
            self.passwordEyeImage.frame.origin.x += 2
            self.passwordEyeImage.frame.origin.y += 3
        }
    }
    
    
    @IBAction func viewPassword2(_ sender: Any) {
        if !self.showPassword2 {
            password2.isSecureTextEntry = false
            self.showPassword2 = true
            self.password2EyeImage.image = UIImage(named: "notSee.png")
            self.password2EyeImage.frame.origin.x -= 2
            self.password2EyeImage.frame.origin.y -= 3
            self.password2EyeImage.frame.size.height += 6
            self.password2EyeImage.frame.size.width += 4
        } else {
            password2.isSecureTextEntry = true
            self.showPassword2 = false
            self.password2EyeImage.image = UIImage(named: "eye.png")
            self.password2EyeImage.frame.size.height -= 6
            self.password2EyeImage.frame.size.width -= 4
            self.password2EyeImage.frame.origin.x += 2
            self.password2EyeImage.frame.origin.y += 3
        }
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(sender:UIButton) {
        dateOfBirth.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //DataPicker na data de nascimento
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: .touchUpInside)
        
        dateOfBirth.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
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
    
    @IBAction func registerButton(_ sender: Any) {
        var fieldsFilled = true
        let name = self.name.text
        let tia = self.tia.text
        let dateOfBirth = self.dateOfBirth.text
        let password = self.password.text
        let password2 = self.password2.text
        
        if (name?.characters.count)! < 5 {
            fieldsFilled = false
            nameWarning.isHidden = false
        } else {
            nameWarning.isHidden = true
        }
        
        if tia?.characters.count != 8 {
            fieldsFilled = false
            tiaWarning.isHidden = false
        } else {
            tiaWarning.isHidden = true
        }
        
        if dateOfBirth == "" {
            fieldsFilled = false
            dateOfBirthWarning.isHidden = false
        } else {
            dateOfBirthWarning.isHidden = true
        }
        
        if (password?.characters.count)! < 4 {
            fieldsFilled = false
            passwordWarning.isHidden = false
        } else {
            passwordWarning.isHidden = true
        }
        
        if password != password2 {
            fieldsFilled = false
            password2Warning.isHidden = false
        } else {
            password2Warning.isHidden = true
        }
        
        
        
        //Date(self.dateOfBirth)
        if fieldsFilled {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            let dateObject = dateFormatter.date(from: dateOfBirth!)
            
            let user = Usuario(tia: tia!, nome: name!, email: "\(tia!)@mackenzista.com.br", dataNascimento: dateObject!, foto: "", currentLocation: CLLocation())
            FirebaseController.instance.registerUser(usuario: user, senha: password!)
            
            presentAlert()
        }
        
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    func presentAlert(){
        let registerAlert = UIAlertController(title: "Cadastro realizado", message: "\nVerifique seu e-mail Mackenzista para confirmar sua conta.\n\nSe você tiver dúvida sobre como acessar clique em \"Mais\"", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            //vai pra tela de login
            self.performSegue(withIdentifier: "toLogin", sender: self)
        })
        let moreAction = UIAlertAction(title: "Mais", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            //Vai para a tela de explicação do e-mail
            self.performSegue(withIdentifier: "toEmailMackenzista", sender: self)
        })
        registerAlert.view.tintColor = UIColor(hex: "e11423")
        registerAlert.addAction(moreAction)
        registerAlert.addAction(okAction)
        registerAlert.preferredAction = okAction
        self.present(registerAlert, animated: true, completion: nil)
    }
}
