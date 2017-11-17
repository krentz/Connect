//
//  File.swift
//  Connect
//
//  Created by Rafael Goncalves on 16/11/2017.
//  Copyright © 2017 Rafael Goncalves. All rights reserved.
//

import Foundation

class Device{
    
    static let shared = Device()
    
   
    
    var address : String?
    
    static var DIGITAL_COUNTER : Int = 1
    static var DIGITAL_EVENT_LOG : Int = 2
    static var DIGITAL_LOG_CONTROL : Int = 3
    static var DAYS_DIFERENCE : Int = 25569
    static var MILLIS_PER_DAY : Int = 86400000
    
    var smartphoneTimeZone : String = "UTC"
    
    var BLE_HR_SS_SERIAL_NUMBER_HIGH : Int? //0
    var BLE_HR_SS_SERIAL_NUMBER_LOW : Int?
    var HR_SS_PRODUCT_CODE : Int?
    var BLE_HR_SS_FIRMWARE_VERSION : Int?
    var CR_PS_RESERVED_1 : Int? //4
    var HR_SS_MAC_ADDR_15_4_0_1_WiFi : Int?
    var HR_SS_MAC_ADDR_15_4_2_3_WiFi : Int?
    var HR_SS_MAC_ADDR_15_4_4_5_WiFi : Int?
    var HR_SS_MAC_ADDR_15_4_6_7 : Int?
    var CR_PS_RESERVED_2 : Int? //9
    var BLE_HR_SS_MAC_ADDR_BLE_0_1 : Int?
    var BLE_HR_SS_MAC_ADDR_BLE_2_3 : Int?
    var BLE_HR_SS_MAC_ADDR_BLE_4_5 : Int?
    var BLE_HR_SS_RESERVED_3 : Int?
    var BLE_HR_SS_RESERVED_4 : Int?
    var BLE_HR_SS_POWER_SUPPLY : Int?
    var BLE_HR_SS_RESERVED_5 : Int?
    var BLE_HR_SS_BLE_STATUS : Int? //17
    var BLE_HR_SS_BLE_LQI_RX : Int?
    var BLE_HR_SS_BLE_RESERVED_1 : Int?
    var BLE_HR_SS_BLE_RESERVED_2 : Int?
    var BLE_HR_SS_USB_STATUS : Int?
    var BLE_HR_SS_USB_RESERVED_1 : Int?
    var BLE_HR_SS_USB_RESERVED_2 : Int? //23
    var BLE_HR_SS_15_4_STATUS_RESERVED : Int?
    var BLE_HR_SS_15_4_SHORT_MAC_RESERVED : Int?
    var BLE_HR_SS_15_4_CHANNEL_RESERVED : Int?
    var BLE_HR_SS_15_4_LQI_RX_RESERVED : Int?
    var BLE_HR_SS_15_4_RESERVED_1 : Int?
    var BLE_HR_SS_15_4_RESERVED_2 : Int?
    var BLE_HR_SS_RESERVED_6 : Int?
    var BLE_HR_SS_RESERVED_7 : Int?
    var BLE_HR_SS_NUMBER_OF_ACTIVE_CHANNELS : Int? //32
    var BLE_HR_SS_RESERVED_8 : Int?
    var HR_SS_RECORDS_STARTED_INTERFACE : Int? //BLE_HR_SS_RESERVED_9 ;
    var HR_SS_RECORDS_STOPPED_INTERFACE : Int? //BLE_HR_SS_RESERVED_10 ;
    var BLE_HR_SS_STATUS_OF_RECORDS : Int?
    var BLE_HR_SS_NUMBER_OF_RECORDS_H : Int?
    var BLE_HR_SS_NUMBER_OF_RECORDS_L : Int?
    var BLE_HR_SS_NUMBER_OF_FREE_RECORDS_H : Int?
    var BLE_HR_SS_NUMBER_OF_FREE_RECORDS_L : Int?
    var BLE_HR_SS_RESERVED_11 : Int?
    var BLE_HR_SS_RESERVED_12 : Int?
    var BLE_HR_SS_FIRST_YEAR : Int? //43
    var BLE_HR_SS_FIRST_MONTH : Int?
    var BLE_HR_SS_FIRST_DAY : Int?
    var BLE_HR_SS_FIRST_HOUR : Int?
    var BLE_HR_SS_FIRST_MINUTE : Int?
    var BLE_HR_SS_FIRST_SECOND : Int?
    var BLE_HR_SS_RESERVED_13 : Int?
    var BLE_HR_SS_RESERVED_14 : Int?
    var BLE_HR_SS_CURRENT_YEAR : Int?
    var BLE_HR_SS_CURRENT_MONTH : Int?
    var BLE_HR_SS_CURRENT_DAY : Int?
    var BLE_HR_SS_CURRENT_HOUR : Int?
    var BLE_HR_SS_CURRENT_MINUTE : Int?
    var BLE_HR_SS_CURRENT_SECOND : Int?
    var BLE_HR_SS_HAS_RESET_OCURRED : Int?
    var BLE_HR_SS_RESERVED_17 : Int?
    var BLE_HR_SS_AM_I_IN_BOOTLOADER_MODE : Int? //60
    var BLE_HR_SS_CHD_LAST_EVENT_YEAR : Int?
    var BLE_HR_SS_CHD_LAST_EVENT_MONTH : Int?
    var BLE_HR_SS_CHD_LAST_EVENT_DAY : Int?
    var BLE_HR_SS_CHD_LAST_EVENT_HOUR : Int?
    var BLE_HR_SS_CHD_LAST_EVENT_SECOND : Int?
    var BLE_HR_SS_ALARM_STATUS : Int?
    var BLE_HR_SS_RESERVED_25 : Int?
    var BLE_HR_SS_RESERVED_26 : Int?
    var BLE_HR_SS_DIGITAL_OUT_VALUE : Int?
    var BLE_HR_SS_RESERVED_27 : Int?
    
