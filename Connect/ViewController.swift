//
//  ViewController.swift
//  Bluetooth
//
//  Created by Rafael Krentz Gonçalves on 09/11/17.
//  Copyright © 2017 krentz. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    var centralManager:CBCentralManager!
    var blueToothReady = false
    var connectingPeripheral: CBPeripheral?
    var connectingCharac: CBCharacteristic?

    var peripherals = Array<CBPeripheral>()
    var response = Array<String>()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func refreshBLE(sender: UIButton) {
        
        
        let value: [UInt8] = [0x5A, 0xFF, 0x00, 0x00, 0x05,0x03, 0x00, 0x00, 0x00,0x64,0x53,0x2C]
        let data = NSData(bytes: value, length: 12)
        print("\nValor enviado = \(data)")
        
//                let characteristicUUID = CBUUID(string: self.connectingCharac.uuid.uuidString)
//                let properties: CBCharacteristicProperties = [.notify, .read, .write]
//                let permissions: CBAttributePermissions = [.readable, .writeable]
//                let characteristic = CBCharacteristic(
//
//                    type: characteristicUUID,
//                    properties: properties,
//                    value: nil,
//                    permissions: permissions)
//                //service.characteristics = characteristic
//
//
//
        
        self.connectingPeripheral!.writeValue(data as Data, for: self.connectingCharac!, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    @IBAction func showResponse(_ sender: Any) {
        print(self.response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
   
    func connectBluetooth(peripheral: CBPeripheral){
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name != nil {
            if !peripherals.contains(peripheral) || peripherals.count == 0 {
                peripherals.append(peripheral)
                output(description: "Discovered", data: peripheral.name as AnyObject)
                print(peripheral)
            }
        }
        self.tableView.reloadData()
        
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        switch (central.state) {
        case .poweredOff:
            msg = "CoreBluetooth BLE hardware is powered off"
            print("\(msg)")
            
        case .poweredOn:
            msg = "CoreBluetooth BLE hardware is powered on and ready"
            blueToothReady = true;
            
        case .resetting:
            msg = "CoreBluetooth BLE hardware is resetting"
            
        case .unauthorized:
            msg = "CoreBluetooth BLE state is unauthorized"
            
        case .unknown:
            msg = "CoreBluetooth BLE state is unknown"
            
        case .unsupported:
            msg = "CoreBluetooth BLE hardware is unsupported on this platform"
            
        }
        output(description: "State", data: msg as AnyObject)
        
        if blueToothReady {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        print("Update notifcation")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        self.connectingPeripheral = peripheral
        
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager!,didConnectPeripheral peripheral: CBPeripheral!){
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "F000AA00-0451-4000-B000-000000000000")])   //all services  --logbox: 0783B03E-8535-B5A0-7140-A304D2495CB7
        output(description: "Connected", data: peripheral.name as AnyObject)
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripherals = peripheral.services{
            for servicePeripheral in servicePeripherals{
                output(description: "Service", data: servicePeripheral.uuid)

                peripheral.discoverCharacteristics(nil, for: servicePeripheral)
                
            }
            
        }
    }
    
   
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let charactericsArr = service.characteristics{
            for charactericsx in charactericsArr{
                
                //notify
                if charactericsx.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CB8"{
                    peripheral.setNotifyValue(true, for: charactericsx)
                   // peripheral.readValue(for: charactericsx)
                }
                
                //read
                if charactericsx.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CB9"{
                  // peripheral.setNotifyValue(true, for: charactericsx)
                    //peripheral.readValue(for: charactericsx)
                }
                
                //write
                if charactericsx.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CBA"{
                   self.connectingCharac = charactericsx
                   
                    let value: [UInt8] = [0x5A, 0xB1, 0xFA, 0xBB, 0xC0, 0x3D, 0xFE, 0x34,0x45,0xCD,0x00,0x54,0x25,0x62,0x36,0x22]
                    let data = NSData(bytes: value, length: 16)
                    peripheral.writeValue(data as Data, for: charactericsx, type: CBCharacteristicWriteType.withoutResponse)
                }
                
            }
            
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            print("\n***RESPOSTA \n\nDEU RUIM NO WRITE VALUE FOR CHARACTERISTIC    = \(String(describing: error))\nE AQUI TA A PROPRIEDADE DA CHARACTERISTIC \(characteristic.properties.rawValue) \nAQUI TA CHARACTERISTIC INTEIRA \(characteristic)\n\n")
            return
        }
        
        print("\nPASSWORD ENVIADO COM SUCESSO! \nPeripheral = \(peripheral) \nCharacteristic = \(characteristic) \n")
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("ERROR ON UPDATING VALUE FOR CHARACTERISTIC: \(characteristic) - \(String(describing: error?.localizedDescription))")
            return
        }
    
        print("ENTREI NO DID UPDATE VALUE FOR: \nPeripheral = \(String(describing: peripheral)) \nCharacteristic = \(characteristic)")
        
        //converting "bytes" in string
        let string =  String(data: characteristic.value!, encoding: .utf8)
        print("Resposta = \(String(describing: string))\n")
        
        if string != nil  && string!.range(of:"AOK") == nil{
            self.response.append(string!)
        }
        
    }
    
   
    func output(description: String, data: AnyObject){
        print("\(description): \(data)")
        textView.text = textView.text + "\(description): \(data)\n"
    }
    
}



extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectPeripheral = self.peripherals[indexPath.row]
        connectBluetooth(peripheral: selectPeripheral)
 
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
}

