//
//  ReadRegisters.swift
//  Connect
//
//  Created by Rafael Goncalves on 20/11/2017.
//  Copyright © 2017 Rafael Goncalves. All rights reserved.
//

import Foundation

class ReadRegisters {
    var kill = false
    var cont = 0
    var stateFail = 0
    var stateReadRegisters = 1
    var state = 0
    let READ_HOLDING_REGISTERS : UInt8 = 0x03
    let SOF : UInt8 = 0x5A
    let id : UInt8 = 0
    
    func run(){
       
//        Dispatch.async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            // Download file or perform expensive task
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                // Update the UI
//            }
//        }
            if((stateReadRegisters == 1) && (state == 2)){
                if(sendRHR(addr: 0,size: 100)){
                    print("Send RHR1")
                    print("state \(state)")
                    stateReadRegisters = 2;
                }
            }
        
    }
    
    
    
    func sendRHR(addr : Int, size : Int) -> Bool{
        
        
        let executeTransaction = self.executeTransaction(function: READ_HOLDING_REGISTERS, initReg: addr, nroReg: size, value: 0x00)
        
        let b : [UInt8] = mountCommand(advType: 0xFF, modbusPacket: executeTransaction)
                               
    
        return writeCustomCharacteristic(data: b)
    }
    
    func writeCustomCharacteristic(data : [UInt8]) -> Bool{
         let dataValue = NSData(bytes: data, length: 12)
        print("\nValor enviado = \(dataValue)")
        
        //JUST CALL WRITE
        //self.connectingPeripheral!.writeValue(data as Data, for: self.connectingCharac!, type: CBCharacteristicWriteType.withoutResponse)
        return true
    }
    
    func mountCommand(advType : UInt8, modbusPacket : [UInt8]) -> [UInt8]{
        
        var data : [UInt8]!   //[5 + modbusPacket.count + 2]
        
        //var i = 0
    
        //StartFrame
        data[0] = SOF
    
        //PacketType
        data[1] = advType
    
        //PacketId
        data[2] = id
    
        return [0x5A, 0xFF, 0x00, 0x00, 0x05,0x03, 0x00, 0x00, 0x00,0x64,0x53,0x2C]
    }


    //Comandos Comuns
    func executeTransaction(function : UInt8, initReg : Int, nroReg : Int, value : Int ) -> [UInt8]{
        var i = 0
        var data : [UInt8]!
    
        switch(function) {
            case 3, 70:
                data[i] = 3
                i = i + 1
            
                data[i] = 0xFF
                i = i + 1
                data[i] = 0xFF
                i = i + 1
                data[i] = 0xFF
                i = i + 1
                data[i] = 100
                i = i + 1
                return data
    
            case 6, 71:
                  //ESCRITA
//                data[i] = (byte) (function & 0xFF);
//                i++;
//
//                data[i] = (byte) ((initReg >> 8) & 0xFF);;
//                i++;
//                data[i] = (byte) (initReg & 0xFF);
//                i++;
//                data[i] = (byte) ((value >> 8) & 0xFF);;
//                i++;
//                data[i] = (byte) (value & 0xFF);;
//                i++;
//                return data;
                return data
            default:
                return data
        }
    }
    
    
    
    
}