    //Canal Digital
    var HR_SS_CHD_ALARM_STATUS : Int? //72
    var BLE_HR_SS_CHD_STATUS : Int?
    var BLE_HR_SS_CHD_VALUE : Int?
    var BLE_HR_SS_CHD_VALUE_USER_UNIT_float_High : Int?
    var BLE_HR_SS_CHD_VALUE_USER_UNIT_float_Low : Int?
    var chd_valueUserFloatStatus : Float?
    var BLE_HR_SS_CHD_VALUE_MIN : Int?
    var BLE_HR_SS_CHD_VALUE_MAX : Int?
    var BLE_HR_SS_CHD_ALARM_MIN_STATUS : Int?
    var BLE_HR_SS_CHD_ALARM_MAX_STATUS : Int?
    
    //Canal Analógico 1
    var BLE_HR_SS_CH1_STATUS : Int? // 81
    var BLE_HR_SS_CH1_VALUE : Int?
    var BLE_HR_SS_CH1_VALUE_MIN : Int?
    var BLE_HR_SS_CH1_VALUE_MAX : Int?
    var BLE_HR_SS_CH1_ALARM_MIN_STATUS : Int?
    var BLE_HR_SS_CH1_ALARM_MAX_STATUS : Int?
    var HR_SS_CH1_ALARM_STATUS : Int?
    var BLE_HR_SS_RESERVED_32 : Int?
    
    //Canal Analógico 2
    var BLE_HR_SS_CH2_STATUS : Int? //89
    var BLE_HR_SS_CH2_VALUE : Int?
    var BLE_HR_SS_CH2_VALUE_MIN : Int?
    var BLE_HR_SS_CH2_VALUE_MAX : Int?
    var BLE_HR_SS_CH2_ALARM_MIN_STATUS : Int?
    var BLE_HR_SS_CH2_ALARM_MAX_STATUS : Int?
    var HR_SS_CH2_ALARM_STATUS : Int?
    var BLE_HR_SS_RESERVED_34 : Int?
    
    //Canal Analógico 3
    var BLE_HR_SS_CH3_STATUS : Int?
    var BLE_HR_SS_CH3_VALUE : Int?
    var BLE_HR_SS_CH3_VALUE_MIN : Int?
    var BLE_HR_SS_CH3_VALUE_MAX : Int?
    var BLE_HR_SS_CH3_ALARM_MIN_STATUS : Int?
    var BLE_HR_SS_CH3_ALARM_MAX_STATUS : Int?
    var HR_SS_CH3_ALARM_STATUS : Int?
    var BLE_HR_SS_RESERVED_36 : Int?
    var BLE_HR_SS_RESERVED_37 : Int?
    var BLE_HR_SS_BATTERY_VOLTAGE_VALUE : Int? //106
    var BLE_HR_SS_BATTERY_VOLTAGE_VALUE_MIN : Int?
    var BLE_HR_SS_BATTERY_VOLTAGE_VALUE_MAX : Int?
    var BLE_HR_SS_BATTERY_PERCENTAGE_OF_LIFE : Int?
    var BLE_HR_SS_RESERVED_38 : Int?
    var BLE_HR_SS_RESERVED_39 : Int?
    var BLE_HR_SS_RESERVED_40 : Int?
    var BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE : Int?
    var BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE_MIN : Int?
    var BLE_HR_SS_EXTERNAL_VOLTAGE_VALUE_MAX : Int?
    var HR_SS_RESERVED_52 : Int?
    var HR_SS_RESERVED_53 : Int?
    var HR_SS_RESERVED_54 : Int?
    var HR_SS_RESERVED_55 : Int?
    var HR_SS_RESERVED_56 : Int?
    
    
    var dayIni : UInt8?
    var monthIni : UInt8?
    var yearIni : UInt8?
    var hourIni : UInt8?
    var minuteIni : UInt8?
    var secondIni : UInt8?
   
    var aqt : Int = 0
    var samplesNumber : Int = 0
    var channelsEnabled : Int?
    
