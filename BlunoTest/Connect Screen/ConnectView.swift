//
//  ConnectView.swift
//  BlunoTest
//
//  Created by Avario Babushka on 23/09/19.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct ConnectView: View {
	
	@EnvironmentObject var blunoService: BlunoService
	
	var body: some View {
		List {
			if blunoService.detectedPeripherals.isEmpty {
				Text("No devices detected")
					.foregroundColor(.secondary)
			} else {
				ForEach(blunoService.detectedPeripherals) { peripheral in
					HStack {
						VStack(alignment: .leading) {
							Text(peripheral.name ?? "Unknown")
							Text(peripheral.identifier.uuidString)
								.font(.caption)
								.foregroundColor(.secondary)
						}
						if self.blunoService.pairedPeripheral == peripheral {
							Spacer()
							PeripheralStateView(state: self.blunoService.peripheralState)
						}
					}
					.onTapGesture {
						self.blunoService.connect(to: peripheral)
					}
				}
			}
		}
		.listStyle(GroupedListStyle())
		.navigationBarTitle("Devices")
		.navigationBarItems(
			trailing: Button(action: self.blunoService.disconnect) {
				Text("Disconnect")
			}.disabled(blunoService.peripheralState != .connected)
		)
	}
}

struct ConnectView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ConnectView()
				.environmentObject(BlunoService())
		}
	}
}
