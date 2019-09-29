//
//  BlunoService.swift
//  BlunoTest
//
//  Created by Avario Babushka on 23/09/19.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import Foundation
import Combine
import CoreBluetooth

class BlunoService: NSObject, ObservableObject {
	
	@Published var pairedPeripheral: CBPeripheral?
	@Published var peripheralState: CBPeripheralState = .disconnected

	@Published var detectedPeripherals: [CBPeripheral] = []

	@Published var messages: [String] = []

	static let serviceID = "dfb0"
	static let dataCharacteristicID = "dfb1"
	
	private let centralManager: CBCentralManager
	
	override init() {
		centralManager = CBCentralManager(delegate: nil, queue: nil)
		super.init()
		
		centralManager.delegate = self
	}
	
	func send(message: String) {
		guard let peripheral = pairedPeripheral,
			let service = peripheral.services?.first(where: { $0.uuid == CBUUID(string: BlunoService.serviceID) }),
			let characteristic = service.characteristics?.first(where: { $0.uuid == CBUUID(string: BlunoService.dataCharacteristicID) }) else {
				return
		}
		
		peripheral.writeValue(message.data(using: .utf8)!, for: characteristic, type: .withResponse)
	}
	
	private func start() {
		centralManager.scanForPeripherals(withServices: [CBUUID(string: BlunoService.serviceID)], options: nil)
	}
	
	private func stop() {
		centralManager.stopScan()
	}
	
	func connect(to peripheral: CBPeripheral) {
		
		if pairedPeripheral != peripheral {
			disconnect()
		}
		
		pairedPeripheral = peripheral
		peripheralState = .connecting
		
		centralManager.connect(peripheral, options: nil)
	}
	
	func disconnect() {
		guard let pairedPeripheral = pairedPeripheral else {
			return
		}
		
		self.pairedPeripheral = nil
		peripheralState = .disconnecting
		centralManager.cancelPeripheralConnection(pairedPeripheral)
	}
	
}

extension BlunoService: CBCentralManagerDelegate {
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		case .poweredOn:
			start()
		default:
			stop()
		}
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheralState = .connected
		peripheral.delegate = self
		peripheral.discoverServices(nil)
		stop()
	}
	
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		peripheralState = .disconnected
	}
	
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		peripheralState = .disconnected
		if let pairedPeripheral = pairedPeripheral {
			connect(to: pairedPeripheral)
		} else {
			start()
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if !detectedPeripherals.contains(peripheral) {
			detectedPeripherals.append(peripheral)
		}
		
		if pairedPeripheral == peripheral {
			switch peripheralState {
			case .disconnected:
				connect(to: peripheral)
			default:
				return
			}
		}
	}
	
}

extension BlunoService: CBPeripheralDelegate {
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard let services = peripheral.services else {
			return
		}
		
		for service in services {
			peripheral.discoverCharacteristics(nil, for: service)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		guard let characteristics = service.characteristics else {
			return
		}
		
		for characteristic in characteristics {
			print(characteristic.uuid)
			if characteristic.uuid == CBUUID(string: BlunoService.dataCharacteristicID) {
				peripheral.setNotifyValue(true, for: characteristic)
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		guard let data = characteristic.value,
			let message = String(data: data, encoding: .utf8) else {
				return
		}

		messages.insert(message, at: 0)
	}

}

extension CBPeripheral: Identifiable {
	public var id: UUID {
		return identifier
	}
}