    //**********************************
    //var DirectoryName : String = Environment.getExternalStorageDirectory() + "/LogChart-BLE/"
    
    
    //Registradores de Configuração
    var HR_CS_SETTING_RESTORE_DEFAULT : Int? //1000
    var interval : Int? //HR_CS_SETTING_ACQUISITION_INTERVAL_LOG_S : Int? //HR_CS_SETTING_DIGITAL_OUT_S : Int?
    var HR_CS_ENABLE_REGISTER_LOG : Int?
    var HR_CS_RESERVED_1 : Int? //1003
    var HR_CS_SETTING_ACQUISITION_INTERVAL_SCAN_S : Int?
    var startMode : Int? //HR_CS_SETTING_START_MODE
    var stopMode : Int? //HR_CS_SETTING_STOP_MODE
    var HR_CS_SETTING_ERASE_LOG_MEMORY : Int? //1007
    var HR_CS_SETTING_CONFIGURATION_ONGOING : Int?
    var HR_CS_SETTING_YEAR_START_RECORD : Int?
    var HR_CS_SETTING_MONTH_START_RECORD : Int?
    var HR_CS_SETTING_DAY_START_RECORD : Int?
    var HR_CS_SETTING_HOUR_START_RECORD : Int?
    var HR_CS_SETTING_MINUTE_START_RECORD : Int?
    var HR_CS_SETTING_SECOND_START_RECORD : Int?
    var HR_CS_RESERVED_5 : Int?  //1015
    var HR_CS_SETTING_YEAR_STOP_RECORD : Int?
    var HR_CS_SETTING_MONTH_STOP_RECORD : Int?
    var HR_CS_SETTING_DAY_STOP_RECORD : Int?
    var HR_CS_SETTING_HOUR_STOP_RECORD : Int?
    var HR_CS_SETTING_MINUTE_STOP_RECORD : Int?
    var HR_CS_SETTING_SECOND_STOP_RECORD : Int?
    var HR_CS_RESERVED_6 : Int?
    var display_active : Int? //HR_CS_DISPLAY_ENABLE_MODE : Int?
    var HR_CS_DISPLAY_CONTRAST : Int?
    var HR_CS_RESERVED_9 : Int? //1025
    var HR_CS_BOOTLOADER_CONTROL : Int?
    var HR_CS_ALARM_BUZZER_DURATION_S : Int?
    var HR_CS_SETTING_DIGITAL_OUT_MODE : Int?
    var HR_CS_SETTING_DIGITAL_OUT_DURATION_S : Int?
    var HR_CS_MODBUS_ADDRESS : Int?
    var HR_CS_RESERVED_14 : Int? //1031
    var HR_CS_SETTING_TITLE_1 : Int?
    var HR_CS_SETTING_TITLE_2 : Int?
    var HR_CS_SETTING_TITLE_3 : Int?
    var HR_CS_SETTING_TITLE_4 : Int?
    var HR_CS_SETTING_TITLE_5 : Int?
    var HR_CS_SETTING_TITLE_6 : Int?
    var HR_CS_SETTING_TITLE_7 : Int?
    var HR_CS_SETTING_TITLE_8 : Int?
    var HR_CS_SETTING_TITLE_9 : Int?
    var HR_CS_SETTING_TITLE_10 : Int?
    var HR_CS_SETTING_PM : Int?
    var gmt : Int = 0 //HR_CS_SETTING_GMT
    var HR_CS_SETTING_YEAR : Int?  //1044
    var HR_CS_SETTING_MONTH : Int?
    var HR_CS_SETTING_DAY : Int?
    var HR_CS_SETTING_HOUR : Int?
    var HR_CS_SETTING_MINUTE : Int?
    var HR_CS_SETTING_SECOND : Int?
    var HR_CS_RESERVED_16 : Int?
    var HR_CS_BLE_ENABLED : Int?
    var wakeup_mode : Int?//HR_CS_BLE_ADVERTISE_MODE
    var periodicity : Int?//HR_CS_BLE_ADVERTISE_TIME_ms
    var BLE_HR_CS_BLE_DEVICE_NAME_1 : Int?
    var BLE_HR_CS_BLE_DEVICE_NAME_2 : Int?
    var BLE_HR_CS_BLE_DEVICE_NAME_3 : Int?
    var BLE_HR_CS_BLE_DEVICE_NAME_4 : Int?
    var HR_CS_RESERVED_17 : Int?  //1058
    var HR_CS_BLE_RESERVED_1 : Int?
    var HR_CS_BLE_RESERVED_2 : Int?
    var HR_CS_BLE_RESERVED_3 : Int?
    var HR_CS_BLE_FAST_ADVERTISE_DURATION_S : Int?
    var HR_CS_RESERVED_18 : Int?
    var HR_CS_RESERVED_19 : Int?
    var HR_CS_VBAT_VEXT_MIN_MAX_CLEAR_STATUS : Int?
    var HR_CS_RESERVED_21 : Int?
    var HR_CS_15_4_ENABLED_RESERVED : Int? //1067  //BLOCO 1 DE ESCRITA ACABA AQUI
    var HR_CS_15_4_ADVERTISE_MODE_RESERVED : Int?
    var HR_CS_15_4_ADVERTISE_TIME_RESERVED : Int?
    var HR_CS_RESERVED_15_4_1 : Int?
    var HR_CS_RESERVED_15_4_2 : Int?
    var HR_CS_15_4_PAN_ID_RESERVED : Int?
    var HR_CS_15_4_POWER_LEVEL_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_ENABLED_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_0_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_1_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_2_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_3_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_4_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_5_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_6_RESERVED : Int?
    var HR_CS_15_4_ENCRYPTION_KEY_7_RESERVED : Int?
    var HR_CS_CHD_DECIMAL_POINT : Int?
    var HR_CS_CHD_ALARM_MIN_HYSTERESIS : Int?
    var HR_CS_CHD_ALARM_MAX_HYSTERESIS : Int?
    var HR_CS_CHD_ALARM_MIN_MAX_CLEAR_STATUS : Int?
    var BLE_HR_CS_CHD_ENABLE : Int? //1087
    
