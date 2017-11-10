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
    var connectingPeripheral: CBPeripheral!
    var connectingCharac: CBCharacteristic!

    var peripherals = Array<CBPeripheral>()
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func refreshBLE(sender: UIButton) {
        //   centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        var bytes = NSData(bytes: [0x5A, 0xB1, 0xFA, 0xBB, 0xC0, 0x3D, 0xFE, 0x34,0x45,0xCD,0x00,0x54,0x25,0x62,0x36,0x22] as [UInt8], length: 16)
        var bytesData = [UInt8]("0x01".utf8)
        
        let writeData = NSData (bytes: &bytes, length: bytesData.count)
        let value: [UInt8] = [0x5A, 0xB1, 0xFA, 0xBB, 0xC0, 0x3D, 0xFE, 0x34,0x45,0xCD,0x00,0x54,0x25,0x62,0x36,0x22]
        let data = NSData(bytes: value, length: 16)
        //  let data = "01:00".data(using: String.Encoding.utf8)! as NSData
        // let data = NSData(bytes: &bytes, length: 1)
        self.connectingPeripheral.writeValue(data as Data, for: self.connectingCharac, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startUpCentralManager()
    }
    
    func startUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
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
        self.connectingPeripheral = peripheral
        self.tableView.reloadData()
      //  centralManager.stopScan()
       // self.centralManager.connect(peripheral, options: nil)
        
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
            discoverDevices()
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        //        if characteristic.isNotifying {
        //            activePeripheral!.readValueForCharacteristic(characteristic)
        //        }
        print("update notifcation")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        self.connectingPeripheral = peripheral
        
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager!,didConnectPeripheral peripheral: CBPeripheral!){
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "F000AA00-0451-4000-B000-000000000000")])
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
        
        let characteristicUUID = CBUUID(string: "0783B03E-8535-B5A0-7140-A304D2495CBA")
        let properties: CBCharacteristicProperties = [.notify, .read, .Write]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions)
        service.characteristics = characteristic
        
        if let charactericsArr = service.characteristics{
            for charactericsx in charactericsArr{
                peripheral.setNotifyValue(true, for: charactericsx)
                
                print("\n\(charactericsx.properties.rawValue)\n")
                
                //                *************************
                if charactericsx.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CBA"{
                    output(description: "Characteristic", data: charactericsx)
                    
                    
                    //var parameter = NSInteger(1)
                    var bytes = NSData(bytes: [0x5A, 0xB1, 0xFA, 0xBB, 0xC0, 0x3D, 0xFE, 0x34,0x45,0xCD,0x00,0x54,0x25,0x62,0x36,0x22] as [UInt8], length: 16)
                    var bytesData = [UInt8]("0x01".utf8)
                    let writeData = NSData (bytes: &bytes, length: bytesData.count)
                    let value: [UInt8] = [0x5A, 0xB1, 0xFA, 0xBB, 0xC0, 0x3D, 0xFE, 0x34,0x45,0xCD,0x00,0x54,0x25,0x62,0x36,0x22]
                    let data = NSData(bytes: value, length: 16)
                    //  let data = "01:00".data(using: String.Encoding.utf8)! as NSData
                   // let data = NSData(bytes: &bytes, length: 1)
                    peripheral.writeValue(data as Data, for: charactericsx, type: CBCharacteristicWriteType.withResponse)
                    output(description: "Characteristic", data: charactericsx)
                }
                //                *************************
                
                peripheral.readValue(for: charactericsx)
            }
            
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            print("\n***RESPOSTA \n\nDEU RUIM NO WRITE VALUE FOR CHARACTERISTIC    = \(String(describing: error))\nE AQUI TA A PROPRIEDADE DA CHARACTERISTIC \(characteristic.properties.rawValue) \n AQUI TA CHARACTERISTIC INTEIRA \(characteristic)\n\n")
            return
        }
        
        print("ENVIEI O PASSWORD\(characteristic)")
        peripheral.setNotifyValue(true, for: characteristic)
        print("INFORMACOES DO PERIPHERAL \(peripheral)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if error != nil {
            print("DEU RUIM NO WRITE VALUE FOR DESCRIPTOR    = \(String(describing: error)) ")
            return
        }
        
        print("ENVIEI O PASSWORD E ESSE É O DESCRIPTOR \(descriptor)")
    }
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("ERROR ON UPDATING VALUE FOR CHARACTERISTIC: \(characteristic) - \(String(describing: error?.localizedDescription))")
            return
        }
    
        print("ENTREI NO DID UPDATE VALUE FOR CHARACTERISTIC = \(String(describing: peripheral)) E NOTIFY = \(characteristic)")
        self.connectingCharac = characteristic
        self.connectingPeripheral = peripheral
        
        let string =  String(data: characteristic.value!, encoding: .utf8)
        print("VAMOOOOOOOOOOOO\(String(describing: string))")
        
//        if let string = String(data: characteristic.value!, encoding: .utf8) {
//            print(string)
//        } else {
//            print("not a valid UTF-8 sequence")
//        }
    }
    
    func output(description: String, data: AnyObject){
        print("\(description): \(data)")
        textView.text = textView.text + "\(description): \(data)\n"
    }
    
}



extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectPeripheral = self.peripherals[indexPath.row]
        //    self.peri = selectPeripheral
        connectBluetooth(peripheral: selectPeripheral)
 
      //  self.performSegue(withIdentifier: "goConnect", sender: selectPeripheral)
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

