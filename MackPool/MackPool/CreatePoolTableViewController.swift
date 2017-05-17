//
//  CreatePoolTableViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 08/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreLocation

protocol MeetingPointViewControllerDelegate {
<<<<<<< HEAD
    func didReceiveAddressFromMeetingPointViewController(address: String?, coordinate: CLLocationCoordinate2D?)
=======
    func didReceiveAddressFromMeetingPointViewController(address: String)
>>>>>>> 38656614f850fa1c54ed7f53d7266aa1e727cf62
}

class CreatePoolTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, MeetingPointViewControllerDelegate {
    
    let pickerMeioTransporteData = ["Carro", "A pé", "Bicicleta", "Transporte público"]
    let pickerMaxIntegrantes = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
    let meioTransportePicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
    let maxIntegrantesPicker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
    
    let mackenzieCoordinate = CLLocation(latitude: -23.547333693803449, longitude: -46.652063392102718)
    
    @IBOutlet weak var partidaMack: UISwitch!
    @IBOutlet weak var destinoMack: UISwitch!
    
    var place: CLLocation!
    
    @IBOutlet weak var pontoEncontro: UILabel!
    
    @IBOutlet weak var horario: UITextField!
    @IBOutlet weak var meioDeTransporte: UITextField!
    @IBOutlet weak var maxUsuarios: UITextField!
    
    @IBAction func toPartidaMack(_ sender: Any) {
        if partidaMack.isOn {
            destinoMack.isOn = false
        } else {
            destinoMack.isOn = true
        }
    }
    @IBAction func toDestinoMack(_ sender: Any) {
        if destinoMack.isOn {
            partidaMack.isOn = false
        } else {
            partidaMack.isOn = true
        }
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        horario.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(sender:UIButton) {
        horario.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func done2Button(sender:UIButton) {
        meioDeTransporte.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func done3Button(sender:UIButton) {
        maxUsuarios.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meioTransportePicker.delegate = self
        meioTransportePicker.dataSource = self
        maxIntegrantesPicker.delegate = self
        maxIntegrantesPicker.dataSource = self
        
        //Horário - PickerView
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.time
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: .touchUpInside)
        
        horario.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        //TransportePublico
        let inputView2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        inputView2.addSubview(meioTransportePicker) // add date picker to UIView
        
        let doneButton2 = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton2.setTitle("Done", for: UIControlState.normal)
        doneButton2.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton2.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView2.addSubview(doneButton2) // add Button to UIView
        doneButton2.addTarget(self, action: #selector(done2Button(sender:)), for: .touchUpInside)
        
        meioDeTransporte.inputView = inputView2
        //meioTransportePicker.addTarget(self, action: #selector(handleTranspPicker(sender:)), for: .valueChanged)
        
        //MaxUsuarios
        let inputView3 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        //let datePickerView: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        //datePickerView.datePickerMode = UIDatePickerMode.time
        inputView3.addSubview(maxIntegrantesPicker) // add date picker to UIView
        
        let doneButton3 = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton3.setTitle("Done", for: UIControlState.normal)
        doneButton3.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton3.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView3.addSubview(doneButton3) // add Button to UIView
        doneButton3.addTarget(self, action: #selector(done3Button(sender:)), for: .touchUpInside)
        
        maxUsuarios.inputView = inputView3
        //meioTransportePicker.addTarget(self, action: #selector(handleTranspPicker(sender:)), for: .valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == meioTransportePicker {
            return pickerMeioTransporteData.count
        }
        if pickerView == maxIntegrantesPicker {
            return pickerMaxIntegrantes.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == meioTransportePicker {
            return pickerMeioTransporteData[row]
        }
        if pickerView == maxIntegrantesPicker {
            return pickerMaxIntegrantes[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == meioTransportePicker {
            meioDeTransporte.text = pickerMeioTransporteData[row]
        }
        if pickerView == maxIntegrantesPicker {
            maxUsuarios.text = pickerMaxIntegrantes[row]
        }
    }
    
<<<<<<< HEAD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "meetingPoint" {
            if let destination = segue.destination as? MeetingPointViewController {
                destination.delegate = self
            }
        }
    }
    
    func didReceiveAddressFromMeetingPointViewController(address: String?, coordinate: CLLocationCoordinate2D?) {
        place = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
=======
    func didReceiveAddressFromMeetingPointViewController(address: String) {
        print("Endereço: \(address)")
>>>>>>> 38656614f850fa1c54ed7f53d7266aa1e727cf62
        pontoEncontro.text = address
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "meetingPoint" {
            
            if let destination = segue.destination as? MeetingPointViewController {
                    destination.delegate = self
            }
        }
    }
    
    
    @IBAction func createPoolPressed(_ sender: Any) {
        let transp: Int
        switch meioDeTransporte.text! {
        case "Carro":
            transp = 0
        case "A pé":
            transp = 1
        case "Bicicleta":
            transp = 2
        case "Transporte público":
            transp = 3
        default:
            transp = -1
        }
        
        var flagToMack = false
        let rotaMack = Rota()
        if destinoMack.isOn {
            flagToMack = true
            //Destino é o mackenzie
            rotaMack.destino = mackenzieCoordinate
                //Partida é o ponto de encontro
                rotaMack.partida = place
        }
        
        if partidaMack.isOn {
            //ponto de encontro
             rotaMack.destino = place
             rotaMack.partida = mackenzieCoordinate
        }
        
        let group = Group(lider: FirebaseController.instance.getCurrentUserId(), maxUsuarios: Int(maxUsuarios.text!)!, privacidade: false, horario: horario.text!, local: place, meioTransporte: transp, rotaMack: rotaMack, toMack: flagToMack)
        
        FirebaseController.instance.saveGroup(group)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Table view data source
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let meetingPoint = tableView.dequeueReusableCell(withIdentifier: "horario", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }*/
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
