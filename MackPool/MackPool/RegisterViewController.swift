//
//  RegisterViewController.swift
//  
//
//  Created by Piera Marchesini on 06/05/17.
//
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate {
    
    
    var date: Date?
    var timePicker: UIDatePicker?
    
    func initDatePicker() {
        if self.timePicker == nil {
            self.timePicker = UIDatePicker()
            self.timePicker!.datePickerMode = UIDatePickerMode.date
            self.timePicker!.addTarget(self, action: #selector(RegisterViewController.updateDate), for: UIControlEvents.valueChanged)
            self.timePicker!.minimumDate = Date()
            self.timePicker!.backgroundColor = .white
            self.dateOfBirth.inputView = self.timePicker
            self.dateOfBirth.inputAccessoryView = self.createPickerToolBar()
        }
    }
    
    func updateDate() {
        let picker: UIDatePicker = self.dateOfBirth.inputView as! UIDatePicker
        self.dateOfBirth.text = picker.date.
            //picker.date.stringFromDate(kDateFormatSlash)
        self.date = picker.date
        //self.delegate?.didIntroduceText(self.actionTextView.text.characters.count != 0 && self.searchableTableView?.getText().characters.count != 0 && self.dateLabel.text!.characters.count != 0)
    }
    
    func createPickerToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegisterViewController.doneAction))
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: kOpenSansRegular, size: kHeaderFontSize)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        doneButton.accessibilityLabel = "DoneToolbar"
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.isTranslucent = false
        toolbar.sizeToFit()
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
    
    func doneAction() {
        self.updateDate()
        self.dateOfBirth.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    

    @IBOutlet weak var dateOfBirth: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