    var chd_inpuType : Int?
    var HR_CS_CHD_COUNTING_MODE : Int = 0
    var chd_sensorType : Int?
    var HR_CS_CHD_SENSOR_TYPE : Int = 0
    var chd_countEdge : Int?
    var HR_CS_CHD_COUNTING_EDGE : Int = 0
    var HR_CS_CHD_DEBOUNCE_TIME_ms : Int?
    var HR_CS_CHD_SENSOR_FACTOR_float_High : Int?
    var HR_CS_CHD_SENSOR_FACTOR_float_Low : Int? //1093
    var HR_CS_CHD_SENSOR_UNIT : Int = 0
    var HR_CS_CHD_USER_SCALE_FACTOR_float_High : Int?
    var HR_CS_CHD_USER_SCALE_FACTOR_float_Low : Int?
    var chd_unit : Int?
    var HR_CS_CHD_USER_UNIT : Int = 0  //1097
    var BLE_HR_CS_CHD_ENABLE_ALARM_MIN : Int?
    var BLE_HR_CS_CHD_ENABLE_ALARM_MAX : Int?
    var BLE_HR_CS_CHD_ALARM_MIN : Int?
    var BLE_HR_CS_CHD_ALARM_MAX : Int?
    var BLE_HR_CS_CHD_TAG_1 : Int?
    var BLE_HR_CS_CHD_TAG_2 : Int?
    var BLE_HR_CS_CHD_TAG_3 : Int?
    var BLE_HR_CS_CHD_TAG_4 : Int?
    var BLE_HR_CS_CHD_TAG_5 : Int?
    var BLE_HR_CS_CHD_TAG_6 : Int?
    var BLE_HR_CS_CHD_TAG_7 : Int?
    var BLE_HR_CS_CHD_TAG_8 : Int?
    var BLE_HR_CS_CHD_TAG_UNIT_1 : Int?
    var BLE_HR_CS_CHD_TAG_UNIT_2 : Int?
    var BLE_HR_CS_CHD_TAG_UNIT_3 : Int?
    var BLE_HR_CS_CHD_TAG_UNIT_4 : Int?
    var HR_CS_FREQUENCY_TO_FILTER : Int?
    var BLE_HR_CS_CH1_ENABLE : Int? //1115
    var ch1_mode : Int?//HR_CS_CH1_MODE
    var ch1SensorType : Int?//HR_CS_CH1_SENSOR_TYPE
    var ch1_unit : Int?//HR_CS_CH1_UNIT
    var BLE_HR_CS_CH1_RANGE_MIN : Int?
    var BLE_HR_CS_CH1_RANGE_MAX : Int?
    var BLE_HR_CS_CH1_ENABLE_ALARM_MIN : Int?
    var BLE_HR_CS_CH1_ENABLE_ALARM_MAX : Int?
    var BLE_HR_CS_CH1_ALARM_MIN : Int?
    var BLE_HR_CS_CH1_ALARM_MAX : Int?
    var ch1_n_decimal : Int?//HR_CS_CH1_DECIMAL_POINT
    var HR_CS_CH1_GAIN_USER_RESERVED : Int?//1126
    var BLE_HR_CS_CH1_OFFSET_USER : Int?
    var HR_CS_RESERVED_28 : Int?//1128
    var BLE_HR_CS_CH1_TAG_1 : Int?
    var BLE_HR_CS_CH1_TAG_2 : Int?
    var BLE_HR_CS_CH1_TAG_3 : Int?
    var BLE_HR_CS_CH1_TAG_4 : Int?
    var BLE_HR_CS_CH1_TAG_5 : Int?
    var BLE_HR_CS_CH1_TAG_6 : Int? //ACABA AQUI BLOCO 2
    var BLE_HR_CS_CH1_TAG_7 : Int?
    var BLE_HR_CS_CH1_TAG_8 : Int?
    var BLE_HR_CS_CH1_TAG_UNIT_1 : Int?
    var BLE_HR_CS_CH1_TAG_UNIT_2 : Int?
    var BLE_HR_CS_CH1_TAG_UNIT_3 : Int?
    var BLE_HR_CS_CH1_TAG_UNIT_4 : Int?
    var HR_CS_RESERVED_29 : Int? //1141
    var HR_CS_CH1_CUSTOM_CALIB_NUM_OF_POINTS : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_1 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_2 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_3 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_4 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_5 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_6 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_7 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_8 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_9 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_LOGBOX_10 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_1 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_2 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_3 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_4 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_5 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_6 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_7 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_8 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_9 : Int?
    var HR_CS_CH1_CUSTOM_CALIB_PADRAO_10 : Int?
    var HR_CS_CH1_ALARM_MIN_HYSTERESIS : Int?
    var HR_CS_CH1_ALARM_MAX_HYSTERESIS : Int?
    var HR_CS_CH1_ALARM_MIN_MAX_CLEAR_STATUS : Int?
    var HR_CS_RESERVED_33 : Int?
    var HR_CS_RESERVED_34 : Int? //1167
    var BLE_HR_CS_CH2_ENABLE : Int?
    
    
    var ch2_mode: Int?//HR_CS_CH2_MODE
    var ch2SensorType: Int?//HR_CS_CH2_SENSOR_TYPE
    var ch2_unit: Int?//HR_CS_CH2_UNIT
    var BLE_HR_CS_CH2_RANGE_MIN: Int?
    var BLE_HR_CS_CH2_RANGE_MAX: Int?
    var BLE_HR_CS_CH2_ENABLE_ALARM_MIN: Int?
    var BLE_HR_CS_CH2_ENABLE_ALARM_MAX: Int?
    var BLE_HR_CS_CH2_ALARM_MIN: Int?
    var BLE_HR_CS_CH2_ALARM_MAX: Int?
    var ch2_n_decimal: Int?//HR_CS_CH2_DECIMAL_POINT
    var HR_CS_CH2_GAIN_USER_RESERVED: Int?
    var BLE_HR_CS_CH2_OFFSET_USER: Int?
    var HR_CS_RESERVED_36: Int? //1181
    var BLE_HR_CS_CH2_TAG_1: Int?
    var BLE_HR_CS_CH2_TAG_2: Int?
    var BLE_HR_CS_CH2_TAG_3: Int?
    var BLE_HR_CS_CH2_TAG_4: Int?
    var BLE_HR_CS_CH2_TAG_5: Int?
    var BLE_HR_CS_CH2_TAG_6: Int?
    var BLE_HR_CS_CH2_TAG_7: Int?
    var BLE_HR_CS_CH2_TAG_8: Int?
    var BLE_HR_CS_CH2_TAG_UNIT_1: Int?
    var BLE_HR_CS_CH2_TAG_UNIT_2: Int?
    var BLE_HR_CS_CH2_TAG_UNIT_3: Int?
    var BLE_HR_CS_CH2_TAG_UNIT_4: Int?
    var HR_CS_RESERVED_37: Int?//1194
    var HR_CS_CH2_CUSTOM_CALIB_NUM_OF_POINTS: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_1: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_2: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_3: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_4: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_5: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_6: Int? //Bloco 3 acaba aqui
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_7: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_8: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_9: Int?
    var HR_CS_CH2_CUSTOM_CALIB_LOGBOX_10: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_1: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_2: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_3: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_4: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_5: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_6: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_7: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_8: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_9: Int?
    var HR_CS_CH2_CUSTOM_CALIB_PADRAO_10: Int?
    var HR_CS_CH2_ALARM_MIN_HYSTERESIS: Int?
    var HR_CS_CH2_ALARM_MAX_HYSTERESIS: Int?
    var HR_CS_CH2_ALARM_MIN_MAX_CLEAR_STATUS: Int?
    var HR_CS_RESERVED_41: Int?
    var HR_CS_RESERVED_42: Int?
    var BLE_HR_CS_CH3_ENABLE: Int?
    var ch3_mode: Int?//HR_CS_CH3_MODE
    var ch3SensorType: Int?//HR_CS_CH3_SENSOR_TYPE
    var ch3_unit: Int?//HR_CS_CH3_UNIT
    var BLE_HR_CS_CH3_RANGE_MIN: Int?
    var BLE_HR_CS_CH3_RANGE_MAX: Int?
    var BLE_HR_CS_CH3_ENABLE_ALARM_MIN: Int?
    var BLE_HR_CS_CH3_ENABLE_ALARM_MAX: Int?
    var BLE_HR_CS_CH3_ALARM_MIN: Int?
    var BLE_HR_CS_CH3_ALARM_MAX: Int?
    var ch3_n_decimal: Int?//HR_CS_CH3_DECIMAL_POINT
    var HR_CS_CH3_GAIN_USER_RESERVED: Int?
    var BLE_HR_CS_CH3_OFFSET_USER: Int?
    var HR_CS_RESERVED_44: Int? //1234
    var BLE_HR_CS_CH3_TAG_1: Int?
    var BLE_HR_CS_CH3_TAG_2: Int?
    var BLE_HR_CS_CH3_TAG_3: Int?
    var BLE_HR_CS_CH3_TAG_4: Int?
    var BLE_HR_CS_CH3_TAG_5: Int?
    var BLE_HR_CS_CH3_TAG_6: Int?
    var BLE_HR_CS_CH3_TAG_7: Int?
    var BLE_HR_CS_CH3_TAG_8: Int?
    var BLE_HR_CS_CH3_TAG_UNIT_1: Int?
    var BLE_HR_CS_CH3_TAG_UNIT_2: Int?
    var BLE_HR_CS_CH3_TAG_UNIT_3: Int?
    var BLE_HR_CS_CH3_TAG_UNIT_4: Int?
    var HR_CS_RESERVED_45: Int?
    var HR_CS_CH3_CUSTOM_CALIB_NUM_OF_POINTS: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_1: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_2: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_3: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_4: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_5: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_6: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_7: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_8: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_9: Int?
    var HR_CS_CH3_CUSTOM_CALIB_LOGBOX_10: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_1: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_2: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_3: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_4: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_5: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_6: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_7: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_8: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_9: Int?
    var HR_CS_CH3_CUSTOM_CALIB_PADRAO_10: Int?
    
