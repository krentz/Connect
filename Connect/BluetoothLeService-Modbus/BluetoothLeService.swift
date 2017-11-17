//
//  BluetoothLeService.swift
//  Connect
//
//  Created by Rafael Goncalves on 16/11/2017.
//  Copyright © 2017 Rafael Goncalves. All rights reserved.
//

import Foundation

/**
 * Service for managing connection and data communication with a GATT server hosted on a
 * given Bluetooth LE device.
 */
class BluetoothLeService {
    
    var indexPacket : Int?
    var sizePacket : Int?
    var canVerify : Bool = false
    var packetFinished : Bool?
    var packet : [UInt8]? //260
    var CanaisHabilitados : Int = 0
    
    
    //Fabio Coelho Vetores criados exclusivamente para se conseguir calcular os valores de uma coleta, foi o unico jeito que encontrei
    // para resolver isso com a logica tosca que esta coleta foi implementada.
    var alarmHigh: [Float]?
    var alarmLow : [Float]?
    var chIsDigital : [Bool]?
    var channelsDecimalPlaces : [Int]?
    var channelsSensorTypes : [Int]?
    //-----------------------------------
   
    
    var sessionOpened : UInt8?
    var  status : UInt8?
   
    //***************************************************************************
    static let TAG : String = "self.getSimpleName()"
    static let TAG2 : String = "LOGCHART-BLE"
   
    
    //***************************************************************************
    //BluetoothManager mBluetoothManager
    //BluetoothGatt mBluetoothGatt;
    
    var mBluetoothDeviceAddress : String?
    var mConnectionState = STATE_DISCONNECTED;
    var RSSI : Int = 0
    var mAddress : [Int8]? //6
    var passwordSent : Bool = false
    var passwordReceived : Bool = false
    
    var state : Int = 0
    var stateReadRegisters : Int = 1
    var stateRRForDownload : Int = 0
    var stateKeepAlive : Int = 0
    
    static let STATE_DISCONNECTED : Int = 0
    static let STATE_CONNECTING : Int = 1
    static let  STATE_CONNECTED : Int = 2
    
    static let NOVUS_SERVICE_UUID = "0783B03E-8535-B5A0-7140-A304D2495CB7"//service
    static let NOVUS_CHARACTERISTIC_UUID1 = "0783B03E-8535-B5A0-7140-A304D2495CB8"//ReadData, Notify
    static let NOVUS_CHARACTERISTIC_UUID2 = "0783B03E-8535-B5A0-7140-A304D2495CB9"//FlowControl
    static let NOVUS_CHARACTERISTIC_UUID3 = "0783B03E-8535-B5A0-7140-A304D2495CBA"//WriteData
    
    static let ACTION_GATT_CONNECTED : String = "com.example.bluetooth.le.ACTION_GATT_CONNECTED"
    static let ACTION_GATT_DISCONNECTED : String = "com.example.bluetooth.le.ACTION_GATT_DISCONNECTED"
    static let ACTION_GATT_SERVICES_DISCOVERED : String = "com.example.bluetooth.le.ACTION_GATT_SERVICES_DISCOVERED"
    static let ACTION_DATA_AVAILABLE : String = "com.example.bluetooth.le.ACTION_DATA_AVAILABLE"
    static let EXTRA_DATA : String = "com.example.bluetooth.le.EXTRA_DATA"
    
    static let UUID_HEART_RATE_MEASUREMENT : String = "00002a37-0000-1000-8000-00805f9b34fb"
    
    static let SS_SERVICO_EM_ANDAMENTO : UInt8 = 1
    static let SS_RESPOSTA_SEM_ERRO : UInt8 = 3
    
    var regCRC : Int?

    var crcLow : UInt8?
    var crcHigh : UInt8?
    
    //***************************************************************************
    //public SendPassword pwThread;
    //public DownloadThread download;
    
    var stateApplyConfig : Int = 0
    var stateStartStop : Int = 0
    var crc : Int = 0x0000
    
    var table = [
        0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
        0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
        0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
        0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
        0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
        0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
        0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
        0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
        0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
        0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
        0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
        0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
        0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
        0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
        0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
        0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
        0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
        0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
        0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
        0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
        0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
        0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
        0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
        0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
        0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
        0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
        0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
        0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
        0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
        0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
        0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
        0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040,
    ]
    
    static let EXTENDED = [ 0x00C7, 0x00FC, 0x00E9, 0x00E2,
        0x00E4, 0x00E0, 0x00E5, 0x00E7, 0x00EA, 0x00EB, 0x00E8, 0x00EF,
        0x00EE, 0x00EC, 0x00C4, 0x00C5, 0x00C9, 0x00E6, 0x00C6, 0x00F4,
        0x00F6, 0x00F2, 0x00FB, 0x00F9, 0x00FF, 0x00D6, 0x00DC, 0x00A2,
        0x00A3, 0x00A5, 0x20A7, 0x0192, 0x00E1, 0x00ED, 0x00F3, 0x00FA,
        0x00F1, 0x00D1, 0x00AA, 0x00BA, 0x00BF, 0x2310, 0x00AC, 0x00BD,
        0x00BC, 0x00A1, 0x00AB, 0x00BB, 0x2591, 0x2592, 0x2593, 0x2502,
        0x2524, 0x2561, 0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557,
        0x255D, 0x255C, 0x255B, 0x2510, 0x2514, 0x2534, 0x252C, 0x251C,
        0x2500, 0x253C, 0x255E, 0x255F, 0x255A, 0x2554, 0x2569, 0x2566,
        0x2560, 0x2550, 0x256C, 0x2567, 0x2568, 0x2564, 0x2565, 0x2559,
        0x2558, 0x2552, 0x2553, 0x256B, 0x256A, 0x2518, 0x250C, 0x2588,
        0x2584, 0x258C, 0x2590, 0x2580, 0x03B1, 0x00DF, 0x0393, 0x03C0,
        0x03A3, 0x03C3, 0x00B5, 0x03C4, 0x03A6, 0x0398, 0x03A9, 0x03B4,
        0x221E, 0x03C6, 0x03B5, 0x2229, 0x2261, 0x00B1, 0x2265, 0x2264,
        0x2320, 0x2321, 0x00F7, 0x2248, 0x00B0, 0x2219, 0x00B7, 0x221A,
        0x207F, 0x00B2, 0x25A0, 0x00A0 ]
    
    static let POS_MEI_TYPE : UInt8 = 0x0E
    static let POS_READ_ID_CODE : UInt8 = 0x01
    static let POS_OBJECT_ID : UInt8 = 0x01
    
    static let SOF : Int8 = 0x5A
   
    
   static let OPEN_SESSION : UInt8 = 1
   static let CLOSE_SESSION : UInt8 = 2
   static let START_LOG : UInt8 = 3 //StartStop
   static let STOP_LOG : UInt8 = 4 //StartStop
   static let CHANGE_PASSWORD : UInt8 = 5
    
    static let SESSION_NONE : UInt8 = 0
    static let SESSION_CONFIGURATION : UInt8 = 1
    static let SESSION_CALIBRATION : UInt8 = 2
    static let SESSION_DOWNLOAD : UInt8 = 3
    static let SESSION_SOFTWARE : UInt8 = 4
    static let SESSION_START_STOP : UInt8 = 5 //StartStop - 01 65 03 05 53 74 61 72 74 53 74 6F
    
    
    var password : [UInt8]?  // [8];
    static let CALIB_SESSION_PASSWORD : [UInt8] = [0x4E, 0x4F, 0x61, 0x6C, 0x73, 0x43, 0x50, 0x61]
    static let CR_PS_CONFIG_SESSION_PASSWORD_0 : [UInt8] = [0x43, 0x6F, 0x6E, 0x66, 0x69, 0x67, 0x53, 0x65]
    static let CR_PS_START_STOP_SESSION_PASSWORD_0 : [UInt8] = [0x53, 0x74, 0x61, 0x72, 0x74, 0x53, 0x74, 0x6F] //StartStop
    static let CR_PS_DOWNLOAD_SESSION_PASSWORD_0 : [UInt8] = [0x43, 0x6F, 0x6C, 0x6C, 0x65, 0x63, 0x74, 0x53]
    static let CR_PS_SOFTWARE_SESSION_PASSWORD_0 : [UInt8] = [0x53, 0x6F, 0x66, 0x74, 0x77, 0x61, 0x72, 0x65]
    
    static let READ_HOLDING_REGISTERS : UInt8 = 0x03
    static let WRITE_MULTIPLE_REGISTERS : UInt8 = 0x10
    static let READ_DEVICE_IDENTIFICATION : UInt8 = 0x2B
    static let MENAGE_SESSION : UInt8 = 0x65
    static let SELECTIVE_DOWNLOAD : UInt8 = 0x66
    
    static let DOWNLOAD_SET : UInt8 = 0x01
    static let DOWNLOAD_GET_NEXT : UInt8 = 0x03
    
    //***************************************************************************
    // Device.shared()
    //public Device device;
   
    
    
    //public Device deviceToGraph;
    var id : Int = 0
    var totalSamplesPacket : Int = 0  //Ajuste RafaelSilva
    
    var configValues1 : [Int]? //[67];
    var configValues2 : [Int]? //new short[67];
    var configValues2temp : [Int]? //[17];
    var configValues3 : [Int]? //[67];
    var configValues4 : [Int]?  //[70];
    var configValues4temp : [Int]?  //[22];
    
    
    var aOK : [UInt8] = [0x41,0x4F,0x4B,0x0D,0x0A]
    
    var downloadBlockId : Int = 0
    
    
    public byte[] mountCommand(byte advType, byte[] modbusPacket){
        byte [] data = new byte[5 + modbusPacket.length + 2];
        int i = 0;
        
        //StartFrame
        data[0] = SOF;
        
        //PacketType
        data[1] = (byte) (0xFF & advType);
        
        //PacketId
        data[2] = (byte) (id & 0xFF);
        
        //PacketSize High
        data[3] = (byte)((modbusPacket.length >> 8) & 0xFF);
        
        //PacketSize Low
        data[4] = (byte)((modbusPacket.length)& 0xFF);
        
        i = 5;
        
        for(int j = 0; j < modbusPacket.length; j++){
            data[i] = (byte)(modbusPacket[j] & 0xFF);
            i++;
        }
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        id++;
        
        return data;
    }
    
    //Comandos Comuns
    public byte[] ExecuteTransaction(byte function, short initReg, short nroReg, short value ){
        int i = 0;
        byte [] data = new byte[5] ;
        
        switch(function) {
        case 3:
        case 70:
            
            data[i] = (byte) (function & 0xFF);
            i++;
            
            data[i] = (byte) ((initReg >> 8) & 0xFF);
            i++;
            data[i] = (byte) (initReg & 0xFF);
            i++;
            data[i] = (byte) ((nroReg >> 8) & 0xFF);
            i++;
            data[i] = (byte) (nroReg & 0xFF);
            i++;
            return data;
            
            
        case 6:
        case 71:
            
            data[i] = (byte) (function & 0xFF);
            i++;
            
            data[i] = (byte) ((initReg >> 8) & 0xFF);;
            i++;
            data[i] = (byte) (initReg & 0xFF);
            i++;
            data[i] = (byte) ((value >> 8) & 0xFF);;
            i++;
            data[i] = (byte) (value & 0xFF);;
            i++;
            return data;
            
        default:
            return null;
        }
    }
    
    public boolean WriteMultipleRegisters(short initReg, short nroReg, short[] values){
        byte [] data = new byte[13 + (2*nroReg)];
        int i;
        //StartFrame
        data[0] = SOF;
        
        Log.v("values",String.valueOf(values[0])+ ""+ String.valueOf(values[1]));
        
        //PacketType
        data[1] = (byte) (0xFF);
        
        //PacketId
        data[2] = (byte) (0x00);
        
        int size = 6 + (2*nroReg);
        
        //PacketSize High
        data[3] = (byte)((size >> 8) & 0xFF);
        
        //PacketSize Low
        data[4] = (byte)((size)& 0xFF);
        
        data[5] = WRITE_MULTIPLE_REGISTERS;
        
        data[6] = (byte) ((initReg >> 8) & 0xFF);
        
        data[7] = (byte) ((initReg) & 0xFF);
        
        data[8] = (byte) ((nroReg >> 8) & 0xFF);
        
        data[9] = (byte) ((nroReg) & 0xFF);
        
        data[10] = (byte) ((2*nroReg)&0xFF);
        
        for(i = 0; i < nroReg; i++){
            data[11 + 2*i] = (byte)((values[i] >> 8)& 0xFF) ;
            data[12 + 2*i] = (byte)((values[i]) & 0xFF);
        }
        
        i = 11 + (2*nroReg);
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        for(int j=0;j<data.length;j++)
        Log.v("WriteMultRegs",String.valueOf(j)+ " "+String.valueOf(data[j]));
        
        return writeCustomCharacteristic(data);
    }
    
    
   
    
    
    public boolean OpenSession(byte sessionType){
        int i = 0;
        int pass = 0;
        byte [] data = new byte[18];
        
        //StartFrame
        data[0] = SOF;
        
        //PacketType
        data[1] = (byte) (0xFF);
        
        //PacketId
        data[2] = (byte) (0x00);
        this.id++;
        
        //PacketSize High
        data[3] = (byte)0x00;
        
        //PacketSize Low
        data[4] = (byte)0x0B;
        
        i = 5;
        
        switch(sessionType)
        {
        case SESSION_CONFIGURATION:
            password = CR_PS_CONFIG_SESSION_PASSWORD_0;
            break;
        case SESSION_CALIBRATION:
            password = CALIB_SESSION_PASSWORD;
            break;
        case SESSION_DOWNLOAD:
            password = CR_PS_DOWNLOAD_SESSION_PASSWORD_0;
            break;
        case SESSION_SOFTWARE:
            password = CR_PS_SOFTWARE_SESSION_PASSWORD_0;
            break;
        case SESSION_START_STOP:
            password = CR_PS_START_STOP_SESSION_PASSWORD_0;
            break;
        default:
            break;
        }
        
        data[i] = MENAGE_SESSION;
        i++;
        
        sessionOpened = sessionType;
        
        data[i] = OPEN_SESSION;
        i++;
        
        data[i] = sessionType;
        i++;
        
        for(;i < 16;i++){
            data[i] = password[pass];
            pass++;
        }
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        for(int a=0;a<data.length;a++){
            Log.v("Write",String.valueOf(data[a]));
        }
        
        Log.v("OPEN SESSION","Ok");
        return writeCustomCharacteristic(data);
    }
    
