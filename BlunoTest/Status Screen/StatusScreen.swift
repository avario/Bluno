//
//  StatusView.swift
//  BlunoTest
//
//  Created by Avario Babushka on 23/09/19.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import SwiftUI
import CoreBluetooth
import Combine

struct StatusScreen: View {
	
	@EnvironmentObject var blunoService: BlunoService
	
	@ObservedObject var data: StatusScreenData
	
	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Status".uppercased())) {
					NavigationLink(destination: ConnectView()) {
						if blunoService.pairedPeripheral == nil {
							Text("Not Paired")
						} else {
							HStack {
								Text("Paired")
								Spacer()
								PeripheralStateView(state: blunoService.peripheralState)
							}
						}
					}
				}
				Section(header: Text("Throttle".uppercased())) {
					InfoRow(label: "Input", value: data.throttleInput)
					InfoRow(label: "Output", value: data.throttleOutput)
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Bluno")
			.onAppear { self.data.startReceivingData(from: self.blunoService) }
		}
	}
	
	struct InfoRow: View {
		let label: String
		let value: Int
		
		var body: some View {
			HStack {
				Text(label)
					.foregroundColor(.primary)
				Spacer()
				Text(String(value))
					.foregroundColor(.secondary)
			}
		}
	}
}

struct StatusScreen_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			StatusScreen(data: StatusScreenData())
				.environmentObject(BlunoService())
		}
	}
}