    var HR_CS_CH3_ALARM_MIN_HYSTERESIS: Int?
    var HR_CS_CH3_ALARM_MAX_HYSTERESIS: Int?
    var HR_CS_CH3_ALARM_MIN_MAX_CLEAR_STATUS: Int?//1271
    
    var SA_PASS1_1_2: Int? //3006
    var SA_PASS1_3_4: Int? //3007
    var SA_PASS1_5_6: Int? //3008
    var SA_PASS1_7_8: Int? //3009
    
    
    var passwordArray : [UInt8]? //8
    var byte: [UInt8]?
    
    
    var downloadlastDate : Date?
    var lastDate : Date?
    var firstDate : Date?
    var startDate : Date?
    var stopDate : Date?
    var serialNumber : Int?
    var serialNumberAux : Int = 0
    var firmwareNumber : Int?
    var logsTotalNumber : Int?
    var numberOfFreeLogs : Int?
    var logsDownloaded : Int?
    var digiEventsLogsDownloaded : Int?
    var statusOfRecords : Int?
    var batteryCharge : Int?
    var externalVoltage : Float?
    
    //*************************************
    var title : [UInt8]?
    
    var ble_en : Bool?
    var quality_RSSI : Int?
    
    //*************************************
    var ssid : [UInt8]? //8
    var regs_en : Bool?
    var memCircular : Bool?
    var chdEnabled : Bool?
    var startStopByButton : Bool?
    var ch1Enabled : Bool?
    
    //*************************************
    
    var ch_tag : [UInt8]?
    var ch1_tag : [UInt8]?
    var ch2_tag : [UInt8]?
    var ch3_tag : [UInt8]?
    
    
    var chd_unit_custom : [UInt8]?
    var ch1_unit_custom : [UInt8]?
    var ch2_unit_custom : [UInt8]?
    var ch3_unit_custom : [UInt8]?
    
    
    var ch1_LimitHigh : Float?
    var ch1_LimitLow : Float?
    var ch1AlarmHighEnabled : Bool?
    var ch1AlarmLowEnabled : Bool?
    var ch1AlarmHigh : Float?
    var ch1AlarmLow : Float?
    var ch1UserOffset : Float?
    var ch2Enabled : Bool?
    //*************************************
  //  var byte ch2_tag[] = new byte[16];
    //var byte ch2_unit_custom[] = new byte[16];
    var ch2_LimitHigh : Float?
    var ch2_LimitLow : Float?
    var ch2AlarmHighEnabled : Bool?
    var ch2AlarmLowEnabled : Bool?
    var ch2AlarmHigh : Float?
    var ch2AlarmLow : Float?
    var ch2UserOffset : Float?
    var ch3Enabled : Bool?
    //*************************************
    
    
    var ch3_LimitHigh : Float?
    var ch3_LimitLow : Float?
    var ch3AlarmHighEnabled : Bool?
    var ch3AlarmLowEnabled : Bool?
    var ch3AlarmHigh : Float?
    var ch3AlarmLow : Float?
    var ch3UserOffset : Float?
    //*************************************
    
    // var byte chd_tag[] = new byte[16];
    //var byte chd_unit_custom [] = new byte[16];
    var chd_multCoeff : Float? = 0
    var chd_multCoeff_custom : Float?
    var chd_scaleCoeff : Float?
    var chd_n_decimal : Int?
    var chdAlarmHighEnabled : Bool?
    var chdAlarmLowEnabled : Bool?
    var chdAlarmHigh : Float?
    var chdAlarmLow : Float?
    var chdAlarmHighHyst : Float?
    var chdAlarmLowHyst : Float?
    var chdUserOffset : Float?
    var downloadPointer : Int = 0
    var digitalEventsPointer  : Int = 0
    var downloadEnd : Bool = false
    //*************************************
    
