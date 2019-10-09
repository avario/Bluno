//
//  StatusScreenData.swift
//  BlunoTest
//
//  Created by Avario on 04/10/2019.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import Combine

class StatusScreenData: ObservableObject {
	
	@Published var throttleInput = 0
	@Published var throttleOutput = 0
	
	private var dataSubscription: Cancellable?
	
	func startReceivingData(from blunoService: BlunoService) {
		dataSubscription = blunoService.receivedData
			.compactMap { String(data: $0, encoding: .utf8) }
			.sink(receiveValue: self.decode)
	}
	
	func decode(data: String) {
		print(data)
		
		let values = data.components(separatedBy: ",")
		for value in values {
			let keyValue = value.components(separatedBy: ":")
			guard let key = keyValue.first,
				let valueString = keyValue.last,
				let value = Int(valueString) else {
					continue
			}
			
			switch key {
			case "i":
				throttleInput = value
			case "o":
				throttleOutput = value
			default:
				break
			}
		}
	}
}
