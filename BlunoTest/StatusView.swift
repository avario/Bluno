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

struct StatusView: View {
	@ObservedObject var blunoService: BlunoService
	
	@State private var input: String = ""

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Status".uppercased())) {
					NavigationLink(destination: ConnectView(blunoService: blunoService)) {
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
				Section(header: Text("Input".uppercased())) {
					HStack {
						TextField("Enter Text", text: $input)
						Button(action: sendMessage) {
							Text("Send")
						}
						.disabled(blunoService.peripheralState != .connected)
					}
				}
				Section(header: Text("Output".uppercased())) {
					if blunoService.messages.isEmpty {
						Text("No output received")
							.foregroundColor(.secondary)
					} else {
						ForEach(blunoService.messages, id: \.self) { output in
							Text(output)
						}
					}
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Bluno")
		}
	}
	
	func sendMessage() {
		blunoService.send(message: input)
	}
}

struct StatusView_Previews: PreviewProvider {
	static var previews: some View {
		StatusView(blunoService: BlunoService())
	}
}