    //Maked Douglas
    public boolean WritePasswordSoft(byte[] Password, int size) {
        
        boolean result = false;
        //        if (OpenSession(SESSION_SOFTWARE))
        //        {
        byte TempArray[] = new byte[8];
        short passwordArray[] = new short[4];
        int cont = 0;
        
        for (int i = 0; i < 8; i++) //inicializa o vetor
        {
            TempArray[i] = (byte) 0;
        }
        
        for (int i = 0; i < size; i++) //Transfere a senha
        {
            TempArray[i] = Password[i];
        }
        
        for (int i = 0; i < 4; i++) //passa o vetor de bytes para o vetor de short
        {
            passwordArray[i] = (short) (((TempArray[cont++] & 0xff) << 8) | (TempArray[cont++] & 0xff));
        }
        
        //
        //            if (WriteMultipleRegisters((short) 3006, (short) 4, passwordArray)){
        //                result = true;
        //            }
        //
        //            CloseSession();
        //        }
        
        
        boolean ssThreadKill = false;
        cont = 0;
        int cont2 = 0;
        int stateFail = 0;
        boolean closeInterrupted = false;
        
        if(stateStartStop != 0) stateStartStop = 0;
        
        while(!ssThreadKill) {
            
            if(stateStartStop == 0){
                
                if(state == 2) {
                    stateStartStop = 3;
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                else {
                    cont++;
                    try {
                    Thread.sleep(700);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                if(cont > 50) {
                    stateFail = 0;
                    stateStartStop = 16;
                    cont = 0;
                }
            }
                
            else if(stateStartStop == 3){
                cont = 0;
                
                OpenSession(SESSION_SOFTWARE);
                
                stateStartStop = 5;
                try {
                Thread.sleep(200);
                } catch (InterruptedException e) {
                e.printStackTrace();
                }
            }
                
            else if(stateStartStop == 4){
                
                if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_SOFTWARE){
                    stateStartStop = 5;
                    
                    zeraPacket();
                }
                    
                else{
                    cont++;
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                
                if(cont > 20) {
                    stateFail = 0;
                    stateStartStop = 16;
                    cont = 0;
                }
                
                try {
                Thread.sleep(200);
                } catch (InterruptedException e) {
                e.printStackTrace();
                }
            }
                
            else if (stateStartStop == 5) {
                
                cont = 0;
                
                if (WriteMultipleRegisters((short) 3006, (short) 4, passwordArray)){
                    stateStartStop = 6;
                }
                else{
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                
                try {
                Thread.sleep(200);
                } catch (InterruptedException e) {
                e.printStackTrace();
                }
            }
                
            else if (stateStartStop == 6) {
                //espera bloco 1
                if(sessionOpened == SESSION_SOFTWARE){
                    stateStartStop = 13;
                    Log.v("WriteMultRegs1","Ok");
                }
                    
                else{
                    Log.v("stateStartStop state 6",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                    cont++;
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                
                if(cont > 20) {
                    Log.v("stateStartStop","6-16");
                    stateFail = 0;
                    stateStartStop = 16;
                    cont = 0;
                }
                
                try {
                Thread.sleep(100);
                } catch (InterruptedException e) {
                e.printStackTrace();
                }
                
            }
                
            else if(stateStartStop == 13){
                Log.v("Pré","CloseSession");
                
                if(CloseSession())
                stateStartStop = 15;
                
                else {
                    cont++;
                    Log.v("fail close session","false");
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                
                if(cont > 20) {
                    Log.v("stateStartStop","6-13");
                    stateFail = 0;
                    stateStartStop = 16;
                    cont = 0;
                }
            }
                
            else if(stateStartStop == 15){
                boolean n = mBluetoothManager.getAdapter().setName(getSsidNew());
                if(n) {
                    result = true;
                    Log.v("Trocou StartStop", "OK");
                }
                else{
                    Log.v("Trocou","NNNOK");
                }
                
                stateStartStop = 17;
            }
                
            else if(stateStartStop == 16){
                
                ssThreadKill = true;
            }
                
            else if(stateStartStop == 17){
                ssThreadKill = true;
            }
            
            if(state == 3){
                ssThreadKill = true;
            }
        }
        
        
        return result;
    }
   
    
    //Maked Douglas
    public void ParsePassword(){
        
        if(packet ==  null)
        return;
        
        if(device == null)
        device = new Device();
        
        for (int i = 0; i < 8; i++) {
            device.passwordArray[i] = (byte) (packet[i + 7] & 0xff);
        }
        
        device.SA_PASS1_1_2 = ((packet[7]  & 0xff) << 8) | (packet[8]  & 0xff);
        device.SA_PASS1_3_4 = ((packet[9]  & 0xff) << 8) | (packet[10] & 0xff);
        device.SA_PASS1_5_6 = ((packet[11] & 0xff) << 8) | (packet[12] & 0xff);
        device.SA_PASS1_7_8 = ((packet[13] & 0xff) << 8) | (packet[14] & 0xff);
        
        for (int i=0; i<256; i++)
        packet[i] = 0;
        
    }
    
    
    public boolean StartStopLog(byte sessionType) { //Make StartStop RafaelSilva
        int i = 0;
        int pass = 0;
        byte[] data = new byte[18];
        
        //StartFrame
        data[0] = SOF;
        
        //PacketType
        data[1] = (byte) (0xFF);
        
        //PacketId
        data[2] = (byte) (0x00 & 0xFF);
        this.id++;
        
        //PacketSize High
        data[3] = (byte) 0x00;
        
        //PacketSize Low
        data[4] = (byte) 0x0B;
        
        i = 5;
        
        password = CR_PS_START_STOP_SESSION_PASSWORD_0;
        data[i] = MENAGE_SESSION;
        i++;
        
        sessionOpened = SESSION_START_STOP;
        
        data[i] = sessionType;
        i++;
        
        data[i] = SESSION_START_STOP;
        i++;
        
        for(;i < 16;i++){
            data[i] = password[pass];
            pass++;
        }
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        for (int a = 0; a < data.length; a++) {
            Log.v("Write", String.valueOf(data[a]));
        }
        
        Log.v("START SESSION", "Ok");
        
        return writeCustomCharacteristic(data);
    }
    
    public boolean CloseSession(){
        
        if (sessionOpened == SESSION_NONE) return false;
        
        int i = 0;
        byte [] data = new byte[18];
        
        //StartFrame
        data[0] = SOF;
        
        //PacketType
        data[1] = (byte) (0xFF);
        
        //PacketId
        data[2] = (byte) (0x00);
        //this.id++;
        
        //PacketSize High
        data[3] = (byte)0x00;
        
        //PacketSize Low
        data[4] = (byte)0x0B;
        
        i = 5;
        
        data[i] = MENAGE_SESSION;
        i++;
        
        data[i] = CLOSE_SESSION;
        i++;
        
        data[i] = sessionOpened;
        i++;
        
        sessionOpened = SESSION_NONE;
        
        data[i] = password[0];
        i++;
        data[i] = password[1];
        i++;
        data[i] = password[2];
        i++;
        data[i] = password[3];
        i++;
        data[i] = password[4];
        i++;
        data[i] = password[5];
        i++;
        data[i] = password[6];
        i++;
        data[i] = password[7];
        i++;
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        return writeCustomCharacteristic(data);
    }
    
    
    
    public int GetCRC1(byte[] u8BufferPtr){
        //byte[] dataToWrite9 = InverterArray(u8BufferPtr, (int) u32NumBytes);
        
        crc = 0xFFFF;//0x0000;
        
        for (byte b : u8BufferPtr) {
            crc = (crc >>> 8) ^ table[(crc ^ b) & 0xff];
        }
        
        crcLow = (byte) (crc & 0xFF);
        crcHigh = (byte) ((crc >>8) & 0xFF);
        
        return crc;
    }
    
    // Implements callback methods for GATT events that the app cares about.  For example,
    // connection change and services discovered.
    //************************************************************************************************************************************************************************************
    //Descobrir se e usado para alguma coisa
  //  private final BluetoothGattCallback mGattCallback = new BluetoothGattCallback() {
    
    
    public void isPassword(byte[] data){
        int cont = 0;
        if(data.length == 5)
        for(int i = 0; i < 5; i++){
            if(data[i] == aOK[i])
            cont++;
        }
        if(cont == 5) {
            passwordReceived = true;
        }
    }
    
    public void parseData(byte[] data){
        
        int sizeData = data.length;
        
        if((data[0] == 0x5A)&&(status != SS_SERVICO_EM_ANDAMENTO)){
            //sizePacket = (256*(data[3]&0xFF)) + data[4]&0xFF;
            indexPacket = 0;
            status = SS_SERVICO_EM_ANDAMENTO;
            packetFinished = false;
            
        }
        
        if(stateReadRegisters == 11) {
            for (int i = 0; i < data.length; i++) {
                Log.v("packet = ", String.valueOf(i) + " = " + String.valueOf(data[i]));
            }
        }
        
        for(int i=0;i<sizeData;i++) {
            packet[indexPacket + i] = data[i];
        }
        
        indexPacket += sizeData;
        
        if(!canVerify) {
            if (indexPacket >= 5) {
                sizePacket = (256 * (packet[3] & 0xFF)) + packet[4] & 0xFF;
                canVerify = true;
            }
        }
        
        Log.v("indexPacket",String.valueOf(indexPacket));
        Log.v("sizePacket", String.valueOf(sizePacket));
        
        if(canVerify) {
            if ((indexPacket-7) >= (sizePacket)) {
                canVerify = false;
                status = SS_RESPOSTA_SEM_ERRO;
                packetFinished = true;
                indexPacket = 0;
                sizePacket = 0;
            }
        }
        
    }
    
    public void zeraPacket(){
        Log.v("ZeraPacket","ZeraPacket()");
        
        for(int i = 0; i < packet.length; i++)
        packet[i] = 0;
    }
    
   
    
    
    public boolean ParseRHRDataStatus1(){
        Log.v("PARSERHRDATA","parseRHRData()");
        boolean result = true;
        
        if(packet ==  null)
        return false;
        
        if(device == null)
        device = new Device();
        
        device.address = mBluetoothDeviceAddress;
        
        // Douglas
        device.BLE_HR_SS_SERIAL_NUMBER_HIGH = ((packet[7] & 0xff) << 8) | (packet[8] & 0xff);
        device.BLE_HR_SS_SERIAL_NUMBER_LOW = ((packet[9] & 0xff) << 8) | (packet[10] & 0xff);
        device.serialNumber = (device.BLE_HR_SS_SERIAL_NUMBER_HIGH << 16) | (device.BLE_HR_SS_SERIAL_NUMBER_LOW);
        
        //todo verificar como bloquear quando mostra numeros de séries inválidos.
        if(device.serialNumberAux != 0)
        {
            if(device.serialNumber != device.serialNumberAux){
                return false;
            }
        }
        
        if(device.firstRead == true) {
            device.serialNumberAux = device.serialNumber;
            device.firstRead = false;
        }
        
        device.serialNumberAux = device.serialNumber;
        
        device.HR_SS_PRODUCT_CODE = ((packet[11] & 0xff) << 8) | (packet[12] & 0xff);
        device.BLE_HR_SS_FIRMWARE_VERSION = (((packet[13] & 0xff) << 8) | (packet[14] & 0xff));
        //device.CR_PS_RESERVED_1 = ((packet[15] & 0xff) << 8) | (packet[16] & 0xff);
        
        device.HR_SS_MAC_ADDR_15_4_0_1_WiFi = ((packet[17] & 0xff) << 8) | (packet[18] & 0xff);
        device.HR_SS_MAC_ADDR_15_4_2_3_WiFi = ((packet[19] & 0xff) << 8) | (packet[20] & 0xff);
        device.HR_SS_MAC_ADDR_15_4_4_5_WiFi = ((packet[21] & 0xff) << 8) | (packet[22] & 0xff);
        device.HR_SS_MAC_ADDR_15_4_6_7 = ((packet[23] & 0xff) << 8) | (packet[24] & 0xff);
        //device.CR_PS_RESERVED_2 = ((packet[25] & 0xff) << 8) | (packet[26] & 0xff);
        
        device.BLE_HR_SS_MAC_ADDR_BLE_0_1 = ((packet[27] & 0xff) << 8) | (packet[28] & 0xff);
        device.BLE_HR_SS_MAC_ADDR_BLE_2_3 = ((packet[29] & 0xff) << 8) | (packet[30] & 0xff);
        device.BLE_HR_SS_MAC_ADDR_BLE_4_5 = ((packet[31] & 0xff) << 8) | (packet[32] & 0xff);
        
        //device.BLE_HR_SS_RESERVED_3 = ((packet[33] & 0xff) << 8) | (packet[34] & 0xff);
        //device.BLE_HR_SS_RESERVED_4 = ((packet[35] & 0xff) << 8) | (packet[36] & 0xff);
        device.BLE_HR_SS_POWER_SUPPLY = ((packet[37] & 0xff) << 8) | (packet[38] & 0xff);
        //device.BLE_HR_SS_RESERVED_5 = ((packet[39] & 0xff) << 8) | (packet[40] & 0xff);
        
        device.BLE_HR_SS_BLE_STATUS = ((packet[41] & 0xff) << 8) | (packet[42] & 0xff);
        device.BLE_HR_SS_BLE_LQI_RX = ((packet[43] & 0xff) << 8) | (packet[44] & 0xff);
        //device.BLE_HR_SS_BLE_RESERVED_1 = ((packet[45] & 0xff) << 8) | (packet[46] & 0xff);
        //device.BLE_HR_SS_BLE_RESERVED_2 = ((packet[47] & 0xff) << 8) | (packet[48] & 0xff);
        device.BLE_HR_SS_USB_STATUS = ((packet[49] & 0xff) << 8) | (packet[50] & 0xff);
        
        //device.BLE_HR_SS_USB_RESERVED_1 = ((packet[51] & 0xff) << 8) | (packet[52] & 0xff);
        //device.BLE_HR_SS_USB_RESERVED_2 = ((packet[53] & 0xff) << 8) | (packet[54] & 0xff);
        device.BLE_HR_SS_15_4_STATUS_RESERVED = ((packet[55] & 0xff) << 8) | (packet[56] & 0xff);
        device.BLE_HR_SS_15_4_SHORT_MAC_RESERVED = ((packet[57] & 0xff) << 8) | (packet[58] & 0xff);
        device.BLE_HR_SS_15_4_CHANNEL_RESERVED = ((packet[59] & 0xff) << 8) | (packet[60] & 0xff);
        
        device.BLE_HR_SS_15_4_LQI_RX_RESERVED = ((packet[61] & 0xff) << 8) | (packet[62] & 0xff);
        //device.BLE_HR_SS_15_4_RESERVED_1 = ((packet[63] & 0xff) << 8) | (packet[64] & 0xff);
        //device.BLE_HR_SS_15_4_RESERVED_2 = ((packet[65] & 0xff) << 8) | (packet[66] & 0xff);
        //device.BLE_HR_SS_RESERVED_6 = ((packet[67] & 0xff) << 8) | (packet[68] & 0xff);
        //device.BLE_HR_SS_RESERVED_7 = ((packet[69] & 0xff) << 8) | (packet[70] & 0xff);
        
        device.BLE_HR_SS_NUMBER_OF_ACTIVE_CHANNELS = ((packet[71] & 0xff) << 8) | (packet[72] & 0xff);
        //device.BLE_HR_SS_RESERVED_8 = ((packet[73] & 0xff) << 8) | (packet[74] & 0xff);
        device.HR_SS_RECORDS_STARTED_INTERFACE = ((packet[75] & 0xff) << 8) | (packet[76] & 0xff);
        device.HR_SS_RECORDS_STOPPED_INTERFACE = ((packet[77] & 0xff) << 8) | (packet[78] & 0xff);
        
        device.BLE_HR_SS_STATUS_OF_RECORDS =((packet[79] & 0xff) << 8) | (packet[80] & 0xff);
        device.statusOfRecords = device.BLE_HR_SS_STATUS_OF_RECORDS;
        
        device.BLE_HR_SS_NUMBER_OF_RECORDS_H = ((packet[81] & 0xff) << 8) | (packet[82] & 0xff);
        device.BLE_HR_SS_NUMBER_OF_RECORDS_L = ((packet[83] & 0xff) << 8) | (packet[84] & 0xff);
        device.logsTotalNumber = ((device.BLE_HR_SS_NUMBER_OF_RECORDS_H) << 16) | (device.BLE_HR_SS_NUMBER_OF_RECORDS_L);
        
        device.BLE_HR_SS_NUMBER_OF_FREE_RECORDS_H = ((packet[85] & 0xff) << 8) | (packet[86] & 0xff);
        device.BLE_HR_SS_NUMBER_OF_FREE_RECORDS_L = ((packet[87] & 0xff) << 8) | (packet[88] & 0xff);
        device.numberOfFreeLogs = ((device.BLE_HR_SS_NUMBER_OF_FREE_RECORDS_H) << 16) | (device.BLE_HR_SS_NUMBER_OF_FREE_RECORDS_L);
        
        //device.BLE_HR_SS_RESERVED_11 = ((packet[89] & 0xff) << 8) | (packet[90] & 0xff);
        
        //device.BLE_HR_SS_RESERVED_12 = ((packet[91] & 0xff) << 8) | (packet[92] & 0xff);
        
        device.BLE_HR_SS_FIRST_YEAR = ((packet[93] & 0xff) << 8) | (packet[94] & 0xff);
        device.BLE_HR_SS_FIRST_MONTH = ((packet[95] & 0xff) << 8) | (packet[96] & 0xff);
        device.BLE_HR_SS_FIRST_DAY = ((packet[97] & 0xff) << 8) | (packet[98] & 0xff);
        device.BLE_HR_SS_FIRST_HOUR = ((packet[99] & 0xff) << 8) | (packet[100] & 0xff);
        device.BLE_HR_SS_FIRST_MINUTE = ((packet[101] & 0xff) << 8) | (packet[102] & 0xff);
        device.BLE_HR_SS_FIRST_SECOND = ((packet[103] & 0xff) << 8) | (packet[104] & 0xff);
        String date = String.format("%02d",device.BLE_HR_SS_FIRST_DAY) + "/" + String.format("%02d",device.BLE_HR_SS_FIRST_MONTH) + "/" + String.format("%02d",device.BLE_HR_SS_FIRST_YEAR) + " " + String.format("%02d",device.BLE_HR_SS_FIRST_HOUR) + ":" + String.format("%02d",device.BLE_HR_SS_FIRST_MINUTE) + ":" + String.format("%02d",device.BLE_HR_SS_FIRST_SECOND);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        try {
        device.firstDate = sdf.parse(date);
        device.firstDate = device.getTimewithGMT(device.gmt,device.firstDate);
        } catch (ParseException e) {
        e.printStackTrace();
        }
        
        //device.BLE_HR_SS_RESERVED_13 = ((packet[105] & 0xff) << 8) | (packet[106] & 0xff);
        //device.BLE_HR_SS_RESERVED_14 = ((packet[107] & 0xff) << 8) | (packet[108] & 0xff);
        
        device.BLE_HR_SS_CURRENT_YEAR = ((packet[109] & 0xff) << 8) | (packet[110] & 0xff);
        device.BLE_HR_SS_CURRENT_MONTH = ((packet[111] & 0xff) << 8) | (packet[112] & 0xff);
        device.BLE_HR_SS_CURRENT_DAY = ((packet[113] & 0xff) << 8) | (packet[114] & 0xff);
        device.BLE_HR_SS_CURRENT_HOUR = ((packet[115] & 0xff) << 8) | (packet[116] & 0xff);
        device.BLE_HR_SS_CURRENT_MINUTE = ((packet[117] & 0xff) << 8) | (packet[118] & 0xff);
        device.BLE_HR_SS_CURRENT_SECOND = ((packet[119] & 0xff) << 8) | (packet[120] & 0xff);
        date = String.format("%02d",device.BLE_HR_SS_CURRENT_DAY) + "/" + String.format("%02d",device.BLE_HR_SS_CURRENT_MONTH) + "/" + String.format("%02d",device.BLE_HR_SS_CURRENT_YEAR) + " " + String.format("%02d",device.BLE_HR_SS_CURRENT_HOUR) + ":" + String.format("%02d",device.BLE_HR_SS_CURRENT_MINUTE) + ":" + String.format("%02d",device.BLE_HR_SS_CURRENT_SECOND);
        
        try {
        device.lastDate = sdf.parse(date);
        device.lastDate = device.getTimewithGMT(device.gmt,device.lastDate);
        } catch (ParseException e) {
        e.printStackTrace();
        }
        
        //device.BLE_HR_SS_RESERVED_15 = ((packet[121] & 0xff) << 8) | (packet[122] & 0xff);
        device.BLE_HR_SS_HAS_RESET_OCURRED = ((packet[123] & 0xff) << 8) | (packet[124] & 0xff);
        //device.BLE_HR_SS_RESERVED_17 = ((packet[125] & 0xff) << 8) | (packet[126] & 0xff);
        device.BLE_HR_SS_AM_I_IN_BOOTLOADER_MODE = ((packet[127] & 0xff) << 8) | (packet[128] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_YEAR = ((packet[129] & 0xff) << 8) | (packet[130] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_MONTH = ((packet[131] & 0xff) << 8) | (packet[132] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_DAY = ((packet[133] & 0xff) << 8) | (packet[134] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_HOUR = ((packet[135] & 0xff) << 8) | (packet[136] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_MINUTE = ((packet[137] & 0xff) << 8) | (packet[138] & 0xff);
        device.BLE_HR_SS_CHD_LAST_EVENT_SECOND = ((packet[139] & 0xff) << 8) | (packet[140] & 0xff);
        
        device.BLE_HR_SS_ALARM_STATUS = ((packet[141] & 0xff) << 8) | (packet[142] & 0xff);
        //device.BLE_HR_SS_RESERVED_25 = ((packet[143] & 0xff) << 8) | (packet[144] & 0xff);
        //device.BLE_HR_SS_RESERVED_26 = ((packet[145] & 0xff) << 8) | (packet[146] & 0xff);
        device.BLE_HR_SS_DIGITAL_OUT_VALUE = ((packet[147] & 0xff) << 8) | (packet[148] & 0xff);
        //device.BLE_HR_SS_RESERVED_27 = ((packet[149] & 0xff) << 8) | (packet[150] & 0xff);
        
        //Canal Digital
        device.HR_SS_CHD_ALARM_STATUS = ((packet[151] & 0xff) << 8) | (packet[152] & 0xff);
        device.BLE_HR_SS_CHD_STATUS = ((packet[153] & 0xff) << 8) | (packet[154] & 0xff);
        device.BLE_HR_SS_CHD_VALUE = ((packet[155] & 0xff) << 8) | (packet[156] & 0xff);
        device.BLE_HR_SS_CHD_VALUE_USER_UNIT_float_High = ((packet[157] & 0xff) << 8) | (packet[158] & 0xff);
        device.BLE_HR_SS_CHD_VALUE_USER_UNIT_float_Low = ((packet[159] & 0xff) << 8) | (packet[160] & 0xff);
        
        device.chd_valueUserFloatStatus = Float.intBitsToFloat((device.BLE_HR_SS_CHD_VALUE_USER_UNIT_float_High << 16)|(device.BLE_HR_SS_CHD_VALUE_USER_UNIT_float_Low));
        
        device.BLE_HR_SS_CHD_VALUE_MIN = ((packet[161] & 0xff) << 8) | (packet[162] & 0xff);
        device.BLE_HR_SS_CHD_VALUE_MAX = ((packet[163] & 0xff) << 8) | (packet[164] & 0xff);
        device.BLE_HR_SS_CHD_ALARM_MIN_STATUS = ((packet[165] & 0xff) << 8) | (packet[166] & 0xff);
        device.BLE_HR_SS_CHD_ALARM_MAX_STATUS = ((packet[167] & 0xff) << 8) | (packet[168] & 0xff);
        //Canal Analógico 1
        device.BLE_HR_SS_CH1_STATUS = ((packet[169] & 0xff) << 8) | (packet[170] & 0xff);
        device.BLE_HR_SS_CH1_VALUE = ((packet[171]) << 8) | (packet[172] & 0xff);
        device.BLE_HR_SS_CH1_VALUE_MIN = ((packet[173]) << 8) | (packet[174] & 0xff);
        device.BLE_HR_SS_CH1_VALUE_MAX = ((packet[175]) << 8) | (packet[176] & 0xff);
        device.BLE_HR_SS_CH1_ALARM_MIN_STATUS = ((packet[177]) << 8) | (packet[178] & 0xff);
        device.BLE_HR_SS_CH1_ALARM_MAX_STATUS = ((packet[179]) << 8) | (packet[180] & 0xff);
        
        device.HR_SS_CH1_ALARM_STATUS = ((packet[181] ) << 8) | (packet[182] & 0xff);
        //device.BLE_HR_SS_RESERVED_32 = ((packet[183] ) << 8) | (packet[184] & 0xff);
        //Canal Analógico 2
        device.BLE_HR_SS_CH2_STATUS = ((packet[185] ) << 8) | (packet[186] & 0xff);
        device.BLE_HR_SS_CH2_VALUE = ((packet[187] ) << 8) | (packet[188] & 0xff);
        device.BLE_HR_SS_CH2_VALUE_MIN = ((packet[189] ) << 8) | (packet[190] & 0xff);
        
        device.BLE_HR_SS_CH2_VALUE_MAX = ((packet[191] ) << 8) | (packet[192] & 0xff);
        device.BLE_HR_SS_CH2_ALARM_MIN_STATUS = ((packet[193] ) << 8) | (packet[194] & 0xff);
        device.BLE_HR_SS_CH2_ALARM_MAX_STATUS = ((packet[195] ) << 8) | (packet[196] & 0xff);
        device.HR_SS_CH2_ALARM_STATUS = ((packet[197] ) << 8) | (packet[198] & 0xff);
        //device.BLE_HR_SS_RESERVED_34 = ((packet[199] ) << 8) | (packet[200] & 0xff);
        
        //Canal Analógico 3
        device.BLE_HR_SS_CH3_STATUS = ((packet[201] ) << 8) | (packet[202] & 0xff);
        device.BLE_HR_SS_CH3_VALUE = ((packet[203] ) << 8) | (packet[204] & 0xff);
        device.BLE_HR_SS_CH3_VALUE_MIN = ((packet[205] ) << 8) | (packet[206] & 0xff);
        
        for (int i=0; i<256; i++)
        packet[i] = 0;
        
        
        return result;
    }
    
    public void ParseRHRDataStatus2(){
        Log.v("PARSERHRDATA","parseRHRData()");
        if(packet ==  null)
        return;
        
        if(device == null)
        device = new Device();
        
        device.BLE_HR_SS_CH3_VALUE_MAX = ((packet[7] & 0xff) << 8) | (packet[8] & 0xff);
        device.BLE_HR_SS_CH3_ALARM_MIN_STATUS = (((packet[9] & 0xff) << 8) | (packet[10] & 0xff));
        device.BLE_HR_SS_CH3_ALARM_MAX_STATUS = ((packet[11] & 0xff) << 8) | (packet[12] & 0xff);
        device.HR_SS_CH3_ALARM_STATUS = (((packet[13] & 0xff) << 8) | (packet[14] & 0xff));
        //device.BLE_HR_SS_RESERVED_36 = ((packet[15] & 0xff) << 8) | (packet[16] & 0xff);
        
        //device.BLE_HR_SS_RESERVED_37 = ((packet[17] & 0xff) << 8) | (packet[18] & 0xff);
        device.BLE_HR_SS_BATTERY_VOLTAGE_VALUE = ((packet[19] & 0xff) << 8) | (packet[20] & 0xff);
        device.BLE_HR_SS_BATTERY_VOLTAGE_VALUE_MIN = ((packet[21] & 0xff) << 8) | (packet[22] & 0xff);
        device.BLE_HR_SS_BATTERY_VOLTAGE_VALUE_MAX = ((packet[23] & 0xff) << 8) | (packet[24] & 0xff);
        device.BLE_HR_SS_BATTERY_PERCENTAGE_OF_LIFE = ((packet[25] & 0xff) << 8) | (packet[26] & 0xff);
        //device.BLE_HR_SS_RESERVED_38 = ((packet[27] & 0xff) << 8) | (packet[28] & 0xff);
        //device.BLE_HR_SS_RESERVED_39 = ((packet[29] & 0xff) << 8) | (packet[30] & 0xff);
        
        //device.BLE_HR_SS_RESERVED_40 = ((packet[31] & 0xff) << 8) | (packet[32] & 0xff);
        device.BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE = ((packet[33] & 0xff) << 8) | (packet[34] & 0xff);
        device.BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE_MIN = ((packet[35] & 0xff) << 8) | (packet[36] & 0xff);
        device.BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE_MAX = ((packet[37] & 0xff) << 8) | (packet[38] & 0xff);
        //device.HR_SS_RESERVED_52 = ((packet[39] & 0xff) << 8) | (packet[40] & 0xff);
        
        for (int i=0; i<256; i++)
        packet[i] = 0;
    }
    
    public void ParseRHRDataConfig1(){
        Log.v("PARSERHRDATA","parseRHRData()");
        if(packet ==  null)
        return;
        
        if(device == null)
        device = new Device();
        
        try {
            
            device.HR_CS_SETTING_RESTORE_DEFAULT = ((packet[7] & 0xff) << 8) | (packet[8] & 0xff);
            
            device.interval = ((packet[9] & 0xff) << 8) | (packet[10] & 0xff);
            
            
            device.HR_CS_ENABLE_REGISTER_LOG = ((packet[11] & 0xff) << 8) | (packet[12] & 0xff);
            if (device.HR_CS_ENABLE_REGISTER_LOG == 1)
            device.regs_en = true;
            else
            device.regs_en = false;
            
            device.HR_CS_RESERVED_1 = ((packet[13] & 0xff) << 8) | (packet[14] & 0xff);//HR_CS_SETTING_DIGITAL_OUT_S
            device.HR_CS_SETTING_ACQUISITION_INTERVAL_SCAN_S = ((packet[15] & 0xff) << 8) | (packet[16] & 0xff);
            device.startMode = ((packet[17] & 0xff) << 8) | (packet[18] & 0xff);
            device.stopMode = ((packet[19] & 0xff) << 8) | (packet[20] & 0xff);
            device.HR_CS_SETTING_ERASE_LOG_MEMORY = ((packet[21] & 0xff) << 8) | (packet[22] & 0xff);
            device.HR_CS_SETTING_CONFIGURATION_ONGOING = ((packet[23] & 0xff) << 8) | (packet[24] & 0xff);
            device.gmt = ((packet[93]) << 8) | (packet[94] & 0xff);
            
            
            device.HR_CS_SETTING_YEAR_START_RECORD = ((packet[25] & 0xff) << 8) | (packet[26] & 0xff);
            device.HR_CS_SETTING_MONTH_START_RECORD = ((packet[27] & 0xff) << 8) | (packet[28] & 0xff);
            device.HR_CS_SETTING_DAY_START_RECORD = ((packet[29] & 0xff) << 8) | (packet[30] & 0xff);
            device.HR_CS_SETTING_HOUR_START_RECORD = ((packet[31] & 0xff) << 8) | (packet[32] & 0xff);
            device.HR_CS_SETTING_MINUTE_START_RECORD = ((packet[33] & 0xff) << 8) | (packet[34] & 0xff);
            device.HR_CS_SETTING_SECOND_START_RECORD = ((packet[35] & 0xff) << 8) | (packet[36] & 0xff);
            String date = String.format("%02d", device.HR_CS_SETTING_DAY_START_RECORD) + "/" + String.format("%02d", device.HR_CS_SETTING_MONTH_START_RECORD) + "/" + String.format("%02d", device.HR_CS_SETTING_YEAR_START_RECORD) + " " + String.format("%02d", device.HR_CS_SETTING_HOUR_START_RECORD) + ":" + String.format("%02d", device.HR_CS_SETTING_MINUTE_START_RECORD) + ":" + String.format("%02d", device.HR_CS_SETTING_SECOND_START_RECORD);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            try {
                device.startDate = sdf.parse(date);
                device.startDate = device.getTimewithGMT(device.gmt,device.startDate);
                
                //Atualiza estas variaveis aqui a primeira vez pq antes não tinha lido o gmt ainda.
                device.firstDate = device.getTimewithGMT(device.gmt,device.firstDate);
                device.lastDate = device.getTimewithGMT(device.gmt,device.lastDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            
            device.HR_CS_RESERVED_5 = ((packet[37] & 0xff) << 8) | (packet[38] & 0xff);
            
            device.HR_CS_SETTING_YEAR_STOP_RECORD = ((packet[39] & 0xff) << 8) | (packet[40] & 0xff);
            device.HR_CS_SETTING_MONTH_STOP_RECORD = ((packet[41] & 0xff) << 8) | (packet[42] & 0xff);
            device.HR_CS_SETTING_DAY_STOP_RECORD = ((packet[43] & 0xff) << 8) | (packet[44] & 0xff);
            device.HR_CS_SETTING_HOUR_STOP_RECORD = ((packet[45] & 0xff) << 8) | (packet[46] & 0xff);
            device.HR_CS_SETTING_MINUTE_STOP_RECORD = ((packet[47] & 0xff) << 8) | (packet[48] & 0xff);
            device.HR_CS_SETTING_SECOND_STOP_RECORD = ((packet[49] & 0xff) << 8) | (packet[50] & 0xff);
            date = String.format("%02d", device.HR_CS_SETTING_DAY_STOP_RECORD) + "/" + String.format("%02d", device.HR_CS_SETTING_MONTH_STOP_RECORD) + "/" + String.format("%02d", device.HR_CS_SETTING_YEAR_STOP_RECORD) + " " + String.format("%02d", device.HR_CS_SETTING_HOUR_STOP_RECORD) + ":" + String.format("%02d", device.HR_CS_SETTING_MINUTE_STOP_RECORD) + ":" + String.format("%02d", device.HR_CS_SETTING_SECOND_STOP_RECORD);
            
            try {
            device.stopDate = sdf.parse(date);
            device.stopDate = device.getTimewithGMT(device.gmt,device.stopDate);
            } catch (ParseException e) {
            e.printStackTrace();
            }
            
            device.HR_CS_RESERVED_6 = ((packet[51] & 0xff) << 8) | (packet[52] & 0xff);
            device.display_active = ((packet[53] & 0xff) << 8) | (packet[54] & 0xff);
            device.HR_CS_DISPLAY_CONTRAST = ((packet[55] & 0xff) << 8) | (packet[56] & 0xff);
            device.HR_CS_RESERVED_9 = ((packet[57] & 0xff) << 8) | (packet[58] & 0xff);
            device.HR_CS_BOOTLOADER_CONTROL = ((packet[59] & 0xff) << 8) | (packet[60] & 0xff);
            device.HR_CS_ALARM_BUZZER_DURATION_S = ((packet[61] & 0xff) << 8) | (packet[62] & 0xff);
            device.HR_CS_SETTING_DIGITAL_OUT_MODE = ((packet[63] & 0xff) << 8) | (packet[64] & 0xff);
            device.HR_CS_SETTING_DIGITAL_OUT_DURATION_S = ((packet[65] & 0xff) << 8) | (packet[66] & 0xff);
            device.HR_CS_MODBUS_ADDRESS = ((packet[67] & 0xff) << 8) | (packet[68] & 0xff);
            device.HR_CS_RESERVED_14 = ((packet[69] & 0xff) << 8) | (packet[70] & 0xff);
            
            for (int i = 0; i < 20; i++) {
                device.title[i] = (byte) (packet[i + 71] & 0xff);
            }
            
            device.HR_CS_SETTING_TITLE_1 = (byte) (((packet[71] & 0xff) << 8) | (packet[72] & 0xff));
            device.HR_CS_SETTING_TITLE_2 = (byte) (((packet[73] & 0xff) << 8) | (packet[74] & 0xff));
            device.HR_CS_SETTING_TITLE_3 = (byte) (((packet[75] & 0xff) << 8) | (packet[76] & 0xff));
            device.HR_CS_SETTING_TITLE_4 = (byte) (((packet[77] & 0xff) << 8) | (packet[78] & 0xff));
            device.HR_CS_SETTING_TITLE_5 = (byte) (((packet[79] & 0xff) << 8) | (packet[80] & 0xff));
            device.HR_CS_SETTING_TITLE_6 = (byte) (((packet[81] & 0xff) << 8) | (packet[82] & 0xff));
            device.HR_CS_SETTING_TITLE_7 = (byte) (((packet[83] & 0xff) << 8) | (packet[84] & 0xff));
            device.HR_CS_SETTING_TITLE_8 = (byte) (((packet[85] & 0xff) << 8) | (packet[86] & 0xff));
            device.HR_CS_SETTING_TITLE_9 = (byte) (((packet[87] & 0xff) << 8) | (packet[88] & 0xff));
            device.HR_CS_SETTING_TITLE_10 = (byte) (((packet[89] & 0xff) << 8) | (packet[90] & 0xff));
            
            device.HR_CS_SETTING_PM = ((packet[91] & 0xff) << 8) | (packet[92] & 0xff);
            
            //device.gmt = ((packet[93]) << 8) | (packet[94] & 0xff); JOGUEI LA PRA CIMA
            
            device.HR_CS_SETTING_YEAR = ((packet[95] & 0xff) << 8) | (packet[96] & 0xff);
            device.HR_CS_SETTING_MONTH = ((packet[97] & 0xff) << 8) | (packet[98] & 0xff);
            device.HR_CS_SETTING_DAY = ((packet[99] & 0xff) << 8) | (packet[100] & 0xff);
            device.HR_CS_SETTING_HOUR = ((packet[101] & 0xff) << 8) | (packet[102] & 0xff);
            device.HR_CS_SETTING_MINUTE = ((packet[103] & 0xff) << 8) | (packet[104] & 0xff);
            device.HR_CS_SETTING_SECOND = ((packet[105] & 0xff) << 8) | (packet[106] & 0xff);
            device.HR_CS_RESERVED_16 = ((packet[107] & 0xff) << 8) | (packet[108] & 0xff);
            
            device.HR_CS_BLE_ENABLED = ((packet[109] & 0xff) << 8) | (packet[110] & 0xff);
            if (device.HR_CS_BLE_ENABLED == 1)
            device.ble_en = true;
            else
            device.ble_en = false;
            
            device.wakeup_mode = ((packet[111] & 0xff) << 8) | (packet[112] & 0xff);
            device.periodicity = ((packet[113] & 0xff) << 8) | (packet[114] & 0xff);
            
            for (int i = 0; i < 8; i++) {
                device.ssid[i] = (byte) (packet[i + 115] & 0xff);
            }
            
            device.BLE_HR_CS_BLE_DEVICE_NAME_1 = ((packet[115] & 0xff) << 8) | (packet[116] & 0xff);
            device.BLE_HR_CS_BLE_DEVICE_NAME_2 = ((packet[117] & 0xff) << 8) | (packet[118] & 0xff);
            device.BLE_HR_CS_BLE_DEVICE_NAME_3 = ((packet[119] & 0xff) << 8) | (packet[120] & 0xff);
            device.BLE_HR_CS_BLE_DEVICE_NAME_4 = ((packet[121] & 0xff) << 8) | (packet[122] & 0xff);
            
            
            int startStopByButton = (device.startMode & 0x04) & (device.stopMode & 0x08);
            if (startStopByButton == 1)
            device.startStopByButton = true;
            else
            device.startStopByButton = false;
            
            int memCircular = (device.stopMode & 0x02);
            
            if (memCircular == 2)
            device.memCircular = true;
            else
            device.memCircular = false;
            
            device.HR_CS_RESERVED_17 = ((packet[123] & 0xff) << 8) | (packet[124] & 0xff);
            device.HR_CS_BLE_RESERVED_1 = ((packet[125] & 0xff) << 8) | (packet[126] & 0xff);
            device.HR_CS_BLE_RESERVED_2 = ((packet[127] & 0xff) << 8) | (packet[128] & 0xff);
            device.HR_CS_BLE_RESERVED_3 = ((packet[129] & 0xff) << 8) | (packet[130] & 0xff);
            device.HR_CS_BLE_FAST_ADVERTISE_DURATION_S = ((packet[131] & 0xff) << 8) | (packet[132] & 0xff);
            device.HR_CS_RESERVED_18 = ((packet[133] & 0xff) << 8) | (packet[134] & 0xff);
            device.HR_CS_RESERVED_19 = ((packet[135] & 0xff) << 8) | (packet[136] & 0xff);
            device.HR_CS_VBAT_VEXT_MIN_MAX_CLEAR_STATUS = ((packet[137] & 0xff) << 8) | (packet[138] & 0xff);
            device.HR_CS_RESERVED_21 = ((packet[139] & 0xff) << 8) | (packet[140] & 0xff);
            
            device.HR_CS_15_4_ENABLED_RESERVED = ((packet[141] & 0xff) << 8) | (packet[142] & 0xff);
            device.HR_CS_15_4_ADVERTISE_MODE_RESERVED = ((packet[143] & 0xff) << 8) | (packet[144] & 0xff);
            device.HR_CS_15_4_ADVERTISE_TIME_RESERVED = ((packet[145] & 0xff) << 8) | (packet[146] & 0xff);
            device.HR_CS_RESERVED_15_4_1 = ((packet[147] & 0xff) << 8) | (packet[148] & 0xff);
            device.HR_CS_RESERVED_15_4_2 = ((packet[149] & 0xff) << 8) | (packet[150] & 0xff);
            device.HR_CS_15_4_PAN_ID_RESERVED = ((packet[151] & 0xff) << 8) | (packet[152] & 0xff);
            device.HR_CS_15_4_POWER_LEVEL_RESERVED = ((packet[153] & 0xff) << 8) | (packet[154] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_ENABLED_RESERVED = ((packet[155] & 0xff) << 8) | (packet[156] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_0_RESERVED = ((packet[157] & 0xff) << 8) | (packet[158] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_1_RESERVED = ((packet[159] & 0xff) << 8) | (packet[160] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_2_RESERVED = ((packet[161] & 0xff) << 8) | (packet[162] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_3_RESERVED = ((packet[163] & 0xff) << 8) | (packet[164] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_4_RESERVED = ((packet[165] & 0xff) << 8) | (packet[166] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_5_RESERVED = ((packet[167] & 0xff) << 8) | (packet[168] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_6_RESERVED = ((packet[169] & 0xff) << 8) | (packet[170] & 0xff);
            device.HR_CS_15_4_ENCRYPTION_KEY_7_RESERVED = ((packet[171] & 0xff) << 8) | (packet[172] & 0xff);
            device.HR_CS_CHD_DECIMAL_POINT = ((packet[173] & 0xff) << 8) | (packet[174] & 0xff);
            device.chd_n_decimal = device.HR_CS_CHD_DECIMAL_POINT;
            device.HR_CS_CHD_ALARM_MIN_HYSTERESIS = ((packet[175] & 0xff) << 8) | (packet[176] & 0xff);
            device.HR_CS_CHD_ALARM_MAX_HYSTERESIS = ((packet[177] & 0xff) << 8) | (packet[178] & 0xff);
            
            
            device.HR_CS_CHD_ALARM_MIN_MAX_CLEAR_STATUS = ((packet[179] & 0xff) << 8) | (packet[180] & 0xff);
            
            device.BLE_HR_CS_CHD_ENABLE = ((packet[181] & 0xff) << 8) | (packet[182] & 0xff);
            if (device.BLE_HR_CS_CHD_ENABLE == 1)
            device.chdEnabled = true;
            else
            device.chdEnabled = false;
            
            device.chd_inpuType = ((packet[183] & 0xff) << 8) | (packet[184] & 0xff);
            
            device.chd_sensorType = ((packet[185] & 0xff) << 8) | (packet[186] & 0xff);
            
            device.chd_countEdge = ((packet[187] & 0xff) << 8) | (packet[188] & 0xff);
            
            device.HR_CS_CHD_DEBOUNCE_TIME_ms = ((packet[189] & 0xff) << 8) | (packet[190] & 0xff);
            
            device.HR_CS_CHD_SENSOR_FACTOR_float_High = ((packet[191] & 0xff) << 8) | (packet[192] & 0xff);
            device.HR_CS_CHD_SENSOR_FACTOR_float_Low = ((packet[193] & 0xff) << 8) | (packet[194] & 0xff);
            
            device.chd_multCoeff = Float.intBitsToFloat ((device.HR_CS_CHD_SENSOR_FACTOR_float_High << 16)|(device.HR_CS_CHD_SENSOR_FACTOR_float_Low));
            
            device.HR_CS_CHD_SENSOR_UNIT = ((packet[195] & 0xff) << 8) | (packet[196] & 0xff);
            
            device.HR_CS_CHD_USER_SCALE_FACTOR_float_High = ((packet[197] & 0xff) << 8) | (packet[198] & 0xff);
            device.HR_CS_CHD_USER_SCALE_FACTOR_float_Low = ((packet[199] & 0xff) << 8) | (packet[200] & 0xff);
            
            device.chd_scaleCoeff= Float.intBitsToFloat((device.HR_CS_CHD_USER_SCALE_FACTOR_float_High << 16)|(device.HR_CS_CHD_USER_SCALE_FACTOR_float_Low));
            
            device.chd_unit = ((packet[201] & 0xff) << 8) | (packet[202] & 0xff);
            
            device.BLE_HR_CS_CHD_ENABLE_ALARM_MIN = ((packet[203] & 0xff) << 8) | (packet[204] & 0xff);
            if (device.BLE_HR_CS_CHD_ENABLE_ALARM_MIN == 1)
            device.chdAlarmLowEnabled = true;
            else
            device.chdAlarmLowEnabled = false;
            
            device.BLE_HR_CS_CHD_ENABLE_ALARM_MAX = ((packet[205] & 0xff) << 8) | (packet[206] & 0xff);
            if (device.BLE_HR_CS_CHD_ENABLE_ALARM_MAX == 1)
            device.chdAlarmHighEnabled = true;
            else
            device.chdAlarmHighEnabled = false;
        }catch (Exception e){
            Log.v(TAG2,"Exception Parse RHRConfig1");
        }
        
        for (int i=0; i<256; i++)
        packet[i] = 0;
    }
    
    public void ParseRHRDataConfig2(){
        Log.v("PARSERHRDATA","parseRHRData()");
        if(packet ==  null)
        return;
        
        if(device == null)
        device = new Device();
        try {
            int div;
            
            device.BLE_HR_CS_CHD_ALARM_MIN = ((packet[7]) << 8) | (packet[8] & 0xff);
            
            
            device.BLE_HR_CS_CHD_ALARM_MAX = ((packet[9]) << 8) | (packet[10] & 0xff);
            
            
            //Maked Douglas
            device.chdAlarmLowHyst = device.CountsToUserUnits(device.HR_CS_CHD_ALARM_MIN_HYSTERESIS,device.chd_multCoeff, device.chd_scaleCoeff,device.HR_CS_CHD_SENSOR_UNIT, device.interval);
            device.chdAlarmHighHyst = device.CountsToUserUnits(device.HR_CS_CHD_ALARM_MAX_HYSTERESIS,device.chd_multCoeff, device.chd_scaleCoeff,device.HR_CS_CHD_SENSOR_UNIT, device.interval);
            device.chdAlarmLow = device.CountsToUserUnits(device.BLE_HR_CS_CHD_ALARM_MIN,device.chd_multCoeff, device.chd_scaleCoeff,device.HR_CS_CHD_SENSOR_UNIT, device.interval);
            device.chdAlarmHigh = device.CountsToUserUnits(device.BLE_HR_CS_CHD_ALARM_MAX,device.chd_multCoeff, device.chd_scaleCoeff,device.HR_CS_CHD_SENSOR_UNIT, device.interval);
            
            
            for (int i = 0; i < 16; i++) {
                device.chd_tag[i] = (byte) (packet[i + 11] & 0xff);
            }
            
            device.BLE_HR_CS_CHD_TAG_1 = ((packet[11] & 0xff) << 8) | (packet[12] & 0xff);
            device.BLE_HR_CS_CHD_TAG_2 = ((packet[13] & 0xff) << 8) | (packet[14] & 0xff);
            device.BLE_HR_CS_CHD_TAG_3 = ((packet[15] & 0xff) << 8) | (packet[16] & 0xff);
            device.BLE_HR_CS_CHD_TAG_4 = ((packet[17] & 0xff) << 8) | (packet[18] & 0xff);
            device.BLE_HR_CS_CHD_TAG_5 = ((packet[19] & 0xff) << 8) | (packet[20] & 0xff);
            device.BLE_HR_CS_CHD_TAG_6 = ((packet[21] & 0xff) << 8) | (packet[22] & 0xff);
            device.BLE_HR_CS_CHD_TAG_7 = ((packet[23] & 0xff) << 8) | (packet[24] & 0xff);
            device.BLE_HR_CS_CHD_TAG_8 = ((packet[25] & 0xff) << 8) | (packet[26] & 0xff);
            
            for (int i = 0; i < 8; i++) {
                device.chd_unit_custom[i] = (byte) (packet[i + 27] & 0xff);
            }
            
            device.BLE_HR_CS_CHD_TAG_UNIT_1 = ((packet[27] & 0xff) << 8) | (packet[28] & 0xff);
            device.BLE_HR_CS_CHD_TAG_UNIT_2 = ((packet[29] & 0xff) << 8) | (packet[30] & 0xff);
            device.BLE_HR_CS_CHD_TAG_UNIT_3 = ((packet[31] & 0xff) << 8) | (packet[32] & 0xff);
            device.BLE_HR_CS_CHD_TAG_UNIT_4 = ((packet[33] & 0xff) << 8) | (packet[34] & 0xff);
            
            device.HR_CS_FREQUENCY_TO_FILTER = ((packet[35] & 0xff) << 8) | (packet[36] & 0xff);
            
            device.BLE_HR_CS_CH1_ENABLE = ((packet[37] & 0xff) << 8) | (packet[38] & 0xff);
            if (device.BLE_HR_CS_CH1_ENABLE == 1)
            device.ch1Enabled = true;
            else
            device.ch1Enabled = false;
            
            device.ch1_mode = ((packet[39] & 0xff) << 8) | (packet[40] & 0xff);
            
            device.ch1SensorType = ((packet[41] & 0xff) << 8) | (packet[42] & 0xff);
            
            device.ch1_unit = ((packet[43] & 0xff) << 8) | (packet[44] & 0xff);
            
            device.ch1_n_decimal = ((packet[57] & 0xff) << 8) | (packet[58] & 0xff);//Vem para ca por que utilizamos esta informação abaixo
            
            
            if (device.getSensorType(device.ch1SensorType) == 0)
            div = 10;
            else if (device.getSensorType(device.ch1SensorType) == 2)
            div = 100;
            else
            div = (int) pow10(device.ch1_n_decimal);
            
            device.ch1_LimitLow = ((((packet[45]) << 8) | (packet[46] & 0xff)) / div);
            device.ch1_LimitHigh = ((((packet[47]) << 8) | (packet[48] & 0xff)) / div);
            device.BLE_HR_CS_CH1_RANGE_MIN = (((packet[45]) << 8) | (packet[46] & 0xff));
            device.BLE_HR_CS_CH1_RANGE_MAX = (((packet[47]) << 8) | (packet[48] & 0xff));
            
            device.BLE_HR_CS_CH1_ENABLE_ALARM_MIN = ((packet[49] & 0xff) << 8) | (packet[50] & 0xff);
            if (device.BLE_HR_CS_CH1_ENABLE_ALARM_MIN == 1)
            device.ch1AlarmLowEnabled = true;
            else
            device.ch1AlarmLowEnabled = false;
            
            device.BLE_HR_CS_CH1_ENABLE_ALARM_MAX = ((packet[51] & 0xff) << 8) | (packet[52] & 0xff);
            if (device.BLE_HR_CS_CH1_ENABLE_ALARM_MAX == 1)
            device.ch1AlarmHighEnabled = true;
            else
            device.ch1AlarmHighEnabled = false;
            
            device.BLE_HR_CS_CH1_ALARM_MIN = (((packet[53]) << 8) | (packet[54] & 0xff));
            device.BLE_HR_CS_CH1_ALARM_MAX = (((packet[55]) << 8) | (packet[56] & 0xff));
            device.ch1AlarmLow = (device.BLE_HR_CS_CH1_ALARM_MIN / div);
            device.ch1AlarmHigh = (device.BLE_HR_CS_CH1_ALARM_MAX / div);
            
            //device.ch1_n_decimal = ((packet[57] & 0xff) << 8) | (packet[58] & 0xff);
            
            
            device.HR_CS_CH1_GAIN_USER_RESERVED = ((packet[59]) << 8) | (packet[60] & 0xff);
            
            device.BLE_HR_CS_CH1_OFFSET_USER = ((packet[61] << 8) | (packet[62] & 0xff));
            device.ch1UserOffset = (-1) * (((packet[61] << 8) | (packet[62] & 0xff)) / div);
            
            device.HR_CS_RESERVED_28 = ((packet[63]) << 8) | (packet[64] & 0xff);
            
            for (int i = 0; i < 16; i++) {
                device.ch1_tag[i] = (byte) (packet[i + 65] & 0xff);
            }
            device.BLE_HR_CS_CH1_TAG_1 = ((packet[65]) << 8) | (packet[66] & 0xff);
            device.BLE_HR_CS_CH1_TAG_2 = ((packet[67]) << 8) | (packet[68] & 0xff);
            device.BLE_HR_CS_CH1_TAG_3 = ((packet[69]) << 8) | (packet[70] & 0xff);
            device.BLE_HR_CS_CH1_TAG_4 = ((packet[71]) << 8) | (packet[72] & 0xff);
            device.BLE_HR_CS_CH1_TAG_5 = ((packet[65]) << 8) | (packet[66] & 0xff);
            device.BLE_HR_CS_CH1_TAG_6 = ((packet[67]) << 8) | (packet[68] & 0xff);
            device.BLE_HR_CS_CH1_TAG_7 = ((packet[69]) << 8) | (packet[70] & 0xff);
            device.BLE_HR_CS_CH1_TAG_8 = ((packet[71]) << 8) | (packet[72] & 0xff);
            
            for (int i = 0; i < 8; i++) {
                device.ch1_unit_custom[i] = (byte) (packet[i + 81] & 0xff);
            }
            
            for (int i = 8; i < 16; i++) {
                device.ch1_unit_custom[i] = 0;
            }
            
            device.ch1_unit_custom = parseUnitCustom(device.ch1_unit_custom);
            
            device.BLE_HR_CS_CH1_TAG_UNIT_1 = ((packet[81]) << 8) | (packet[82] & 0xff);
            device.BLE_HR_CS_CH1_TAG_UNIT_2 = ((packet[83]) << 8) | (packet[84] & 0xff);
            device.BLE_HR_CS_CH1_TAG_UNIT_3 = ((packet[85]) << 8) | (packet[86] & 0xff);
            device.BLE_HR_CS_CH1_TAG_UNIT_4 = ((packet[87]) << 8) | (packet[88] & 0xff);
            
            device.HR_CS_RESERVED_29 = ((packet[89]) << 8) | (packet[90] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_NUM_OF_POINTS = ((packet[91]) << 8) | (packet[92] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_1 = ((packet[93]) << 8) | (packet[94] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_2 = ((packet[95]) << 8) | (packet[96] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_3 = ((packet[97]) << 8) | (packet[98] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_4 = ((packet[99]) << 8) | (packet[100] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_5 = ((packet[101]) << 8) | (packet[102] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_6 = ((packet[103]) << 8) | (packet[104] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_7 = ((packet[105]) << 8) | (packet[106] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_8 = ((packet[107]) << 8) | (packet[108] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_9 = ((packet[109]) << 8) | (packet[110] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_LOGBOX_10 = ((packet[111]) << 8) | (packet[112] & 0xff);
            
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_1 = ((packet[113]) << 8) | (packet[114] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_2 = ((packet[115]) << 8) | (packet[116] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_3 = ((packet[117]) << 8) | (packet[118] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_4 = ((packet[119]) << 8) | (packet[120] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_5 = ((packet[121]) << 8) | (packet[122] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_6 = ((packet[123]) << 8) | (packet[124] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_7 = ((packet[125]) << 8) | (packet[126] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_8 = ((packet[127]) << 8) | (packet[128] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_9 = ((packet[129]) << 8) | (packet[130] & 0xff);
            device.HR_CS_CH1_CUSTOM_CALIB_PADRAO_10 = ((packet[131]) << 8) | (packet[132] & 0xff);
            
            device.HR_CS_CH1_ALARM_MIN_HYSTERESIS = ((((packet[133]) << 8) | (packet[134] & 0xff))/ div);
            device.HR_CS_CH1_ALARM_MAX_HYSTERESIS = ((((packet[135]) << 8) | (packet[136] & 0xff))/ div);
            device.HR_CS_CH1_ALARM_MIN_MAX_CLEAR_STATUS = ((packet[137]) << 8) | (packet[138] & 0xff);
            device.HR_CS_RESERVED_33 = ((packet[139]) << 8) | (packet[140] & 0xff);
            device.HR_CS_RESERVED_34 = ((packet[141]) << 8) | (packet[142] & 0xff);
            
            device.BLE_HR_CS_CH2_ENABLE = ((packet[143] & 0xff) << 8) | (packet[144] & 0xff);
            if (device.BLE_HR_CS_CH2_ENABLE == 1)
            device.ch2Enabled = true;
            else
            device.ch2Enabled = false;
            
            device.ch2_mode = ((packet[145] & 0xff) << 8) | (packet[146] & 0xff);
            
            device.ch2SensorType = ((packet[147] & 0xff) << 8) | (packet[148] & 0xff);
            
            device.ch2_unit = ((packet[149] & 0xff) << 8) | (packet[150] & 0xff);
            
            device.ch2_n_decimal = ((packet[163] & 0xff) << 8) | (packet[164] & 0xff);//Vem  para cá por que utilizamos esta informação abaixo
            
            if (device.getSensorType(device.ch2SensorType) == 0)
            div = 10;
            else if (device.getSensorType(device.ch2SensorType) == 2)
            div = 100;
            else
            div = (int) pow10(device.ch2_n_decimal);
            
            device.BLE_HR_CS_CH2_RANGE_MIN = (((packet[151]) << 8) | (packet[152] & 0xff));
            device.BLE_HR_CS_CH2_RANGE_MAX = (((packet[153]) << 8) | (packet[154] & 0xff));
            device.ch2_LimitLow = (device.BLE_HR_CS_CH2_RANGE_MIN / div);
            device.ch2_LimitHigh = (device.BLE_HR_CS_CH2_RANGE_MAX / div);
            
            device.BLE_HR_CS_CH2_ENABLE_ALARM_MIN = ((packet[155] & 0xff) << 8) | (packet[156] & 0xff);
            if (device.BLE_HR_CS_CH2_ENABLE_ALARM_MIN == 1)
            device.ch2AlarmHighEnabled = true;
            else
            device.ch2AlarmHighEnabled = false;
            
            device.BLE_HR_CS_CH2_ENABLE_ALARM_MAX = ((packet[157] & 0xff) << 8) | (packet[158] & 0xff);
            if (device.BLE_HR_CS_CH2_ENABLE_ALARM_MAX == 1)
            device.ch2AlarmLowEnabled = true;
            else
            device.ch2AlarmLowEnabled = false;
            
            device.BLE_HR_CS_CH2_ALARM_MIN = ((packet[159]) << 8) | (packet[160] & 0xff);
            device.BLE_HR_CS_CH2_ALARM_MAX = ((packet[161]) << 8) | (packet[162] & 0xff);
            device.ch2AlarmLow = ((((packet[159]) << 8) | (packet[160] & 0xff)) / div);
            device.ch2AlarmHigh = ((((packet[161]) << 8) | (packet[162] & 0xff)) / div);
            
            //device.ch2_n_decimal = ((packet[163] & 0xff) << 8) | (packet[164] & 0xff);
            
            device.HR_CS_CH2_GAIN_USER_RESERVED = ((packet[165] & 0xff) << 8) | (packet[166] & 0xff);
            
            device.BLE_HR_CS_CH2_OFFSET_USER = ((packet[167] << 8) | (packet[168] & 0xff));
            device.ch2UserOffset = (-1) * (((packet[167] << 8) | (packet[168] & 0xff)) / div);
            
            device.HR_CS_RESERVED_36 = ((packet[169] & 0xff) << 8) | (packet[170] & 0xff);
            
            for (int i = 0; i < 16; i++) {
                device.ch2_tag[i] = (byte) (packet[i + 171] & 0xff);
            }
            
            device.BLE_HR_CS_CH2_TAG_1 = ((packet[171]) << 8) | (packet[172] & 0xff);
            device.BLE_HR_CS_CH2_TAG_2 = ((packet[173]) << 8) | (packet[174] & 0xff);
            device.BLE_HR_CS_CH2_TAG_3 = ((packet[175]) << 8) | (packet[176] & 0xff);
            device.BLE_HR_CS_CH2_TAG_4 = ((packet[177]) << 8) | (packet[178] & 0xff);
            device.BLE_HR_CS_CH2_TAG_5 = ((packet[179]) << 8) | (packet[180] & 0xff);
            device.BLE_HR_CS_CH2_TAG_6 = ((packet[181]) << 8) | (packet[182] & 0xff);
            device.BLE_HR_CS_CH2_TAG_7 = ((packet[183]) << 8) | (packet[184] & 0xff);
            device.BLE_HR_CS_CH2_TAG_8 = ((packet[185]) << 8) | (packet[186] & 0xff);
            
            for (int i = 0; i < 8; i++) {
                device.ch2_unit_custom[i] = (byte) (packet[i + 187] & 0xff);
            }
            
            for (int i = 8; i < 16; i++) {
                device.ch2_unit_custom[i] = 0;
            }
            
            device.ch2_unit_custom = parseUnitCustom(device.ch2_unit_custom);
            
            device.BLE_HR_CS_CH2_TAG_UNIT_1 = ((packet[187]) << 8) | (packet[188] & 0xff);
            device.BLE_HR_CS_CH2_TAG_UNIT_2 = ((packet[189]) << 8) | (packet[190] & 0xff);
            device.BLE_HR_CS_CH2_TAG_UNIT_3 = ((packet[191]) << 8) | (packet[192] & 0xff);
            device.BLE_HR_CS_CH2_TAG_UNIT_4 = ((packet[193]) << 8) | (packet[194] & 0xff);
            
            device.HR_CS_RESERVED_37 = ((packet[195] & 0xff) << 8) | (packet[196] & 0xff);
            
            device.HR_CS_CH2_CUSTOM_CALIB_NUM_OF_POINTS = ((packet[197]) << 8) | (packet[198] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_1 = ((packet[199]) << 8) | (packet[200] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_2 = ((packet[201]) << 8) | (packet[202] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_3 = ((packet[203]) << 8) | (packet[204] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_4 = ((packet[205]) << 8) | (packet[206] & 0xff);
            
        }
        catch(Exception e){
            Log.v(TAG2, "Exception Parse RHR Config2");
        }
        
        for (int i=0; i<256; i++)
        packet[i] = 0;
        
    }
    
    public void ParseRHRDataConfig3(){
        Log.v("PARSERHRDATA","parseRHRData()");
        if(packet ==  null)
        return;
        
        if(device == null)
        device = new Device();
        
        try {
            int div;
            
            if (device.getSensorType(device.ch2SensorType) == 0)
            div = 10;
            else if (device.getSensorType(device.ch2SensorType) == 2)
            div = 100;
            else
            div = (int) pow10(device.ch2_n_decimal);
            
            
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_5 = ((packet[7]) << 8) | (packet[8] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_6 = ((packet[9]) << 8) | (packet[10] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_7 = ((packet[11]) << 8) | (packet[12] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_8 = ((packet[13]) << 8) | (packet[14] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_9 = ((packet[15]) << 8) | (packet[16] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_LOGBOX_10 = ((packet[17]) << 8) | (packet[18] & 0xff);
            
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_1 = ((packet[19]) << 8) | (packet[20] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_2 = ((packet[21]) << 8) | (packet[22] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_3 = ((packet[23]) << 8) | (packet[24] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_4 = ((packet[25]) << 8) | (packet[26] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_5 = ((packet[27]) << 8) | (packet[28] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_6 = ((packet[29]) << 8) | (packet[30] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_7 = ((packet[31]) << 8) | (packet[32] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_8 = ((packet[33]) << 8) | (packet[34] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_9 = ((packet[35]) << 8) | (packet[36] & 0xff);
            device.HR_CS_CH2_CUSTOM_CALIB_PADRAO_10 = ((packet[37]) << 8) | (packet[38] & 0xff);
            
            device.HR_CS_CH2_ALARM_MIN_HYSTERESIS = ((((packet[39]) << 8) | (packet[40] & 0xff))/ div);
            device.HR_CS_CH2_ALARM_MAX_HYSTERESIS = ((((packet[41]) << 8) | (packet[42] & 0xff))/ div);
            device.HR_CS_CH2_ALARM_MIN_MAX_CLEAR_STATUS = ((packet[43]) << 8) | (packet[44] & 0xff);
            device.HR_CS_RESERVED_41 = ((packet[45]) << 8) | (packet[46] & 0xff);
            device.HR_CS_RESERVED_42 = ((packet[47]) << 8) | (packet[48] & 0xff);
            
            device.BLE_HR_CS_CH3_ENABLE = ((packet[49] & 0xff) << 8) | (packet[50] & 0xff);
            if (device.BLE_HR_CS_CH3_ENABLE == 1)
            device.ch3Enabled = true;
            else
            device.ch3Enabled = false;
            
            device.ch3_mode = ((packet[51] & 0xff) << 8) | (packet[52] & 0xff);
            
            device.ch3SensorType = ((packet[53] & 0xff) << 8) | (packet[54] & 0xff);
            
            device.ch3_unit = ((packet[55] & 0xff) << 8) | (packet[56] & 0xff);
            
            device.ch3_n_decimal = ((packet[69] & 0xff) << 8) | (packet[70] & 0xff); //Vem  para cá por que utilizamos esta informação abaixo
            
            if (device.getSensorType(device.ch3SensorType) == 0)
            div = 10;
            else if (device.getSensorType(device.ch3SensorType) == 2)
            div = 100;
            else
            div = (int) pow10(device.ch3_n_decimal);
            device.BLE_HR_CS_CH3_RANGE_MIN = (((packet[57]) << 8) | (packet[58] & 0xff));
            device.BLE_HR_CS_CH3_RANGE_MAX = (((packet[59]) << 8) | (packet[60] & 0xff));
            device.ch3_LimitLow = ((((packet[57]) << 8) | (packet[58] & 0xff)) / div);
            device.ch3_LimitHigh = ((((packet[59]) << 8) | (packet[60] & 0xff)) / div);
            
            device.BLE_HR_CS_CH3_ENABLE_ALARM_MAX = ((packet[61] & 0xff) << 8) | (packet[62] & 0xff);
            if (device.BLE_HR_CS_CH3_ENABLE_ALARM_MAX == 1)
            device.ch3AlarmHighEnabled = true;
            else
            device.ch3AlarmHighEnabled = false;
            
            device.BLE_HR_CS_CH3_ENABLE_ALARM_MIN = ((packet[63] & 0xff) << 8) | (packet[64] & 0xff);
            if (device.BLE_HR_CS_CH3_ENABLE_ALARM_MIN == 1)
            device.ch3AlarmLowEnabled = true;
            else
            device.ch3AlarmLowEnabled = false;
            device.BLE_HR_CS_CH3_ALARM_MIN = (((packet[65]) << 8) | (packet[66] & 0xff));
            device.BLE_HR_CS_CH3_ALARM_MAX = (((packet[67]) << 8) | (packet[68] & 0xff));
            device.ch3AlarmLow = ((((packet[65]) << 8) | (packet[66] & 0xff)) / div);
            device.ch3AlarmHigh = ((((packet[67]) << 8) | (packet[68] & 0xff)) / div);
            
            //device.ch3_n_decimal = ((packet[69] & 0xff) << 8) | (packet[70] & 0xff);
            
            device.HR_CS_CH3_GAIN_USER_RESERVED = ((packet[71]) << 8) | (packet[72] & 0xff);
            
            device.BLE_HR_CS_CH3_OFFSET_USER = ((packet[73] << 8) | (packet[74] & 0xff));
            device.ch3UserOffset = (-1) * (((packet[73] << 8) | (packet[74] & 0xff)) / div);
            
            device.HR_CS_RESERVED_44 = ((packet[75]) << 8) | (packet[76] & 0xff);
            
            for (int i = 0; i < 16; i++) {
                device.ch3_tag[i] = (byte) (packet[i + 77] & 0xff);
            }
            device.BLE_HR_CS_CH3_TAG_1 = ((packet[77] << 8) | (packet[78] & 0xff));
            device.BLE_HR_CS_CH3_TAG_2 = ((packet[79] << 8) | (packet[80] & 0xff));
            device.BLE_HR_CS_CH3_TAG_3 = ((packet[81] << 8) | (packet[82] & 0xff));
            device.BLE_HR_CS_CH3_TAG_4 = ((packet[83] << 8) | (packet[84] & 0xff));
            device.BLE_HR_CS_CH3_TAG_5 = ((packet[85] << 8) | (packet[86] & 0xff));
            device.BLE_HR_CS_CH3_TAG_6 = ((packet[87] << 8) | (packet[88] & 0xff));
            device.BLE_HR_CS_CH3_TAG_7 = ((packet[89] << 8) | (packet[90] & 0xff));
            device.BLE_HR_CS_CH3_TAG_8 = ((packet[91] << 8) | (packet[92] & 0xff));
            
            for (int i = 0; i < 8; i++) {
                device.ch3_unit_custom[i] = (byte) (packet[i + 93] & 0xff);
            }
            
            for (int i = 8; i < 16; i++) {
                device.ch3_unit_custom[i] = 0;
            }
            
            device.ch3_unit_custom = parseUnitCustom(device.ch3_unit_custom);
            
            device.BLE_HR_CS_CH3_TAG_UNIT_1 = ((packet[93] << 8) | (packet[94] & 0xff));
            device.BLE_HR_CS_CH3_TAG_UNIT_2 = ((packet[95] << 8) | (packet[96] & 0xff));
            device.BLE_HR_CS_CH3_TAG_UNIT_3 = ((packet[97] << 8) | (packet[98] & 0xff));
            device.BLE_HR_CS_CH3_TAG_UNIT_4 = ((packet[99] << 8) | (packet[100] & 0xff));
            
            device.HR_CS_RESERVED_45 = ((packet[101]) << 8) | (packet[12] & 0xff);
            
            device.HR_CS_CH3_CUSTOM_CALIB_NUM_OF_POINTS = ((packet[103]) << 8) | (packet[104] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_1 = ((packet[105]) << 8) | (packet[106] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_2 = ((packet[107]) << 8) | (packet[108] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_3 = ((packet[109]) << 8) | (packet[110] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_4 = ((packet[111]) << 8) | (packet[112] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_5 = ((packet[113]) << 8) | (packet[114] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_6 = ((packet[115]) << 8) | (packet[116] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_7 = ((packet[117]) << 8) | (packet[118] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_8 = ((packet[119]) << 8) | (packet[120] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_9 = ((packet[121]) << 8) | (packet[122] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_LOGBOX_10 = ((packet[123]) << 8) | (packet[124] & 0xff);
            
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_1 = ((packet[125]) << 8) | (packet[126] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_2 = ((packet[127]) << 8) | (packet[128] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_3 = ((packet[129]) << 8) | (packet[130] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_4 = ((packet[131]) << 8) | (packet[132] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_5 = ((packet[133]) << 8) | (packet[134] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_6 = ((packet[135]) << 8) | (packet[136] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_7 = ((packet[137]) << 8) | (packet[138] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_8 = ((packet[139]) << 8) | (packet[140] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_9 = ((packet[141]) << 8) | (packet[142] & 0xff);
            device.HR_CS_CH3_CUSTOM_CALIB_PADRAO_10 = ((packet[143]) << 8) | (packet[144] & 0xff);
            
            device.HR_CS_CH3_ALARM_MIN_HYSTERESIS = ((((packet[145]) << 8) | (packet[146] & 0xff))/ div);
            device.HR_CS_CH3_ALARM_MAX_HYSTERESIS = ((((packet[147]) << 8) | (packet[148] & 0xff))/ div);
            device.HR_CS_CH3_ALARM_MIN_MAX_CLEAR_STATUS = ((packet[149]) << 8) | (packet[150] & 0xff);
        }
        catch(Exception e){
            Log.v(TAG2, "Exception Parse RHR Config2");
        }
        for (int i=0; i<256; i++)
        packet[i] = 0;
        
    }
    
    public static byte[] addPos(byte[] a, int pos, byte num) {
        byte[] result = new byte[a.length];
        for(int i = 0; i < pos; i++)
        result[i] = a[i];
        result[pos] = num;
        for(int i = pos + 1; i < a.length; i++)
        result[i] = a[i - 1];
        return result;
    }
    
    public byte[] parseUnitCustom(byte[] bytes){
        for(int i = 0; i < 16; i++){
            if((bytes[i] > 127)||(bytes[i] < 0)){
                //colocar c2 no lugar
                bytes = addPos(bytes, i, (byte)0xC2);
                i++;
                //shiftar todos os elementos uma casa
            }
        }
        return bytes;
    }
    
    
    
    public void parseDownload() {
        Log.v("DP PARSERHRDATA", "parseDOWNLOADData()");
        if (packet == null)
        return;
        
        //se chegou o E6 no byte 6,
        if (device != null) {
            
            if ((packet[0] == 0x5A) && (packet[5] == -26)/*||(totalSamplesPacket >= 3000)*/) {
                //o download acabou
                if((packet[6] == 0x31)||(packet[6] == 0x32)/*||(totalSamplesPacket >= 3000)*/) {
                    Log.v("DP Fim Download", "Fim");
                    device.logsDownloaded = device.downloadPointer;
                    device.downloadEnd = true;
                    totalSamplesPacket = 0; //Ajuste RafaelSilva
                    downloadBlockId = 0;
                    device.downloadPointer = 0;
                    device.digiEventsLogsDownloaded = device.digitalEventsPointer;
                    zeraPacket();
                    return;
                }
            }
        }
        
        if (device == null)
        device = new Device();
        
        //numero de canais habilitados
        device.channelsEnabled = packet[7];
        Log.v("DP channelsEnabled", String.valueOf(device.channelsEnabled));
        
        //primeiro bloco inicializações
        
        if (downloadBlockId == 0){
            CanaisHabilitados = 0;
            
            boolean CanalDigital_Eventos = false;
            
            if(device.chdEnabled && device.chd_inpuType == device.DIGITAL_COUNTER) CanaisHabilitados++;
            if(device.ch1Enabled == true) CanaisHabilitados++;
            if(device.ch2Enabled == true) CanaisHabilitados++;
            if(device.ch3Enabled == true) CanaisHabilitados++;
            device.channels = new Channel[CanaisHabilitados];//device.channelsEnabled
            for (int i = 0; i < CanaisHabilitados; i++) {//device.channelsEnabled
                device.channels[i] = new Channel();
            }
            
            if(device.chdEnabled && device.chd_inpuType == device.DIGITAL_EVENT_LOG) {
                CanalDigital_Eventos = true;
                device.digitalChannel = new Channel();
            }
            
            MountChannelsParameters(CanalDigital_Eventos, CanaisHabilitados);//Monta Estruturas para calculo dos valores.
            
            device.downloadPointer = 0;
            device.samplesNumber = 0;
            
        }
        
        //numero de registros POR CANAL no pacote
        int numSamplesPacket = packet[8];
        totalSamplesPacket += numSamplesPacket;
        
        Log.v("DP SamplesPacket", String.valueOf(totalSamplesPacket));
        
        //TODO verificar tipo de timestamp
        int control = packet[10];
        
        //cria timestamp do pacote
        int year = ((packet[11] & 0xff) + 2016);
        int month = (packet[12] & 0xff);
        int day = (packet[13] & 0xff);
        int hour = (byte)(packet[14] & 0xff);
        int minute = (byte)(packet[15] & 0xff);
        int second = (byte)(packet[16] & 0xff);
        //TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        
        String date = String.format("%02d",day) + "/" + String.format("%02d",month) + "/" + String.format("%04d",year) + " " + String.format("%02d",hour) + ":" + String.format("%02d",minute) + ":" + String.format("%02d",second);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
        Date packetTimestamp = null;
        
        try {
            packetTimestamp = sdf.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        long longDate = packetTimestamp.getTime()/1000;
        
        int index = numSamplesPacket;
        
        Log.v("Ld1",String.valueOf((longDate + (numSamplesPacket * device.interval))));
        Log.v("Ld2",String.valueOf(device.downloadlastDate.getTime()/1000));
        
        if ((longDate ) > (device.downloadlastDate.getTime()/1000)) {
            Log.v("DP Fim Download", "Fim");
            device.logsDownloaded = device.downloadPointer;
            device.downloadEnd = true;
            downloadBlockId = 0;
            device.downloadPointer = 0;
            zeraPacket();
            return;
        }
        
        if ((longDate + (numSamplesPacket * device.interval)) > (device.downloadlastDate.getTime()/1000)) {
            Log.v("Ld1",String.valueOf(packetTimestamp));
            Log.v("Ld2",String.valueOf(device.downloadlastDate));
            index = (int) ((device.downloadlastDate.getTime() / 1000) - longDate) / (device.interval);
        }
        
        Log.v("DP InDEX",String.valueOf(index));
        
        short temp = 0;
        if((control == 0)||(control == 1)) {
            //cria numero de amostras e concatena com as existentes
            //for(int i = 0; i <  device.channelsEnabled; i++) {
            //  for(int j = 0; j < numSamplesPacket; j++){
            //    Log.v("DP DDP",String.valueOf(device.downloadPointer));
            //  device.channels[i].samples[device.downloadPointer + j] = new Sample();
            //}
            //}
            
            if (CanaisHabilitados > 0) {
                String subLog = "";
                int Eindex0, Eindex1;
                for (int i = 0; i < index; i++) {
                    device.samplesNumber++;
                    for (int j = 0; j < device.channelsEnabled; j++) {
                        
                        Eindex0 = 17 + (2 * j) + ((2 * device.channelsEnabled) * i);
                        Eindex1 = 18 + (2 * j) + ((2 * device.channelsEnabled) * i);
                        
                        subLog = ConvertHexByteToString(packet[Eindex0]).toUpperCase().trim();
                        subLog += ConvertHexByteToString(packet[Eindex1]).toUpperCase().trim();
                        temp = (short) Integer.parseInt(subLog, 16);
                        
                        device.channels[j].samples.add(new Sample());
                        device.channels[j].samples.get(device.downloadPointer + i).temp = temp;
                        device.channels[j].samples.get(device.downloadPointer + i).fTemp = device.ApplyDecimalPlaceF(ChIsDigital[j], ChannelsSensorTypes[j], ChannelsDecimalPlaces[j], temp);
                        device.channels[j].samples.get(device.downloadPointer + i).sTemp = device.FormatValue(device.channels[j].samples.get(device.downloadPointer + i).fTemp, ChannelsDecimalPlaces[j]);
                        device.channels[j].avg += device.channels[j].samples.get(device.downloadPointer + i).fTemp;
                        
                        device.channels[j].samples.get(device.downloadPointer + i).DataHoraUTC = new Date((longDate + device.interval * i) * 1000);
                        device.channels[j].samples.get(device.downloadPointer + i).DataHora = device.getTimewithGMT(device.gmt, new Date((longDate + device.interval * i) * 1000));
                        int teste = 456;
                        
                    }
                }
                
                device.downloadPointer = device.downloadPointer + index;
            }
        }
        
        if((control == 3)||(control == 2)){
            if(device.digitalChannel == null)
            device.digitalChannel = new Channel();
            for(int i = 0; i < numSamplesPacket; i++){
                //Fabio coleta
                device.digitalChannel.samples.add(new Sample());
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).MiliSeconds = (short)(((packet[17 + 2 * i]) << 8) | (packet[18 + 2 * i]));
                
                if(control == 2) temp = 1;
                else temp = 0;
                
                device.digitalChannel.avg += temp;
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).temp = temp;
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).fTemp = temp;
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).sTemp = Integer.toString(temp);
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).DataHoraUTC = new Date((longDate + device.interval * i) * 1000);
                device.digitalChannel.samples.get(device.digitalEventsPointer + i).DataHora = device.getTimewithGMT(device.gmt, new Date((longDate + device.interval * i) * 1000));
            }
            
            device.digitalEventsPointer = device.digitalEventsPointer + numSamplesPacket;
        }
        
        Log.v("DP DP",String.valueOf(downloadBlockId));
        
        downloadBlockId++;
        
        for (int i=0; i<256; i++){
            packet[i] = 0;
        }
    }
    
    //***********************************************************************/
    //* the function Convert byte value to a "2-char String" Format
    //* Example : ConvertHexByteToString ((byte)0X0F) -> returns "0F"
    //***********************************************************************/
    public static String ConvertHexByteToString (byte byteToConvert)
{
    String ConvertedByte = "";
    if (byteToConvert < 0) {
        ConvertedByte += Integer.toString(byteToConvert + 256, 16)
            + " ";
    } else if (byteToConvert <= 15) {
        ConvertedByte += "0" + Integer.toString(byteToConvert, 16)
            + " ";
    } else {
        ConvertedByte += Integer.toString(byteToConvert, 16) + " ";
    }
    
    return ConvertedByte;
    }
    
    public void StartStop(){ //Make StartStop RafaelSilva
        
        stateStartStop = 0;
        configIndex = 0;
        
        if(ssThread == null)
        ssThread = new StartStop();
        else{
            ssThread.interrupt();
            ssThread = null;
            ssThread = new StartStop();
        }
        
        ssThread.start();
        
    }
    
    public StartStop ssThread; //Make StartStop RafaelSilva
    class StartStop extends Thread{
        boolean ssThreadKill = false;
        int cont = 0;
        int cont2 = 0;
        int stateFail = 0;
        boolean closeInterrupted = false;
        public void run(){
            
            if(stateStartStop != 0) stateStartStop = 0;
            
            Log.v("startStop",String.format("ssThread run kill = %b", ssThreadKill));
            Log.v("startStop",String.format("ssThread while stateStartStop = %d", stateStartStop));
            
            while(!ssThreadKill) {
                Log.v("startStop",String.format("ssThread while kill = %b", ssThreadKill));
                Log.v("startStop",String.format("ssThread while stateStartStop = %d", stateStartStop));
                
                if(stateStartStop == 0){
                    
                    if(state == 2) {
                        stateStartStop = 3;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    else {
                        cont++;
                        try {
                        Thread.sleep(700);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont > 50) {
                        stateFail = 0;
                        stateStartStop = 16;
                        cont = 0;
                    }
                }
                    
                else if(stateStartStop == 3){
                    Log.v("startStop","BLEService 3 Init");
                    cont = 0;
                    
                    if(OpenSession(SESSION_START_STOP))
                    Log.v("startStop","BLEService 3 OpenSession");
                    stateStartStop = 5;
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                    
                else if(stateStartStop == 4){
                    Log.v("stateStartStop","4");
                    if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_START_STOP){
                        stateStartStop = 5;
                        Log.v("OpenSession2","Ok");
                        zeraPacket();
                    }
                        
                    else{
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        stateFail = 0;
                        stateStartStop = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(200);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                    
                else if (stateStartStop == 5) {
                    Log.v("stateStartStop","5");
                    
                    Log.v("stateStartStop",String.format("Status = %d", device.BLE_HR_SS_STATUS_OF_RECORDS));
                    
                    if(device.HR_SS_RECORDS_STARTED_INTERFACE == 0){
                        Log.v("stateStartStop",String.format("%d", device.startMode));
                    }else if(device.HR_SS_RECORDS_STOPPED_INTERFACE == 0){
                        Log.v("stateStartStop","5 - Stopped Log");
                    }
                    
                    cont = 0;
                    if(device.BLE_HR_SS_STATUS_OF_RECORDS == 1){
                        if(StartStopLog(START_LOG)) {
                            device.BLE_HR_SS_STATUS_OF_RECORDS = 2;
                            Log.v("stateStartStop", "Start-Log");
                            stateStartStop = 6;
                        }
                        else{
                            try {
                            Thread.sleep(100);
                            } catch (InterruptedException e) {
                            e.printStackTrace();
                            }
                        }
                    }else{
                        if(StartStopLog(STOP_LOG)) {
                            device.BLE_HR_SS_STATUS_OF_RECORDS = 1;
                            Log.v("stateStartStop", "Stop-Log");
                            stateStartStop = 6;
                        }
                        else{
                            try {
                            Thread.sleep(100);
                            } catch (InterruptedException e) {
                            e.printStackTrace();
                            }
                        }
                    }
                    
                    try {
                    Thread.sleep(200);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateStartStop == 6) {
                    Log.v("stateStartStop","6");
                    //espera bloco 1
                    if(sessionOpened == SESSION_START_STOP){
                        stateStartStop = 13;
                        Log.v("WriteMultRegs1","Ok");
                    }
                        
                    else{
                        Log.v("stateStartStop state 6",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        Log.v("stateStartStop","6-16");
                        stateFail = 0;
                        stateStartStop = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if(stateStartStop == 13){
                    Log.v("Pré","CloseSession");
                    
                    if(CloseSession())
                    stateStartStop = 15;
                    
                    else {
                        cont++;
                        Log.v("fail close session","false");
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        Log.v("stateStartStop","6-13");
                        stateFail = 0;
                        stateStartStop = 16;
                        cont = 0;
                    }
                }
                    
                else if(stateStartStop == 15){
                    boolean n = mBluetoothManager.getAdapter().setName(getSsidNew());
                    if(n)
                    Log.v("Trocou StartStop","OK");
                    else
                    Log.v("Trocou","NNNOK");
                    
                    stateStartStop = 17;
                }
                    
                else if(stateStartStop == 16){
                    
                    ssThreadKill = true;
                    this.interrupt();
                    ssThread = null;
                    
                }
                    
                else if(stateStartStop == 17){
                    ssThreadKill = true;
                    this.interrupt();
                    ssThread = null;
                }
                
                if(state == 3){
                    ssThreadKill = true;
                    this.interrupt();
                    ssThread = null;
                    
                }
                if(isInterrupted()){
                    ssThread = null;
                    return;
                }
                
            }
            
            this.interrupt();
        }
    }
    
    public void ApplyConfig(){
        
        stateApplyConfig = 0;
        configIndex = 0;
        
        if(apThread == null)
        apThread = new ApplyConfig();
        else{
            apThread.interrupt();
            apThread = null;
            apThread = new ApplyConfig();
        }
        
        apThread.start();
        
    }
    
    
    public ApplyConfig apThread;
    class ApplyConfig extends Thread{
        boolean kill = false;
        int cont = 0;
        int cont2 = 0;
        int stateFail = 0;
        boolean closeInterrupted = false;
        public void run(){
            while(!kill) {
                
                if(stateApplyConfig == 0){
                    
                    if(state == 2) {
                        stateApplyConfig = 3;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    else {
                        cont++;
                        try {
                        Thread.sleep(700);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont > 50) {
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                }
                    
                else if(stateApplyConfig == 3){
                    cont = 0;
                    if(OpenSession(SESSION_CONFIGURATION))
                    stateApplyConfig = 4;
                    
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                    
                else if(stateApplyConfig == 4){
                    if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_CONFIGURATION){
                        stateApplyConfig = 5;
                        Log.v("OpenSession2","Ok");
                        zeraPacket();
                    }
                        
                    else{
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(200);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                    
                    //por aqui vai ter um for que vai mandar comandos e receber respostas
                    //atraves de um vetor de endereços e um vetor de valores a serem setados
                else if (stateApplyConfig == 5) {
                    //envia bloco 1
                    
                    cont = 0;
                    if(WriteMultipleRegisters((short)1001,(short)67,configValues1))
                    stateApplyConfig = 6;
                    else{
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    try {
                    Thread.sleep(200);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 6) {
                    //espera bloco 1
                    if(packetFinished && packet[5] == WRITE_MULTIPLE_REGISTERS && sessionOpened == SESSION_CONFIGURATION){
                        stateApplyConfig = 7;//7;
                        Log.v("WriteMultRegs1","Ok");
                    }
                        
                    else{
                        Log.v("applyconfig state 6",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 7) {
                    //envia bloco 2
                    zeraPacket();
                    cont = 0;
                    if(WriteMultipleRegisters((short)1068,(short)67, configValues2))
                    stateApplyConfig = 8;
                    else{
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 8) {
                    //espera bloco 2
                    if(packetFinished && packet[5] == WRITE_MULTIPLE_REGISTERS && sessionOpened == SESSION_CONFIGURATION){
                        stateApplyConfig = 9;
                        Log.v("WriteMultRegs1","Ok");
                    }
                        
                    else{
                        Log.v("applyconfig state 8",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        closeInterrupted = true;
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 9) {
                    //envia bloco 3
                    zeraPacket();
                    cont = 0;
                    if(WriteMultipleRegisters((short)1135,(short)67,configValues3))
                    stateApplyConfig = 10;
                    else{
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                }
                    
                else if (stateApplyConfig == 10) {
                    //espera bloco 3
                    if(packetFinished && packet[5] == WRITE_MULTIPLE_REGISTERS && sessionOpened == SESSION_CONFIGURATION){
                        stateApplyConfig = 11;
                        Log.v("WriteMultRegs1","Ok");
                    }
                        
                    else{
                        Log.v("applyconfig state 10",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        closeInterrupted = true;
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 11) {
                    //envia bloco 1
                    zeraPacket();
                    cont = 0;
                    if(WriteMultipleRegisters((short)1202,(short)70,configValues4))
                    stateApplyConfig = 12;
                    else{
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    try {
                    Thread.sleep(200);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if (stateApplyConfig == 12) {
                    //espera bloco 1
                    if(packetFinished && packet[5] == WRITE_MULTIPLE_REGISTERS && sessionOpened == SESSION_CONFIGURATION){
                        stateApplyConfig = 13;//7;
                        Log.v("WriteMultRegs1","Ok");
                    }
                        
                    else{
                        Log.v("applyconfig state 12",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        closeInterrupted = true;
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                    
                    try {
                    Thread.sleep(100);
                    } catch (InterruptedException e) {
                    e.printStackTrace();
                    }
                    
                }
                    
                else if(stateApplyConfig == 13){
                    Log.v("Pré","CloseSession");
                    
                    if(CloseSession())
                    stateApplyConfig = 14;
                    
                    else {
                        cont++;
                        Log.v("fail close session","false");
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                }
                    
                else if(stateApplyConfig == 14){
                    Log.v("entrou em 8","Ovvvvk");
                    if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_NONE){
                        Log.v("CloseSession","Ok");
                        if(!closeInterrupted)
                        stateApplyConfig = 15;
                        else
                        stateApplyConfig = 16;
                        Log.v("ok close",String.valueOf(packet[0])+ " " +String.valueOf(packet[1])+ " " +String.valueOf(packet[2])+ " " +String.valueOf(packet[3])+ " " +String.valueOf(packet[4])+ " " +
                        String.valueOf(packet[5])+ " " +String.valueOf(packet[6])+ " "+String.valueOf(packet[7])+ " "+String.valueOf(packet[8])+ " "+String.valueOf(packet[9])+ " ");
                        
                        
                    }else {
                        cont++;
                        Log.v("error close",String.valueOf(packet[0])+ " " +String.valueOf(packet[1])+ " " +String.valueOf(packet[2])+ " " +String.valueOf(packet[3])+ " " +String.valueOf(packet[4])+ " " +
                            String.valueOf(packet[5])+ " " +String.valueOf(packet[6])+ " "+String.valueOf(packet[7])+ " "+String.valueOf(packet[8])+ " "+String.valueOf(packet[9])+ " ");
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        stateFail = 0;
                        stateApplyConfig = 16;
                        cont = 0;
                    }
                }
                    
                else if(stateApplyConfig == 15){
                    boolean n = mBluetoothManager.getAdapter().setName(getSsidNew());
                    if(n)
                    Log.v("Trocou","OK");
                    else
                    Log.v("Trocou","NNNOK");
                    
                    
                    
                    stateApplyConfig = 17;
                    
                    /*disconnect();
                     
                     try {
                     Thread.sleep(600);
                     } catch (InterruptedException e) {
                     e.printStackTrace();
                     }*/
                    
                    
                }
                    
                else if(stateApplyConfig == 16){
                    
                    //                    closeInterrupted =  false;
                    //try {
                    //    Thread.sleep(2000);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    
                    //stateApplyConfig = 17;
                    /*disconnect();
                     
                     try {
                     Thread.sleep(600);
                     } catch (InterruptedException e) {
                     e.printStackTrace();
                     }*/
                    
                    //connect(mBluetoothDeviceAddress);
                    
                    //                  stateApplyConfig = stateFail;*/
                    kill = true;
                    this.interrupt();
                    apThread = null;
                    
                }
                    
                else if(stateApplyConfig == 17){
                    //disconnect();
                    kill = true;
                    this.interrupt();
                    apThread = null;
                    
                    
                }
                
                
                
                if(state == 3){
                    kill = true;
                    this.interrupt();
                    
                }
                if(isInterrupted())
                return;
            }
            
            //disconnect();
            this.interrupt();
        }
    }
    
    public String getSsidNew(){
        byte [] temp = new byte[8];
        
        temp[0] = (byte) configValues1[53];
        temp[1] = (byte) ((configValues1[53] &0xFF)<<8);
        temp[2] = (byte) configValues1[54];
        temp[3] = (byte) ((configValues1[54] &0xFF)<<8);
        temp[4] = (byte) configValues1[55];
        temp[5] = (byte) ((configValues1[55] &0xFF)<<8);
        temp[6] = (byte) configValues1[56];
        temp[7] = (byte) ((configValues1[56] &0xFF)<<8);
        
        return new String(temp);
        
    }
    
    public void VerificaPeriodosEmAlarme(int index) {
        float AlarmLow = this.AlarmLow[index];
        float AlarmHigh = this.AlarmHigh[index];
        boolean lowListOpen = false;
        boolean highListOpen = false;
        
        Sample amostra;
        T_PERIODO_ALARME PeriodoAlarmeHigh= null;
        T_PERIODO_ALARME PeriodoAlarmeLow=null;
        
        int overallHighCount = 0;
        int overallLowCount = 0;
        Sample highLogs[] = new Sample[device.samplesNumber];
        Sample lowLogs[] = new Sample[device.samplesNumber];
        
        for(int i = 0;i < device.samplesNumber; i++)
        {
            amostra = device.channels[index].samples.get(i);
            
            //amostra.fTemp = device.ApplyDecimalPlaceF( ChIsDigital[index], ChannelsSensorTypes[index], ChannelsDecimalPlaces[index], amostra.temp);
            
            if(amostra.fTemp > AlarmHigh)
            {
                Sample temp = new Sample();
                temp.DataHora = amostra.DataHora;//getDate2(i);
                temp.temp = amostra.temp;
                temp.fTemp = amostra.fTemp;
                temp.sTemp = amostra.sTemp;
                highLogs[overallHighCount]=temp;
                overallHighCount++;
                
                if(highListOpen == false)//se nao tem periodo aberto, cria o periodo para comecar a adicionar informacoes
                {
                    PeriodoAlarmeHigh = new T_PERIODO_ALARME();
                    highListOpen = true;
                    
                    PeriodoAlarmeHigh.DataInicial = amostra.DataHora;//getDate2(i);
                    PeriodoAlarmeHigh.NumeroAquisicoes = 1;
                    PeriodoAlarmeHigh.avgTemp = amostra.fTemp;
                }
                else //so adiciona registros na lista ja existente.
                {
                    //PeriodoAlarmeHigh.DataFinal = amostra.DataHora;//getDate2(i);
                    PeriodoAlarmeHigh.DataFinal = amostra.DataHora;//getDate2(i);
                    PeriodoAlarmeHigh.NumeroAquisicoes++;
                    PeriodoAlarmeHigh.avgTemp += amostra.fTemp;
                }
            }
            else
            {
                if(highListOpen == true)//fecha o periodo e aloca na lista
                {
                    highListOpen = false;
                    
                    if(PeriodoAlarmeHigh.NumeroAquisicoes > 1)
                    PeriodoAlarmeHigh.avgTemp = PeriodoAlarmeHigh.avgTemp / PeriodoAlarmeHigh.NumeroAquisicoes;
                    else //se so tem 1 aquisicao, data inicial igual a final
                    PeriodoAlarmeHigh.DataFinal = PeriodoAlarmeHigh.DataInicial;
                    
                    device.channels[index].PeriodosAlarmesHigh.add(PeriodoAlarmeHigh);
                }
            }
            
            if((amostra.fTemp < AlarmLow))// &&(amostra.valorTag != 0.0))
            {
                
                Sample temp = new Sample();
                temp.DataHora = amostra.DataHora;//getDate2(i);
                temp.temp = amostra.temp;
                temp.fTemp = amostra.fTemp;
                temp.sTemp = amostra.sTemp;
                lowLogs[overallLowCount]=temp;
                overallLowCount++;
                
                if(lowListOpen == false)//se nao tem periodo aberto, cria o periodo para comecar a adicionar informacoes
                {
                    PeriodoAlarmeLow = new T_PERIODO_ALARME();
                    lowListOpen = true;
                    
                    PeriodoAlarmeLow.DataInicial = amostra.DataHora;//getDate2(i);
                    PeriodoAlarmeLow.NumeroAquisicoes = 1;
                    PeriodoAlarmeLow.avgTemp = amostra.fTemp;
                }
                else //so adiciona registros na lista ja existente.
                {
                    PeriodoAlarmeLow.DataFinal = amostra.DataHora;//getDate2(i);
                    PeriodoAlarmeLow.NumeroAquisicoes++;
                    PeriodoAlarmeLow.avgTemp += amostra.fTemp;
                }
            }
            else
            {
                if(lowListOpen == true)//fecha o periodo e aloca na lista
                {
                    lowListOpen = false;
                    
                    if(PeriodoAlarmeLow.NumeroAquisicoes > 1)
                    PeriodoAlarmeLow.avgTemp = PeriodoAlarmeLow.avgTemp / PeriodoAlarmeLow.NumeroAquisicoes;
                    else //se so tem 1 aquisicao, data inicial igual a final
                    PeriodoAlarmeLow.DataFinal = PeriodoAlarmeLow.DataInicial;
                    
                    device.channels[index].PeriodosAlarmesLow.add(PeriodoAlarmeLow);
                }
            }
        }
        
        device.channels[index].setLogHighAlarmArray(highLogs, overallHighCount);
        device.channels[index].setNumOfHighAlarms(overallHighCount);
        
        device.channels[index].setLogLowAlarmArray(lowLogs, overallLowCount);
        device.channels[index].setNumOfLowAlarms(overallLowCount);
        
        if(highListOpen == true)//fecha o periodo e aloca na lista
        {
            highListOpen = false;
            
            if(PeriodoAlarmeHigh.NumeroAquisicoes > 1)
            PeriodoAlarmeHigh.avgTemp = PeriodoAlarmeHigh.avgTemp / PeriodoAlarmeHigh.NumeroAquisicoes;
            else //se so tem 1 aquisicao, data inicial igual a final
            PeriodoAlarmeHigh.DataFinal = PeriodoAlarmeHigh.DataInicial;
            
            device.channels[index].PeriodosAlarmesHigh.add(PeriodoAlarmeHigh);
        }
        
        if(lowListOpen == true)
        {
            lowListOpen = false;
            
            if(PeriodoAlarmeLow.NumeroAquisicoes > 1)
            PeriodoAlarmeLow.avgTemp = PeriodoAlarmeLow.avgTemp / PeriodoAlarmeLow.NumeroAquisicoes;
            else //se so tem 1 aquisicao, data inicial igual a final
            PeriodoAlarmeLow.DataFinal = PeriodoAlarmeLow.DataInicial;
            
            device.channels[index].PeriodosAlarmesLow.add(PeriodoAlarmeLow);
        }
    }
    
    
    
    public void MountChannelsParameters(boolean Digital_Event, int ChannelsEnabled){
        Log.v("InitAlarms",String.valueOf(ChannelsEnabled));//device.channelsEnabled
        AlarmHigh = new float[ChannelsEnabled];
        AlarmLow = new float[ChannelsEnabled];
        
        ChIsDigital = new boolean[ChannelsEnabled];
        ChannelsDecimalPlaces = new int[ChannelsEnabled];
        ChannelsSensorTypes = new int[ChannelsEnabled];
        
        int contAlarmHigh[] = new int[ChannelsEnabled];
        int contAlarmLow[] = new int[ChannelsEnabled];
        
        for(int i = 0; i < ChannelsEnabled; i++){
            contAlarmHigh[i] = 0;
            contAlarmLow[i] = 0;
        }
        
        
        if(device.chdEnabled && (device.chd_inpuType == device.DIGITAL_COUNTER)) {
            if(device.chdAlarmHighEnabled)
            AlarmHigh[0] = device.chdAlarmHigh;
            if(device.chdAlarmLowEnabled)
            AlarmLow[0] = device.chdAlarmLow;
            
            ChIsDigital[0] = true;
            ChannelsDecimalPlaces[0] = device.HR_CS_CHD_DECIMAL_POINT;
            ChannelsSensorTypes[0] = device.chd_sensorType;
        }
        
        if(device.ch1Enabled){
            if(device.chdEnabled && (device.chd_inpuType == device.DIGITAL_COUNTER)) {
                if(device.ch1AlarmHighEnabled)
                AlarmHigh[1] = device.ch1AlarmHigh;
                if(device.ch1AlarmLowEnabled)
                AlarmLow[1] = device.ch1AlarmLow;
                
                ChIsDigital[1] = false;
                ChannelsDecimalPlaces[1] = device.ch1_n_decimal ;
                ChannelsSensorTypes[1] = device.ch1SensorType;
            }
            else{
                if(device.ch1AlarmHighEnabled)
                AlarmHigh[0] = device.ch1AlarmHigh;
                if(device.ch1AlarmLowEnabled)
                AlarmLow[0] = device.ch1AlarmLow;
                
                ChIsDigital[0] = false;
                ChannelsDecimalPlaces[0] = device.ch1_n_decimal ;
                ChannelsSensorTypes[0] = device.ch1SensorType;
            }
        }
        
        if(device.ch2Enabled){
            if((device.chdEnabled  && (device.chd_inpuType == device.DIGITAL_COUNTER))&&(device.ch1Enabled)) {
                if(device.ch2AlarmHighEnabled)
                AlarmHigh[2] = device.ch2AlarmHigh;
                if(device.ch2AlarmLowEnabled)
                AlarmLow[2] = device.ch2AlarmLow;
                
                ChIsDigital[2] = false;
                ChannelsDecimalPlaces[2] = device.ch2_n_decimal ;
                ChannelsSensorTypes[2] = device.ch2SensorType;
            }
            else if(((!device.chdEnabled)||(device.chdEnabled  && (device.chd_inpuType != device.DIGITAL_COUNTER)))&&(!device.ch1Enabled)){
                if(device.ch2AlarmHighEnabled)
                AlarmHigh[0] = device.ch2AlarmHigh;
                if(device.ch2AlarmLowEnabled)
                AlarmLow[0] = device.ch2AlarmLow;
                
                ChIsDigital[0] = false;
                ChannelsDecimalPlaces[0] = device.ch2_n_decimal ;
                ChannelsSensorTypes[0] = device.ch2SensorType;
            }
            else{
                if(device.ch2AlarmHighEnabled)
                AlarmHigh[1] = device.ch2AlarmHigh;
                if(device.ch2AlarmLowEnabled)
                AlarmLow[1] = device.ch2AlarmLow;
                
                ChIsDigital[1] = false;
                ChannelsDecimalPlaces[1] = device.ch2_n_decimal ;
                ChannelsSensorTypes[1] = device.ch2SensorType;
            }
        }
        
        if(device.ch3Enabled){
            if((device.ch2Enabled)&&((device.chdEnabled  && (device.chd_inpuType == device.DIGITAL_COUNTER)))&&(device.ch1Enabled)) {
                if(device.ch3AlarmHighEnabled)
                AlarmHigh[3] = device.ch3AlarmHigh;
                if(device.ch3AlarmLowEnabled)
                AlarmLow[3] = device.ch3AlarmLow;
                
                ChIsDigital[3] = false;
                ChannelsDecimalPlaces[3] = device.ch3_n_decimal ;
                ChannelsSensorTypes[3] = device.ch3SensorType;
            }
            else if((!device.ch2Enabled)&&(((!device.chdEnabled)||(device.chdEnabled  && (device.chd_inpuType != device.DIGITAL_COUNTER))))&&(!device.ch1Enabled)){
                if(device.ch3AlarmHighEnabled)
                AlarmHigh[0] = device.ch3AlarmHigh;
                if(device.ch2AlarmLowEnabled)
                AlarmLow[0] = device.ch3AlarmLow;
                
                ChIsDigital[0] = false;
                ChannelsDecimalPlaces[0] = device.ch3_n_decimal ;
                ChannelsSensorTypes[0] = device.ch3SensorType;
            }
            else if(ChannelsEnabled == 3){
                if(device.ch3AlarmHighEnabled)
                AlarmHigh[2] = device.ch3AlarmHigh;
                if(device.ch3AlarmLowEnabled)
                AlarmLow[2] = device.ch3AlarmLow;
                
                ChIsDigital[2] = false;
                ChannelsDecimalPlaces[2] = device.ch3_n_decimal ;
                ChannelsSensorTypes[2] = device.ch3SensorType;
            }
            else{
                if(device.ch3AlarmHighEnabled)
                AlarmHigh[1] = device.ch3AlarmHigh;
                if(device.ch3AlarmLowEnabled)
                AlarmLow[1] = device.ch3AlarmLow;
                
                ChIsDigital[1] = false;
                ChannelsDecimalPlaces[1] = device.ch3_n_decimal ;
                ChannelsSensorTypes[1] = device.ch3SensorType;
            }
        }
    }
    
    
    public void initAlarms(){
        
        //        Log.v("InitAlarms",String.valueOf(device.channelsEnabled));
        //        AlarmHigh = new float[device.channelsEnabled];
        //        AlarmLow = new float[device.channelsEnabled];
        //
        //        ChIsDigital = new boolean[device.channelsEnabled];
        //        ChannelsDecimalPlaces = new int[device.channelsEnabled];
        //        ChannelsSensorTypes = new int[device.channelsEnabled];
        //
        //        int contAlarmHigh[] = new int[device.channelsEnabled];
        //        int contAlarmLow[] = new int[device.channelsEnabled];
        //
        //        for(int i = 0; i < device.channelsEnabled; i++){
        //            contAlarmHigh[i] = 0;
        //            contAlarmLow[i] = 0;
        //        }
        //
        //
        //
        //        if(device.chdEnabled) {
        //            if(device.chdAlarmHighEnabled)
        //                AlarmHigh[0] = device.chdAlarmHigh;
        //            if(device.chdAlarmLowEnabled)
        //                AlarmLow[0] = device.chdAlarmLow;
        //
        //            ChIsDigital[0] = true;
        //            ChannelsDecimalPlaces[0] = device.HR_CS_CHD_DECIMAL_POINT;
        //            ChannelsSensorTypes[0] = device.chd_sensorType;
        //        }
        //
        //        if(device.ch1Enabled){
        //            if(device.chdEnabled) {
        //                if(device.ch1AlarmHighEnabled)
        //                    AlarmHigh[1] = device.ch1AlarmHigh;
        //                if(device.ch1AlarmLowEnabled)
        //                    AlarmLow[1] = device.ch1AlarmLow;
        //
        //                ChIsDigital[1] = false;
        //                ChannelsDecimalPlaces[1] = device.ch1_n_decimal ;
        //                ChannelsSensorTypes[1] = device.ch1SensorType;
        //            }
        //            else{
        //                if(device.ch1AlarmHighEnabled)
        //                    AlarmHigh[0] = device.ch1AlarmHigh;
        //                if(device.ch1AlarmLowEnabled)
        //                    AlarmLow[0] = device.ch1AlarmLow;
        //
        //                ChIsDigital[0] = false;
        //                ChannelsDecimalPlaces[0] = device.ch1_n_decimal ;
        //                ChannelsSensorTypes[0] = device.ch1SensorType;
        //            }
        //        }
        //
        //        if(device.ch2Enabled){
        //            if((device.chdEnabled)&&(device.ch1Enabled)) {
        //                if(device.ch2AlarmHighEnabled)
        //                    AlarmHigh[2] = device.ch2AlarmHigh;
        //                if(device.ch2AlarmLowEnabled)
        //                    AlarmLow[2] = device.ch2AlarmLow;
        //
        //                ChIsDigital[2] = false;
        //                ChannelsDecimalPlaces[2] = device.ch2_n_decimal ;
        //                ChannelsSensorTypes[2] = device.ch2SensorType;
        //            }
        //            else if((!device.chdEnabled)&&(!device.ch1Enabled)){
        //                if(device.ch2AlarmHighEnabled)
        //                    AlarmHigh[0] = device.ch2AlarmHigh;
        //                if(device.ch2AlarmLowEnabled)
        //                    AlarmLow[0] = device.ch2AlarmLow;
        //
        //                ChIsDigital[0] = false;
        //                ChannelsDecimalPlaces[0] = device.ch2_n_decimal ;
        //                ChannelsSensorTypes[0] = device.ch2SensorType;
        //            }
        //            else{
        //                if(device.ch2AlarmHighEnabled)
        //                    AlarmHigh[1] = device.ch2AlarmHigh;
        //                if(device.ch2AlarmLowEnabled)
        //                    AlarmLow[1] = device.ch2AlarmLow;
        //
        //                ChIsDigital[1] = false;
        //                ChannelsDecimalPlaces[1] = device.ch2_n_decimal ;
        //                ChannelsSensorTypes[1] = device.ch2SensorType;
        //            }
        //        }
        //
        //        if(device.ch3Enabled){
        //            if((device.ch2Enabled)&&(device.chdEnabled)&&(device.ch1Enabled)) {
        //                if(device.ch3AlarmHighEnabled)
        //                    AlarmHigh[3] = device.ch3AlarmHigh;
        //                if(device.ch3AlarmLowEnabled)
        //                    AlarmLow[3] = device.ch3AlarmLow;
        //
        //                ChIsDigital[3] = false;
        //                ChannelsDecimalPlaces[3] = device.ch3_n_decimal ;
        //                ChannelsSensorTypes[3] = device.ch3SensorType;
        //            }
        //            else if((!device.ch2Enabled)&&(!device.chdEnabled)&&(!device.ch1Enabled)){
        //                if(device.ch3AlarmHighEnabled)
        //                    AlarmHigh[0] = device.ch3AlarmHigh;
        //                if(device.ch2AlarmLowEnabled)
        //                    AlarmLow[0] = device.ch3AlarmLow;
        //
        //                ChIsDigital[0] = false;
        //                ChannelsDecimalPlaces[0] = device.ch3_n_decimal ;
        //                ChannelsSensorTypes[0] = device.ch3SensorType;
        //            }
        //            else if(device.channelsEnabled == 3){
        //                if(device.ch3AlarmHighEnabled)
        //                    AlarmHigh[2] = device.ch3AlarmHigh;
        //                if(device.ch3AlarmLowEnabled)
        //                    AlarmLow[2] = device.ch3AlarmLow;
        //
        //                ChIsDigital[2] = false;
        //                ChannelsDecimalPlaces[2] = device.ch3_n_decimal ;
        //                ChannelsSensorTypes[2] = device.ch3SensorType;
        //            }
        //            else{
        //                if(device.ch3AlarmHighEnabled)
        //                    AlarmHigh[1] = device.ch3AlarmHigh;
        //                if(device.ch3AlarmLowEnabled)
        //                    AlarmLow[1] = device.ch3AlarmLow;
        //
        //                ChIsDigital[1] = false;
        //                ChannelsDecimalPlaces[1] = device.ch3_n_decimal ;
        //                ChannelsSensorTypes[1] = device.ch3SensorType;
        //            }
        //        }
        
        int CanaisHabilitados = 0;
        if(device.chdEnabled && device.chd_inpuType == device.DIGITAL_COUNTER) CanaisHabilitados++;
        if(device.ch1Enabled == true) CanaisHabilitados++;
        if(device.ch2Enabled == true) CanaisHabilitados++;
        if(device.ch3Enabled == true) CanaisHabilitados++;
        
        
        for(int i = 0; i < CanaisHabilitados; i++){ //Todo verificar aqui numero de alarmes
            VerificaPeriodosEmAlarme(i);
        }
        
    }
    
    public void Download(Date init, Date end){
        //Log.v("Registro","Entry Download");
        //extrair variaveis das datas para variaveis locais
        
        device.downloadEnd = false;
        
        downloadState = 1;
        
        // connect(device.address);
        
        Log.v("vai pra thread1", "OK");
        
        Calendar cal = Calendar.getInstance();
        //cal.setTimeZone(TimeZone.getTimeZone("GMT+0"));
        
        cal.setTime(device.getTimewithGMT((-(device.gmt)), init));
        
        device.dayIni = (byte)cal.get(Calendar.DAY_OF_MONTH);
        device.monthIni = (byte)(cal.get(Calendar.MONTH));
        device.yearIni = (byte)(cal.get(Calendar.YEAR) - 2016);
        device.hourIni = (byte)cal.get(Calendar.HOUR_OF_DAY);
        device.minuteIni = (byte)cal.get(Calendar.MINUTE);
        device.secondIni = (byte)cal.get(Calendar.SECOND);
        
        cal.setTime(device.getTimewithGMT((-(device.gmt)), end));
        
        int day = cal.get(Calendar.DAY_OF_MONTH);
        int month = (cal.get(Calendar.MONTH) + 1);
        int year = (cal.get(Calendar.YEAR));
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int second = cal.get(Calendar.SECOND)+10; //RafaelSilva +10 Segundos Ajuste necessário para pegar o último registro dos Logs
        
        String date = String.format("%02d",day) + "/" + String.format("%02d",month) + "/" + String.format("%04d",year) + " " + String.format("%02d",hour) + ":" + String.format("%02d",minute) + ":" + String.format("%02d",second);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
        device.downloadlastDate = null;
        
        try {
            device.downloadlastDate = sdf.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        Log.v("vai pra thread", "OK");
        
        if(download == null){
            //Log.v("Registro","Entry thread null");
            download = null;
            download = new DownloadThread();
        }
            
        else{
            //Log.v("Registro","Entry thread not null");
            download.interrupt();
            download = null;
            download = new DownloadThread();
        }
        
        download.start();
        
        //RafaelSilva parei aqui!!!
    }
    
    public void waitfor(int mili){
        try {
        Thread.sleep(mili);
        } catch (InterruptedException e) {
        e.printStackTrace();
        }
    }
    
    public int downloadState = 1;
    
    public class DownloadThread extends Thread{
        
        boolean killDownloadThread = false;
        
        int samplesReceived = 0;
        int cont = 0;
        int stateFail = 0;
        boolean send = false;
        boolean receive = false;
        
        public void run(){
            //Log.v("Registro","Entry run");
            totalSamplesPacket = 0;
            while(!killDownloadThread) {
                
                //Log.v("Registro", "Entry download");
                //Log.v("Registro",String.format("downloadState = %d", downloadState));
                //Log.v("Registro",String.format("state = %d", state));
                //Log.v("Registro",String.format("mConnectionState = %d", mConnectionState));
                
                //                if(getNumOfLogs()<=3000){ //RafaelSilva
                //                    Log.v("Log Number", String.format("Menos de 3000 registros [%d]", device.logsTotalNumber));
                //                }else{
                //                    Log.v("Log Number", String.format("Mais de 3000 registros [%d]", getNumOfLogs()));
                //                }
                
                if(downloadState == 1){
                    send = false;
                    receive = false;
                    if(state == 2) {
                        downloadState = 4;
                        cont = 0;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                        
                        Log.v("stateConnected", "OK");
                        
                    }else {
                        cont++;
                        Log.v("stateTAG", "!=2");
                        waitfor(400);
                    }
                    
                    if(cont >50){
                        stateFail = 1;
                        downloadState = 15;
                        cont = 0;
                        
                    }
                }
                    
                    //open Download Session
                else if((downloadState == 4)&& (state == 2))
                {
                    if (OpenSession(SESSION_DOWNLOAD)) {
                        cont = 0;
                        downloadState = 5;
                        Log.v("OpenSessionDownload", "Sent");
                    }
                        
                    else {
                        waitfor(100);
                    }
                }
                    
                    //espera receber resposta download session
                else if((downloadState == 5)&& (state == 2))
                {
                    if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_DOWNLOAD && mBluetoothGatt!=null){
                        downloadState = 6;
                        zeraPacket();
                        cont = 0;
                        Log.v("OpenSessionDownload","Received");
                        Log.v("download state 5",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                    }
                    else
                    {
                        waitfor(100);
                        cont++;
                        Log.v("d cont",String.valueOf(cont));
                        Log.v("download state 5",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                    }
                    
                    waitfor(100);
                    
                    if(cont > 25){
                        downloadState = 15;
                        cont = 0;
                    }
                }
                    
                    //download set
                else if((downloadState == 6 )&& (state == 2))
                {
                    if(SelectiveDownload(DOWNLOAD_SET, (byte)0x00, device.yearIni, (byte)(device.monthIni + 1), device.dayIni, device.hourIni, device.minuteIni, device.secondIni)){
                        Log.v("Download Set","Sent");
                        cont = 0;
                        downloadState = 7;
                    }
                        
                    else {
                        waitfor(100);
                    }
                }
                    
                    //espera resposta
                else if(downloadState == 7){// && state == 2){
                    if(packetFinished && packet[5] == SELECTIVE_DOWNLOAD && packet[6] == DOWNLOAD_SET && sessionOpened == SESSION_DOWNLOAD && mBluetoothGatt!=null){
                        downloadState = 8;
                        cont = 0;
                        hasDownloadData = true;
                        Log.v("Download Set","Received");
                    }
                        
                    else if((packet[0] == 0x5A)&&(packet[5] == -26)){
                        Log.v("Download Set", "Received2");
                        downloadState = 11;
                    }
                        
                    else{
                        cont++;
                        Log.v("download state 7",String.valueOf(packet[0]) + " "+String.valueOf(packet[1]) + " "+String.valueOf(packet[2]) + " "+String.valueOf(packet[3]) + " "+String.valueOf(packet[4]) + " "+String.valueOf(packet[5]) + " "+ String.valueOf(packet[6]));
                        waitfor(50);
                    }
                    
                    if (cont > 25) {
                        downloadState = 15;
                        cont = 0;
                    }
                }
                    
                    //parse resp
                else if(downloadState == 8 ){//&& state == 2){
                    Log.v("Download Set","Parsed");
                    cont = 0;
                    parseDownload();
                    waitfor(150);
                    if(device.downloadEnd)
                    downloadState = 12;
                    else
                    downloadState = 9;
                }
                    
                    
                    
                    //por aqui vai ter um for que vai mandar comandos e receber respostas
                    //atraves de um vetor de endereços e um vetor de valores a serem setados
                else if(downloadState == 9 )
                {
                    //laço
                    //se atingiu numero de amostras vai pra close
                    //se nao
                    //faz download next
                    //espera resposta
                    //faz parse
                    //e volta para inicio deste laço
                    
                    
                    while (!device.downloadEnd)
                    {
                        send = false;
                        cont = 0;
                        receive = false;
                        if (downloadState == 9)
                        {
                            receive = false;
                            while(!send) {
                                if (SelectiveDownload(DOWNLOAD_GET_NEXT, (byte) 0x00, (byte) 0xBB, (byte) 0xBB, (byte) 0xBB, (byte) 0xBB, (byte) 0xBB, (byte) 0xBB)) {
                                    Log.v("Download GetNext", "Send");
                                    downloadState = 10;
                                    send = true;
                                }
                                else
                                {
                                    waitfor(50);
                                }
                            }
                        }
                            
                        else if (downloadState == 10)
                        {// && state == 2) {
                            send = false;
                            cont = 0;
                            while(!receive) {
                                if (packetFinished && packet[5] == SELECTIVE_DOWNLOAD && packet[6] == DOWNLOAD_GET_NEXT && sessionOpened == SESSION_DOWNLOAD) {
                                    Log.v("Download GetNext", "Received");
                                    downloadState = 11;
                                    receive = true;
                                }
                                    
                                else if((packet[0] == 90)&&(packet[5] == -26)){
                                    Log.v("Download GetNext", "Received2");
                                    downloadState = 11;
                                    receive = true;
                                }
                                    
                                else {
                                    cont++;
                                    Log.v("Download GetNext", "notReceived");
                                    Log.v("Download GetNext 10 ", String.valueOf(packet[5]));
                                    waitfor(50);
                                }
                                
                                if(cont >50){
                                    stateFail = 1;
                                    downloadState = 15;
                                    cont = 0;
                                }
                                
                            }
                        }
                            
                            //parse
                        else if(downloadState == 11)
                        {// && state == 2) {
                            Log.v("Download GetNext", "Parsed");
                            cont = 0;
                            parseDownload();
                            
                            waitfor(50);
                            
                            if (device.downloadEnd){
                                Log.v("Download END","ok1");
                                initAlarms();
                                downloadState = 12;
                            }
                            else {
                                downloadState = 9;
                            }
                        }
                    }
                    
                }
                    
                else if(downloadState == 11)
                {
                    Log.v("Download GetNext", "Parsed");
                    cont = 0;
                    parseDownload();
                    
                    waitfor(50);
                    
                    if (device.downloadEnd){
                        Log.v("Download END","ok2");
                        
                        downloadState = 12;
                    }
                    else
                    downloadState = 9;
                }
                    
                else if(downloadState == 12 )
                {
                    if(CloseSession()) {
                        Log.v("CloseSession","Sent");
                        downloadState = 13;
                    }
                    else {
                        Log.v("fail close session","false");
                        waitfor(50);
                    }
                }
                    
                else if(downloadState == 13)
                {
                    if(packetFinished && packet[5] == MENAGE_SESSION && sessionOpened == SESSION_NONE){
                        Log.v("CloseSession","Received");
                        
                        downloadState = 14;
                    }else {
                        
                        cont++;
                        waitfor(300);
                    }
                    
                    if (cont > 75)
                    {
                        Log.v("CloseSession0",String.valueOf(packet[0]));
                        Log.v("CloseSession1",String.valueOf(packet[1]));
                        Log.v("CloseSession2",String.valueOf(packet[2]));
                        Log.v("CloseSession3",String.valueOf(packet[3]));
                        Log.v("CloseSession4",String.valueOf(packet[4]));
                        Log.v("CloseSession5",String.valueOf(packet[5]));
                        Log.v("CloseSession6",String.valueOf(packet[6]));
                        Log.v("CloseSession7",String.valueOf(packet[7]));
                        Log.v("CloseSession8",String.valueOf(packet[8]));
                        Log.v("CloseSession9",String.valueOf(packet[9]));
                        Log.v("CloseSession10",String.valueOf(packet[10]));
                        Log.v("CloseSession11",String.valueOf(packet[11]));
                        Log.v("CloseSession12",String.valueOf(packet[12]));
                        
                        downloadState = 15;
                        cont = 0;
                    }
                }
                    
                else if((downloadState == 14)){//&&(state != 2)
                    //Log.v("Registro", "downloadState 14");
                    killDownloadThread = true;
                    break;
                }
                    
                else if(downloadState == 15){
                    //disconnect();
                    killDownloadThread = true;
                    this.interrupt();
                    /*
                     waitfor(100);
                     
                     connect(device.address);
                     
                     downloadState = stateFail;*/
                    break;
                }
                
                if(state == 3){
                    killDownloadThread = true;
                    download = null;
                    this.interrupt();
                    
                }
                if(isInterrupted()){
                    download = null;
                    return;
                }
                
                
            }
            //disconnect();
            try {
                sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            Log.v("killDownloadThread", "true");
            this.interrupt();
            
        }
    }
    
    //Comando especial
    public boolean SelectiveDownload(byte subCode, byte control, byte year, byte month, byte day, byte hour, byte minute, byte second){
        int i = 0;
        
        byte [] data = new byte[19];
        
        //StartFrame
        data[0] = SOF;
        
        //PacketType
        data[1] = (byte) (0xFF);
        
        //PacketId
        data[2] = (byte) (0x00 & 0xFF);
        //this.id++;
        
        //PacketSize High
        data[3] = (byte)0x00;
        
        //PacketSize Low
        data[4] = (byte)0x0C;
        
        i = 5;
        
        data[i] = (byte) (0x66 & 0xFF);
        i++;
        
        data[i] = (byte) (subCode & 0xFF);
        i++;
        
        //3 bytes reservados em 0
        data[i] = (byte) (0x00);
        i++;
        data[i] = (byte) (0x00);
        i++;
        data[i] = (byte) (0x00);
        i++;
        
        //control
        data[i] = (byte) (0x00);
        i++;
        
        data[i] = (byte) (year & 0xFF);
        i++;
        
        data[i] = (byte) (month & 0xFF);
        i++;
        
        data[i] = (byte) (day & 0xFF);
        i++;
        
        data[i] = (byte) (hour & 0xFF);
        i++;
        
        data[i] = (byte) (minute & 0xFF);
        i++;
        
        data[i] = (byte) (second & 0xFF);
        i++;
        
        byte[] b = new byte[data.length - 2];
        
        for (int k = 0; k < b.length; k++) {
            b[k] = data[k];
        }
        
        GetCRC1(b);
        
        data[i] = crcLow;
        i++;
        
        data[i] = crcHigh;
        i++;
        
        return writeCustomCharacteristic(data);
    }
    
    /*if (downloadBlockId == 0){
     device.channels = new Channel[device.channelsEnabled];
     device.downloadPointer = 0;
     for (int i = 0; i < device.channelsEnabled; i++) {
     device.channels[i] = new Channel();
     }
     }
     
     //cria numero de amostras e concatena com as existentes
     for(int i = 0; i <  device.channelsEnabled; i++) {
     for(int j = 0; j < numSamplesPacket; j++){
     Log.v("DP DDP",String.valueOf(device.downloadPointer));
     device.channels[i].samples[device.downloadPointer + j] = new Sample();
     }
     }*/
    
    //    public void mountSamplesToChart(){
    //        if(getNumOfLogs()>=2000) {
    //            deviceToGraph = new Device();
    //
    //            //TODO criar canais (sem o digital)
    //            deviceToGraph.channels = new Channel[device.channelsEnabled];
    //            for (int i = 0; i < device.channelsEnabled; i++) {
    //                deviceToGraph.channels[i] = new Channel();
    //            }
    //
    //            //Fabio  coleta
    //            //TODO criar 2000 amostras pra cada canal
    ////            for(int i = 0; i <  device.channelsEnabled; i++) {
    ////                for (int j = 0; j < 2000; j++) {
    ////                    deviceToGraph.channels[i].samples[j] = new Sample();
    ////                }
    ////            }
    //
    //            int nIndex = 0;
    //            for(int i = 0; i <  device.channelsEnabled; i++) {
    //                for (int j = getNumOfLogs() - 2000; j < getNumOfLogs(); j++) {
    //                    //deviceToGraph.channels[i].samples[nIndex] = device.channels[i].samples[j];
    //                    deviceToGraph.channels[i].samples.add(device.channels[i].samples.get(j));
    //                    nIndex++;
    //                }
    //            }
    //
    //        }
    //    }
    
    
    
    private void broadcastUpdate(final String action) {
        final Intent intent = new Intent(action);
        sendBroadcast(intent);
    }
    
    private void broadcastUpdate(final String action,
    final BluetoothGattCharacteristic characteristic) {
        final Intent intent = new Intent(action);
        
        // This is special handling for the Heart Rate Measurement profile.  Data parsing is
        // carried out as per profile specifications:
        // http://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml
        if (UUID_HEART_RATE_MEASUREMENT.equals(characteristic.getUuid())) {
            int flag = characteristic.getProperties();
            int format = -1;
            if ((flag & 0x01) != 0) {
                format = BluetoothGattCharacteristic.FORMAT_UINT16;
                Log.d(TAG, "Heart rate format UINT16.");
            } else {
                format = BluetoothGattCharacteristic.FORMAT_UINT8;
                Log.d(TAG, "Heart rate format UINT8.");
            }
            final int heartRate = characteristic.getIntValue(format, 1);
            Log.d(TAG, String.format("Received heart rate: %d", heartRate));
            intent.putExtra(EXTRA_DATA, String.valueOf(heartRate));
        } else {
            // For all other profiles, writes the data formatted in HEX.
            final byte[] data = characteristic.getValue();
            if (data != null && data.length > 0) {
                if(NOVUS_CHARACTERISTIC_UUID2.equals(characteristic.getUuid())) {
                    flowControl = data[0];
                    
                    intent.putExtra(EXTRA_DATA, String.valueOf(data[0]) + " FLOW");
                }
                else {
                    final StringBuilder stringBuilder = new StringBuilder(data.length);
                    for (byte byteChar : data)
                    stringBuilder.append(String.format("%02X ", byteChar));
                    intent.putExtra("byteArray", data);
                    if(passwordReceived) {
                        Log.v("PARSEDATA","parseData()");
                        parseData(data);
                    }
                    else{
                        Log.v("ISPASSWORD","isPassword()");
                        isPassword(data);
                    }
                }
            }
        }
        sendBroadcast(intent);
    }
    
    public class LocalBinder extends Binder implements Serializable {
        public BluetoothLeService getService() {
            return BluetoothLeService.this;
        }
    }
    
    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;
    }
    
    @Override
    public boolean onUnbind(Intent intent) {
        // After using a given device, you should make sure that BluetoothGatt.close() is called
        // such that resources are cleaned up properly.  In this particular example, close() is
        // invoked when the UI is disconnected from the Service.
        close();
        return super.onUnbind(intent);
    }
    
    private final IBinder mBinder = new LocalBinder();
    
    /**
     * Initializes a reference to the local Bluetooth adapter.
     *
     * @return Return true if the initialization is successful.
     */
    public boolean initialize() {
        // For API level 18 and above, get a reference to BluetoothAdapter through
        // BluetoothManager.
        if (mBluetoothManager == null) {
            mBluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
            if (mBluetoothManager == null) {
                Log.e(TAG, "Unable to initialize BluetoothManager.");
                return false;
            }
        }
        
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        if (mBluetoothAdapter == null) {
            Log.e(TAG, "Unable to obtain a BluetoothAdapter.");
            return false;
        }
        
        return true;
    }
    
    public void getAddress(String addr){
        String macAddr[] = addr.split(":");
        
        for(int i=0; i<6; i++){
            Integer hex = Integer.parseInt(macAddr[i], 16);
            mAddress[i] = (byte) (hex & 0xFF);
        }
        
    }
    
    public boolean SendRHR(int addr, int size){
        byte b[] = mountCommand((byte)0xFF,ExecuteTransaction(READ_HOLDING_REGISTERS, (short)addr, (short)size, (byte)0x00));
        return writeCustomCharacteristic(b);
    }
    
    
    
    /**
     * Connects to the GATT server hosted on the Bluetooth LE device.
     *
     * @param address The device address of the destination device.
     *
     * @return Return true if the connection is initiated successfully. The connection result
     *         is reported asynchronously through the
     *         {@code BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)}
     *         callback.
     */
    public boolean connect(final String address)  {
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        if (mBluetoothAdapter == null || address == null) {
            Log.w(TAG, "BluetoothAdapter not initialized or unspecified address.");
            return false;
        }
        
        // Previously connected device.  Try to reconnect.
        if (mBluetoothDeviceAddress != null && address.equals(mBluetoothDeviceAddress)
            && mBluetoothGatt != null) {
            // getAddress(mBluetoothDeviceAddress);
            Log.d(TAG, "Trying to use an existing mBluetoothGatt for connection.");
            if (mBluetoothGatt.connect()) {
                mConnectionState = STATE_CONNECTING;
                return true;
            } else {
                return false;
            }
        }
        
        final BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
        if (device == null) {
            Log.w(TAG, "Device not found.  Unable to connect.");
            return false;
        }
        // We want to directly connect to the device, so we are setting the autoConnect
        // parameter to false.
        mBluetoothGatt = device.connectGatt(this, false, mGattCallback);
        //try{
        //    Thread.sleep(2000);
        //}catch(Exception e){}
        
        Log.d(TAG, "Trying to create a new connection.");
        mBluetoothDeviceAddress = address;
        passwordSent = false;
        passwordReceived = false;
        mConnectionState = STATE_CONNECTING;
        //state = 0;
        //if(pwThread == null) {
        //    pwThread = new SendPassword();
        //}
        //pwThread.start();
        
        return true;
    }
    
    public void SendPassword(){
        Log.v("SendPassword","SendPassword");
        
        if(pwThread == null) {
            pwThread = new SendPassword();
        }
        else{
            pwThread.interrupt();
            pwThread = null;
            pwThread = new SendPassword();
        }
        state = 0;
        pwThread.start();
    }
    
    
    
    /**
     * Disconnects an existing connection or cancel a pending connection. The disconnection result
     * is reported asynchronously through the
     * {@code BluetoothGattCallback#onConnectionStateChange(android.bluetooth.BluetoothGatt, int, int)}
     * callback.
     */
    public void killThreads(){
        
        if(pwThread != null) {
            pwThread.interrupt();
            pwThread = null;
        }
        
        if(download != null) {
            download.interrupt();
            download = null;
        }
        
        if(apThread != null){
            apThread.interrupt();
            apThread = null;
        }
        
        if(ssThread != null){ //Rafael Silva
            ssThread.interrupt();
            ssThread = null;
        }
        
        if(Rrt != null){
            Rrt.interrupt();
            Rrt = null;
        }
        
    }
    
    public void disconnect() {
        Log.v("BLE","disconnect()");
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        
        passwordReceived = false;
        
        
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized");
            return;
        }
        
        //doConnect = false;
        state = 0;
        mBluetoothGatt.disconnect();
    }
    
    /**
     * After using a given BLE device, the app must call this method to ensure resources are
     * released properly.
     */
    public void close() {
        if (mBluetoothGatt == null) {
            return;
        }
        mBluetoothGatt.close();
        mBluetoothGatt = null;
    }
    
    public void RRForDownload(){
        stateRRForDownload = 0;
        if(rrForDownload == null)
        rrForDownload = new RRForDownload();
        
        else{
            rrForDownload.interrupt();
            rrForDownload = null;
            rrForDownload = new RRForDownload();
        }
        rrForDownload.start();
    }
    
    public RRForDownload rrForDownload;
    public class RRForDownload extends Thread{
        boolean kill = false;
        int cont = 0;
        boolean success = true;
        public void run() {
            while (!kill) {
                if((state == 2)&&(stateRRForDownload == 0)){
                    if(SendRHR(0,100)){
                        stateRRForDownload = 1;
                    }
                    else {
                        try {
                        Thread.sleep(200);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateRRForDownload == 1){
                    if(packetFinished && packet[5]==3) {
                        stateRRForDownload = 2;
                        cont = 0;
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        cont++;
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateRRForDownload = 3;
                        cont = 0;
                        success = false;
                    }
                }
                else if(stateRRForDownload == 2){
                    cont = 0;
                    if(ParseRHRDataStatus1()) {
                        stateRRForDownload = 3;
                    }
                    else
                    {
                        stateRRForDownload = 4; //4 deu ruim, deve ser tratado para mostrar ao usuario como falha
                        success = false;
                    }
                }
                else if((stateRRForDownload == 3)||(stateRRForDownload == 4)){
                    
                    kill = true;
                    break;
                    
                }
            }
            
            //interrupt();
        }
    }
    
    public void ReadRegisters(){
        Log.v("BluetoothLeService","ReadRegisters()");
        
        if(state == 0)
        connect(mBluetoothDeviceAddress);
        
        if(Rrt == null)
        Rrt = new ReadRegistersThread();
        Rrt.start();
    }
    
    
    public ReadRegistersThread Rrt;
    class ReadRegistersThread extends Thread {
        boolean kill = false;
        int cont = 0;
        int stateFail = 0;
        
        public void run() {
            while (!kill) {
                
                if((stateReadRegisters == 1)&&(state == 2)){
                    if(SendRHR(0,100)){
                        Log.v(TAG2,"Send RHR1");
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateReadRegisters = 2;
                    }
                    else {
                        try {
                        Thread.sleep(200);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if((stateReadRegisters == 2)&&(state == 2)){
                    Log.v(TAG2,"Wait RHR response1");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 3;
                        cont = 0;
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        cont++;
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 20) {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateFail = 1;
                        stateReadRegisters = 20;
                        cont = 0;
                    }
                }
                else if((stateReadRegisters == 3)&&(state == 2)){
                    cont = 0;
                    Log.v(TAG2,"Parse RHRData1");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    ParseRHRDataStatus1();
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    stateReadRegisters = 4;
                }
                else if (stateReadRegisters == 4){
                    Log.v("RHR response1"," OK");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    if(SendRHR(100,17)){//54
                        Log.v(TAG2,"Send RHR2");
                        stateReadRegisters = 5;
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateReadRegisters == 5){
                    Log.v(TAG2,"Wahttp://www.reisman.com.br/it RHR response2");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 6;
                    }
                        
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        cont++;
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    
                    if(cont > 20) {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateFail = 4;
                        stateReadRegisters = 20;
                        cont = 0;
                    }
                }
                    
                else if(stateReadRegisters == 6){
                    cont = 0;
                    ParseRHRDataStatus2();
                    Log.v(TAG2,"Parse RHRData2");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    stateReadRegisters = 7;
                }
                    
                else if (stateReadRegisters == 7){
                    Log.v("RHR response2"," OK");
                    if(SendRHR(1000,100)){
                        cont = 0;
                        Log.v(TAG2,"Send RHR3");
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateReadRegisters = 8;
                        
                    }
                    else {
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateReadRegisters == 8){
                    Log.v(TAG2,"Wait RHR response3");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 9;
                        
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        cont ++;
                        try {
                            Thread.sleep(100);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    
                    if(cont > 25) {
                        stateFail = 7;
                        stateReadRegisters = 20;
                        cont = 0;
                    }
                }
                    
                else if(stateReadRegisters == 9){
                    cont = 0;
                    ParseRHRDataConfig1();
                    Log.v(TAG2,"Parse RHRData3");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    stateReadRegisters = 10;
                    
                }
                else if (stateReadRegisters == 10){
                    Log.v("RHR response3"," OK");
                    if(SendRHR(1100,100)){
                        Log.v(TAG2,"Send RHR4");
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateReadRegisters = 11;
                        cont = 0;
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateReadRegisters == 11){
                    Log.v(TAG2,"Wait RHR response4");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 12;
                        
                    }
                    else {
                        Log.v(TAG2,"state " + String.valueOf(state));
                        cont++;
                        try {
                        Thread.sleep(100);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont > 25) {
                        Log.v(TAG2,"FAIL " + String.valueOf(packetFinished));
                        Log.v(TAG2,"FAIL " + String.valueOf(packet[5]));
                        Log.v(TAG2,"state " + String.valueOf(state));
                        stateFail = 10;
                        stateReadRegisters = 20;
                        cont = 0;
                    }
                }
                    
                else if(stateReadRegisters == 12) {
                    ParseRHRDataConfig2();
                    Log.v(TAG2, "Parse RHRData4");
                    Log.v(TAG2,"state " + String.valueOf(state));
                    cont = 0;
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    stateReadRegisters = 13;
                }
                    
                else if (stateReadRegisters == 13){
                    Log.v("RHR response4"," OK");
                    if(SendRHR(1200,72)){  //52
                        Log.v(TAG2,"Send RHR5");
                        stateReadRegisters = 14;
                    }
                    else {
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateReadRegisters == 14){
                    Log.v(TAG2,"Wait RHR response5");
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 15;
                        cont = 0;
                    }
                    else {
                        cont++;
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont > 20) {
                        stateFail = 13;
                        stateReadRegisters = 20; // era 16
                        cont = 0;
                    }
                }
                    
                else if(stateReadRegisters == 15) {
                    ParseRHRDataConfig3();
                    Log.v(TAG2, "Parse RHRData4");
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    
                    
                    cont = 0;
                    
                    stateReadRegisters = 16;
                    //kill = true; //verificar depois
                    //break;
                }
                    
                    
                    
                    //Maked Douglas
                    
                else if (stateReadRegisters == 16){
                    Log.v("RHR response4"," OK");
                    if(SendRHR(3006,4)){  //52
                        Log.v(TAG2,"Send PASSWORD");
                        stateReadRegisters = 17;
                    }
                    else {
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                }
                    
                else if(stateReadRegisters == 17){
                    Log.v(TAG2,"Wait PASSWORD");
                    if(packetFinished && packet[5]==3) {
                        stateReadRegisters = 18;
                        
                        // ultimo nao coloca cont = 0;
                    }
                    else {
                        cont++;
                        try {
                        Thread.sleep(60);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont > 20) {
                        stateFail = 16;
                        stateReadRegisters = 20;
                        cont = 0;
                    }
                }
                    
                else if(stateReadRegisters == 18) {
                    ParsePassword();
                    Log.v(TAG2, "Parse PASSWORD");
                    //try {
                    //    Thread.sleep(60);
                    //} catch (InterruptedException e) {
                    //    e.printStackTrace();
                    //}
                    cont = 0;
                    stateReadRegisters = 19;
                    //kill = true; //verificar depois
                    //break;
                }
                    
                else if(stateReadRegisters == 19){ //SUCESSO
                    //TODO disconnect
                    //disconnect();
                    //                    /Log.v("BLE", "BLE disconnect()1");
                    
                    //TODO esperar estar desconectado
                    //                  try {
                    //                    Thread.sleep(600);
                    //              } catch (InterruptedException e) {
                    //                e.printStackTrace();
                    //          }
                    
                    //connect(mBluetoothDeviceAddress);
                    
                    //stateReadRegisters = stateFail;
                    kill = true; //verificar depois
                    break;
                    
                }
                    
                else if(stateReadRegisters == 20){ // FALHA
                    //TODO disconnect
                    //Log.v("BLE", "BLE disconnect()2");
                    //disconnect();
                    
                    //TODO esperar estar desconectado
                    //try {
                    //  Thread.sleep(600);
                    //} catch (InterruptedException e) {
                    //                        e.printStackTrace();
                    //                  }
                    
                    //connect(mBluetoothDeviceAddress);
                    
                    //stateReadRegisters = stateFail;
                    kill = true; //verificar depois
                    break;
                    
                }
            }
            this.interrupt();
        }
    }
    
    public boolean SendLowAdvertise(){
        byte b[] = mountCommand((byte)0x00,ExecuteTransaction(READ_HOLDING_REGISTERS, (short)1053, (short)1, (byte)0x00));
        return writeCustomCharacteristic(b);
    }
    
    public boolean SendKeepAlive(){
        byte b[] = mountCommand((byte)0xFF,ExecuteTransaction(READ_HOLDING_REGISTERS, (short)1053, (short)1, (byte)0x00));
        return writeCustomCharacteristic(b);
    }
    
    public class KeepAlive extends Thread{
        
        boolean kill = false;
        public void run(){
            while (!kill) {
                if ((state == 2) && (stateKeepAlive == 0)) {
                    //manda keepAlive
                    if(SendKeepAlive())
                    stateKeepAlive = 1;
                }
                if(stateKeepAlive == 1){
                    kill = true; //verificar depois
                    break;
                }
            }
            this.interrupt();
        }
    }
    
    public class SendPassword extends Thread {
        
        public int cont = 0;
        public int cont1 = 0;
        boolean kill = false;
        public void run(){
            while(!kill) {
                //if services ja disponiveis
                Log.v("state", String.valueOf(state));
                Log.v("statePassword", String.valueOf(passwordSent));
                if(state == 0) {
                    if (!passwordSent) {
                        if (writePassword()) {
                            cont1 = 0;
                            passwordSent = true;
                            Log.v("Password","Send");
                            state = 1;
                        }
                            //esperar ok
                        else {
                            cont1++;
                            try {
                            Thread.sleep(100);
                            } catch (InterruptedException e) {
                            e.printStackTrace();
                            }
                        }
                        if(cont1 > 25){
                            state = 3;
                            kill = true;
                            break;
                        }
                    }
                    else {
                        cont1++;
                        try {
                        Thread.sleep(200);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    if(cont1 > 25){
                        passwordSent = false;
                        state = 0;
                    }
                }
                else if(state == 1){
                    if(passwordReceived) {
                        cont = 0;
                        Log.v("Password","Received");
                        state = 2;
                    }
                    else {
                        cont++;
                        try {
                        Thread.sleep(200);
                        } catch (InterruptedException e) {
                        e.printStackTrace();
                        }
                    }
                    
                    if(cont > 50){
                        Log.v("state", "33");
                        state = 3;
                        kill = true;
                        break;
                    }
                    
                    if(cont > 30) {
                        passwordSent = false;
                        state = 2;
                    }
                }
                else if(state == 2){
                    stateReadRegisters = 1;
                    
                    kill = true; //verificar depois
                    break;
                }
            }
            this.interrupt();
        }
    }
    
    
    
    /**
     * Enables or disables notification on a give characteristic.
     *
     * @param characteristic Characteristic to act on.
     * @param enabled If true, enable notification.  False otherwise.
     */
    public void setCharacteristicNotification(BluetoothGattCharacteristic characteristic,
    boolean enabled) {
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized");
            return;
        }
        mBluetoothGatt.setCharacteristicNotification(characteristic, enabled);
        
        // This is specific to Heart Rate Measurement.
        if (UUID_HEART_RATE_MEASUREMENT.equals(characteristic.getUuid())) {
            BluetoothGattDescriptor descriptor = characteristic.getDescriptor(
                UUID.fromString(SampleGattAttributes.CLIENT_CHARACTERISTIC_CONFIG));
            descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
            mBluetoothGatt.writeDescriptor(descriptor);
        }
    }
    
    
  
    public byte[] vDevH_Ble_Calc_PasswordBle(byte[] pucMacBle)
{
    
    byte ucHardCode[]={(byte)0X5A,(byte)0XB1,(byte)0XFA,(byte)0XBB,(byte)0XC0,(byte)0X3D,(byte)0XFE,(byte)0X34,(byte)0X45,(byte)0XCD,(byte)0X00,(byte)0X54,(byte)0X25,(byte)0X62,(byte)0X36,(byte)0X22};
    //        int uiIndex=0;
    //        byte ucChecksum=0;
    //        for( uiIndex = 0; uiIndex < 6; uiIndex++ )
    //        {
    //            ucChecksum=(byte)(ucChecksum+pucMacBle[uiIndex]);
    //        }
    //
    //        ucChecksum = (byte)(ucChecksum & 0xFF);
    //
    //        for( uiIndex = 0; uiIndex < 16; uiIndex++ )
    //        {
    //            pucPassword[uiIndex]= (byte) (ucHardCode[uiIndex]^ucChecksum);
    //        }
    
    return ucHardCode;
    }
    
    public boolean writePassword(){
        byte b[] = vDevH_Ble_Calc_PasswordBle(mAddress);
        return writeCustomCharacteristic(b);
    }
    
    public boolean writeCustomCharacteristic(byte[] s) {
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized");
            //if(mBluetoothDeviceAddress != null)
            //    connect(mBluetoothDeviceAddress);
            Log.v("Fail","Fail1");
            return false;
        }
        /*check if the service is available on the device*/
        //BluetoothGattService mCustomService = mBluetoothGatt.getService(UUID.fromString("00001110-0000-1000-8000-00805f9b34fb"));
        BluetoothGattService mCustomService = mBluetoothGatt.getService(UUID.fromString("0783b03e-8535-b5a0-7140-a304d2495cb7"));
        
        if(mCustomService == null){
            Log.w(TAG, "Custom BLE Service not found2");
            Log.v("Fail","Fail2");
            return false;
        }
        
        
        
        /*get the read characteristic from the service*/
        BluetoothGattCharacteristic mWriteCharacteristic = mCustomService.getCharacteristic(UUID.fromString("0783b03e-8535-b5a0-7140-a304d2495cba"));
        
        if(mWriteCharacteristic == null || s == null) {
            Log.v("Fail","Fail3");
            return false;
        }
        
        boolean b = mWriteCharacteristic.setValue(s);
        //(value, android.bluetooth.BluetoothGattCharacteristic.FORMAT_UINT8, 0);
        if(mBluetoothGatt.writeCharacteristic(mWriteCharacteristic) == false){
            Log.w(TAG, "Failed to write characteristic1");
            Log.v("Fail","Fail4");
            return false;
        }
        
        Log.w(TAG, "Success to write characteristic1");
        return true;
    }
    
   
    public void sendPassword(byte[] b){
        BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
        if (mBluetoothAdapter == null || mBluetoothGatt == null) {
            Log.w(TAG, "BluetoothAdapter not initialized");
            return;
        }
        /*check if the service is available on the device*/
        //BluetoothGattService mCustomService = mBluetoothGatt.getService(UUID.fromString("00001110-0000-1000-8000-00805f9b34fb"));
        BluetoothGattService mCustomService =  mBluetoothGatt.getService(UUID.fromString("0783b03e-8535-b5a0-7140-a304d2495cb7"));
        if(mCustomService == null){
            Log.w(TAG, "Custom BLE Service not found4");
            return;
        }
        /*get the read characteristic from the service*/
        BluetoothGattCharacteristic mWriteCharacteristic = mCustomService.getCharacteristic(UUID.fromString("0783b03e-8535-b5a0-7140-a304d2495cba"));
        setCharacteristicNotification(mWriteCharacteristic,true);
        mWriteCharacteristic.setValue(b);
        
        //(value, android.bluetooth.BluetoothGattCharacteristic.FORMAT_UINT8, 0);
        if(mBluetoothGatt.writeCharacteristic(mWriteCharacteristic) == false){
            Log.w(TAG, "Failed to write characteristic3");
        }
    }
    
    
  
    public long pow10(int p){
        return (long)Math.pow(10,p);
    }
    
}