    // var Channel channels[];
    //var Channel digitalChannel;
    //var Channel channelsToGraph[];
    var  isSaveFiles : Bool = false
    var  isExportChart : Bool?
    var  isExportCSV : Bool?
    var  isExportNXC : Bool?
    var  isExportNXD : Bool?
    var  isExportDigiCSV : Bool?
    var  exportAutomatic : Bool = false
    var  firstRead : Bool = true
    var nFolderColect : String? // Variável de testes, "nome da pasta coleta atual"
    
    static var ONE_MINUTE_IN_MILLIS : Float = 60000 //millisecs
    
    
    //*************************************
    //construtor
//    public Device()
//    init(){
//        for(int i=0;i<20;i++){
//            title[i] = 0;
//        }
//    }
    
    
    func setSaveFiles(saveFiles : Bool) {
        self.isSaveFiles = saveFiles
    }
    
    func setExportChart(exportChart : Bool) {
        isExportChart = exportChart
    }
    
    func setExportCSV(exportCSV : Bool) {
        isExportCSV = exportCSV
    }
    
    
    func setExportDigiCSV(exportDigiCSV : Bool) {
        isExportDigiCSV = exportDigiCSV;
    }
    
    
    func setExportNXC(exportNXC : Bool) {
        isExportNXC = exportNXC
    }
    
    
    func setExportNXD(exportNXD : Bool) {
        isExportNXD = exportNXD
    }
    
    func setExportAutomatic(isExportAutomatic : Bool) {
        self.exportAutomatic = isExportAutomatic
    }
    
    //Douglas Maked
    /**
     * Converte um instante de tempo do formato do <B>Java</B> para o formato do
     * <B>Delphi</B><BR>
     * <BR>
     * - No <B>Java</B> o instante e um <B>long</B> que corresponde a
     * <B>quantidade de milisegundos</B> que passaram <B>desde 01/01/1970</B><BR>
     * <BR>
     * - No <B>Delphi</B> o instante e um <B>double</B> cuja <B>parte
     * inteira</B> corresponde a <B>quantidade de dias</B> que se passaram
     * <B>desde 30/12/1899</B> e a <B>parte fracionaria</B> e uma <B>fracao das
     * 24 horas de um dia</B>
     */
    //************************************************************************************
    
    //public static double toDelphi(final long javaMillis) {
      //  return (javaMillis / (double) MILLIS_PER_DAY) + DAYS_DIFERENCE;
   // }
    
    /**
     * Converte um instante de tempo do formato do <B>Delphi</B> para o formato
     * do <B>Java</B><BR>
     * <BR>
     * - No <B>Delphi</B> o instante é um <B>double</B> cuja <B>parte
     * inteira</B> corresponde a <B>quantidade de dias</B> que se passaram
     * <B>desde 30/12/1899</B> e a <B>parte fracionária</B> é uma <B>fração das
     * 24 horas de um dia</B><BR>
     * <BR>
     * - No <B>Java</B> o instante é um <B>long</B> que corresponde a
     * <B>quantidade de milisegundos</B> que passaram <B>desde 01/01/1970</B>
     */
    //************************************************************************************
    
//    public static long toJava(final double delphiDays) {
//        return Math.round((delphiDays - DAYS_DIFERENCE) * MILLIS_PER_DAY);
//    }
//
    
//    public long apllyOffsetBeetwennTimezones(long date_){
//        long date = date_;//Date em UTC
//        long finalDate = 0;
//        int offsetReal = 0;
//        int offsetLocal = TimeZone.getDefault().getOffset(date);//Offset Local
//        int signal = 1;
//        int ConfiguredOffset = this.gmt * 60 * 1000;//OffSetConfigurado
//
//        //Calcular o sinal
//        //if(ConfiguredOffset < 0) signal = -1;
//
//        //Calcular o Offset Real
//        if(offsetLocal != ConfiguredOffset){
//
//            if(offsetLocal > ConfiguredOffset) {
//                offsetReal = offsetLocal - ConfiguredOffset;
//                signal = 1;
//            }
//            else{
//                offsetReal = ConfiguredOffset - offsetLocal;
//                signal = -1;
//            }
//        }
//
//        offsetReal = signal * offsetReal;
//
//        finalDate = (date + offsetReal);
//
//        return finalDate;
//    }
    
    //Douglas Maked
    //Método para aplicar número de casas decimais conforme configuração do equipamento
    func ApplyDecimalDigital (isDigital : Bool, NdecimalPlacesAfter : Int, NdecimalPlacesBefore : Int, value : Double) { //}-> String {
//        String Fvalue = "";
//        String xplaces = "";
//
//        if (isDigital)
//        {
//            if(NdecimalPlacesAfter == 0)//after
//            {
//                {
//                    switch (NdecimalPlacesBefore)
//                    {
//                    case 6:
//                        xplaces = String.valueOf(NdecimalPlacesAfter);
//                        Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*1000000);
//                        break;
//                    case 5:
//                        xplaces = String.valueOf(NdecimalPlacesAfter);
//                        Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*100000);
//                        break;
//                    case 2:
//                        xplaces = String.valueOf(NdecimalPlacesAfter);
//                        Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*100);
//                        break;
//                    case 1:
//                        xplaces = String.valueOf(NdecimalPlacesAfter);
//                        Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*10);
//                        break;
//                    }
//                }
//            }
//            else if (NdecimalPlacesAfter == 1)
//            {
//                switch (NdecimalPlacesBefore)
//                {
//                case 6:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*100000);
//                    break;
//                case 5:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*10000);
//                    break;
//                case 2:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*10);
//                    break;
//                case 0:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/10);
//                    break;
//                }
//            }
//            else if (NdecimalPlacesAfter == 2)
//            {
//                switch (NdecimalPlacesBefore)
//                {
//                case 6:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*10000);
//                    break;
//                case 5:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*1000);
//                    break;
//                case 1:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/10);
//                    break;
//                case 0:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/100);
//                    break;
//                }
//            }
//            else if (NdecimalPlacesAfter == 5)
//            {
//                switch (NdecimalPlacesBefore)
//                {
//                case 6:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value*10);
//                    break;
//                case 2:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/1000);
//                    break;
//                case 1:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/10000);
//                    break;
//                case 0:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/100000);
//                    break;
//                }
//            }
//            else if (NdecimalPlacesAfter == 6)
//            {
//                switch (NdecimalPlacesBefore)
//                {
//                case 5:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/10);
//                    break;
//                case 2:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/10000);
//                    break;
//                case 1:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/100000);
//                    break;
//                case 0:
//                    xplaces = String.valueOf(NdecimalPlacesAfter);
//                    Fvalue = String.format(Locale.US,"%.0"+xplaces+"f",value/1000000);
//                    break;
//                }
//            }
//        }
//
//        return String.format(Locale.US,Fvalue, value);
    }
    
