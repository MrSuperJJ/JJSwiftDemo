//
//  BLEViewController.swift
//  JJSwiftDemo
//
//  Created by 叶佳骏 on 2018/3/5.
//  Copyright © 2018年 Mr.JJ. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEViewController: UIViewController {
    
    var manager: CBCentralManager!
    var discoveredPeripheralsArr = [CBPeripheral]()
    var connectedPeripheral: CBPeripheral?

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 初始化，检测当前设备的蓝牙状态
        self.manager = CBCentralManager(delegate: self, queue: .main)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Functions
extension BLEViewController {
    
    /// 扫描外围设备
    func startScanForPeripherals() {
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    /// 停止扫描外围设备
    func stopScanForPeripherals() {
        manager.stopScan()
    }
    
    /// 连接外围设备
    func connect(peripheral: CBPeripheral) {
        manager.connect(peripheral, options: nil)
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            printLog("CBCentralManagerStateUnknown")
        case .resetting:
            printLog("CBCentralManagerStateResetting")
        case .unsupported:
            printLog("CBCentralManagerStateUnsupported")
        case .unauthorized:
            printLog("CBCentralManagerStateUnauthorized")
        case .poweredOff:
            printLog("CBCentralManagerStatePoweredOff")
        case .poweredOn:
            printLog("CBCentralManagerStatePoweredOn")
            startScanForPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let peripheralName = peripheral.name, peripheralName.contains("叶佳骏") {
            printLog(peripheralName)
            discoveredPeripheralsArr += [peripheral]
            connect(peripheral: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.discoverServices(nil)
        peripheral.delegate = self
        self.title = peripheral.name
        stopScanForPeripherals()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension BLEViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("discover \(peripheral.name!) services error: \(error.localizedDescription)")
            return
        }
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("discover \(peripheral.name!) characteristics error: \(error.localizedDescription)")
            return
        }
        for characteristic in service.characteristics! {
            peripheral.readValue(for: characteristic)
            //设置 characteristic 的 notifying 属性 为 true ， 表示接受广播
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}