    func ApplyDecimalPlaceF (isDigital : Bool, sensorType : Int, NdecimalPlaces : Int, value : Int) { //-> Double{
//        var Fvalue = 0.0
//
//        if (isDigital){   //aplica formula para passar de contagem para float
//            Fvalue =  countsToUserUnits(value ,this.chd_multCoeff, this.chd_scaleCoeff,this.HR_CS_CHD_SENSOR_UNIT, this.interval);
//            //Fvalue = (double) value/(Math.pow(10, NdecimalPlaces));
//        }
//        else{
//            //Pt100 , ThermoCouple K , ThermoCouple J, ThermoCouple R
//            //ThermoCouple S, ThermoCouple T, ThermoCouple N, ThermoCouple E, ThermoCouple B e Cold Junction
//            if (SensorType >= 1 && SensorType <= 9 || SensorType == 15){
//                Fvalue = (double) value/10;
//            }
//
//                //Battery Voltage, External Source Voltage
//            else if(SensorType > 15){
//                Fvalue = (double) value/100;
//            }
//
//            // Lineares
//            else
//            Fvalue = (double) value/( Math.pow(10, NdecimalPlaces));
//        }
//
//        return Fvalue;
    }
    
    func formatValue(value : Double, decimalPlaces : Int) { //} -> String{
//        String xplaces = String.valueOf(decimalPlaces)
//        return String.format(Locale.US,"%.0"+xplaces+"f",value)
    }
    
    func formatFloat(decimalPlaces : Int) { //-> String{
//        String xplaces = String.valueOf(decimalPlaces)
//        String formatFloat = "%.0"+xplaces+"f"
//        return formatFloat
    }
    
    
    var digital_User_Unit_Flow_Table : [Float] = [
        1                          //l/s,
        , 60                         //l/min,
        , 3600                       //l/h,
        , 0.264172052       //gal/s,
        , 15.8503231        //gal/min,
        , 951.019388        //gal/h,
        , 0.001             //m³/s,
        , 0.06              //m³/min,
        , 3.6              //m³/h
        , 1
    ]                       //Default
        
    var digital_Sensor_Unit_Table : [Float] = [
        1,                        //    pulses/l,
        3.78541178,        //     pulses/gal,
        1000,                    //    pulses/m³,
        1,                        //  default
    ]
    
    
    // *****************************************************************************
    //a principio nao e usado
    func countsToUserUnits(counts : Int, gaugeFactor : Float, scaleFactor : Float, sensorUnit : Int, loggingInterval : Int) { //-> Float{
//        float fTemp;
//
//        double dGauge = (GaugeFactor != 0 ? GaugeFactor : 1);
//
//        try {
//        //fTemp = ((((float)u32Counts)/(dGauge*Digital_Sensor_Unit_Table[stChannel[u8Channel].u8SensorUnit]))/Fu16LoggingInterval)*stChannel[u8Channel].fScaleFactor;
//        fTemp = (float) (((((float) Counts) / (dGauge * Digital_Sensor_Unit_Table[SensorUnit])) / LoggingInterval) * ScaleFactor);
//        }
//        catch (Exception e)
//        {
//        fTemp = 0;
//        }
//
//        return fTemp;
    }
    
    
    func UserUnitToCounts(fValue : Float, scaleFactor : Float, gaugeFactor : Float, loggingInterval : Int, sensorUnit : Int) { //-> Int{
//        var uTemp : Int?
//        var dScaleFac : Float = (scaleFactor != 0 ? scaleFactor : 1)
//
//        uTemp = (int) (gaugeFactor * Digital_Sensor_Unit_Table[sensorUnit] * (loggingInterval*(fValue/dScaleFac)))
//        return uTemp
    }
    
    var tz = [
        -720,//-12:00
        -660,//-11:00
        -630,//-10:30
        -600,//-10:00
        -570,//-09:30
        -540,//-09:00
        -510,//-08:30
        -480,//-08:00
        -420,//-07:00
        -360,//-06:00
        -330,//-05:30
        -300,//-05:00
        -270,//-04:30
        -240,//-04:00
        -210,//-03:30
        -180,//-03:00
        -150,//-02:30
        -120,//-02:00
        -60,//-01:00
        0,  //00:00
        60, //01:00
        120,//02:00
        150,//02:30
        180,//03:00
        210,//03:30
        240,//04:00
        270,//04:30
        300,//05:00
        330,//05:30
        345,//05:45
        360,//06:00
        390,//06:30
        420,//07:00
        450,//07:30
        480,//08:00
        510,//08:30
        525,//08:45
        540,//09:00
        570,//09:30
        600,//10:00
        630,//10:30
        660,//11:00
        690,//11:30
        720,//12:00
        750,//12:30
        765,//12:45
        780,//13:00
        840//14:00
    ]
    
    
    func GetTimeZoneCode(tz : Int) -> String {
        var Tz : String!
        
        switch(tz){
        case -720:
            Tz = "GMT-12" //-12:00
            break
        case -660:
            Tz = "GMT-11"//-11:00
            break
        case -630://-10:30
            Tz = "GMT-10"
            break
        case -600://-10:00
            Tz = "GMT-10"
            break;
        case -570://-09:30
            Tz = "GMT-9"
            break;
        case -540://-09:00
            Tz = "GMT-9"
            break;
        case -510://-08:30
            Tz = "GMT-8"
            break;
        case -480://-08:00
            Tz = "GMT-8"
            break;
        case -420://-07:00
            Tz = "GMT-7"
            break;
        case -360://-06:00
            Tz = "GMT-6"
            break;
        case -330://-05:30
            Tz = "GMT-5"
            break;
        case -300://-05:00
            Tz = "GMT-5"
            break;
        case -270://-04:30
            Tz = "GMT-4"
            break;
        case -240://-04:00
            Tz = "GMT-4"
            break;
        case -210://-03:30
            Tz = "GMT-3"
            break;
        case -180://-03:00
            Tz = "GMT-3"
            break;
        case -150://-02:30
            Tz = "GMT-2"
            break;
        case -120://-02:00
            Tz = "GMT-2"
            break;
        case -60://-01:00
            Tz = "GMT-1"
            break;
        case 0://00:00
            Tz = "UTC"
            break;
        case 60: //01:00
            Tz = "GMT+1"
            break;
        case 120://02:00
            Tz = "GMT+2"
            break;
        case 150://02:30
            Tz = "GMT+2"
            break;
        case 180://03:00
            Tz = "GMT+3"
            break
        case 210://03:30
            Tz = "GMT+3"
            break
        case 240://04:00
            Tz = "GMT+4"
            break
        case 270://04:30
            Tz = "GMT+4"
            break
        case 300://05:00
            Tz = "GMT+5"
            break
        case 330://05:30
            Tz = "GMT+5"
            break
        case 345://05:45
            Tz = "GMT+5"
            break
        case 360://06:00
            Tz = "GMT+6"
            break
        case 390://06:30
            Tz = "GMT+6"
            break
        case 420://07:00
            Tz = "GMT+7"
            break
        case 450://07:30
            Tz = "GMT+7"
            break
        case 480://08:00
            Tz = "GMT+8"
            break
        case 510://08:30
            Tz = "GMT+8"
            break
        case 525://08:45
            Tz = "GMT+8"
            break
        case 540://09:00
            Tz = "GMT+9"
            break
        case 570://09:30
            Tz = "GMT+9"
            break
        case 600://10:00
            Tz = "GMT+10"
            break
        case 630://10:30
            Tz = "GMT+10"
            break
        case 660://11:00
            Tz = "GMT+11"
            break
        case 690://11:30
            Tz = "GMT+11"
            break
        case 720://12:00
            Tz = "GMT+12"
            break
        case 750://12:30
            Tz = "GMT+12"
            break
        case 765://12:45
            Tz = "GMT+12"
            break
        case 780://13:00
            Tz = "GMT+13"
            break
        case 840://14:00
            Tz = "GMT+14"
            break
        default:
            Tz = "UTC"
            break
        }
        
        return Tz
    }
    
    
    func getTz (timezone : Int) -> Int{
        
        for i in 0 ... 48 {
            if(self.tz[i] == timezone){
                return i
            }
        }
        
        return 19 //UTC
    }
    
    func getBitPos(bitVector : Int) -> Int{
        switch (bitVector) {
        case 1:
            return 0;
        case 2:
            return 1;
        case 8:
            return 3;
        case 4:
            return 2;
        case 16:
            return 4;
        default:
            return 5;
        }
    }
    
    func getSensorType(sensor : Int) -> Int{
        switch (sensor){
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return 0
        case 4:
            return 0
        case 5:
            return 0
        case 6:
            return 0
        case 7:
            return 0
        case 8:
            return 0
        case 9:
            return 0
        case 15:
            return 0
        case 10:
            return 1
        case 11:
            return 1
        case 12:
            return 1
        case 13:
            return 1
        case 14:
            return 1
        default:
            return 2
        }
    }
    
    
    
    //Ajusta tempo em UTC para o GMT configurado no LogBox
    func getTimewithGMT(min : Int, data: Date){ //-> Date{
//        Calendar date = Calendar.getInstance();
//        date.setTime(data);
//
//        long t = date.getTimeInMillis();
//
//        Date afterAddingMins=new Date(t + (min * ONE_MINUTE_IN_MILLIS));
//
  //      return afterAddingMins;
    }
    
    func getTitle() -> String{
        
        let getDataFromBytes = NSData(bytes: title , length: 20)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
       
    }
    
    func getStringSum(b : [UInt8]) -> Int{
        
        var sum = 0
        for i in 0 ... b.count {
            sum = Int(b[i]) + sum
        }
    
        return sum
    
    }
    
    func getSSID() -> String{
        let getDataFromBytes = NSData(bytes: ssid , length: 20)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    //Maked Douglas
    func getPassword() -> String{
        let getDataFromBytes = NSData(bytes: passwordArray , length: 8)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    
    func getCh1Tag() -> String{
        let getDataFromBytes = NSData(bytes: ch1_tag , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getCh2Tag() -> String{
        let getDataFromBytes = NSData(bytes: ch2_tag , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getCh3Tag() -> String{
        let getDataFromBytes = NSData(bytes: ch3_tag , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getChdTag() -> String{
        let getDataFromBytes = NSData(bytes: ch_tag , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    //**********************************************
    //??
//    public byte[] shift(byte[] bytes, int index){
//        byte [] temp = new byte[16-index];
//        temp = bytes;
//        byte [] ret = new byte[16];
//        int j = 0;
//
//        bytes[index] = (byte)0xC2;
//
//        for(int i = index+1; i < bytes.length; i++){
//            bytes[i] = temp[i-1];
//        }
//        for(int i = 0; i < 16; i++){
//            ret[i] = bytes[i];
//        }
//        return ret;
//    }
    
    
    //**********************************************
    //tratar nil
    func getCh1UnitCustom() -> String{
        let getDataFromBytes = NSData(bytes: ch1_unit_custom , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getCh2UnitCustom() -> String{
        let getDataFromBytes = NSData(bytes: ch2_unit_custom , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getCh3UnitCustom() -> String{
        let getDataFromBytes = NSData(bytes: ch2_unit_custom , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
    func getChdUnitCustom() -> String{
        let getDataFromBytes = NSData(bytes: chd_unit_custom , length: 16)
        let dataString = NSString(data: getDataFromBytes as Data, encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
    
 
    
}
