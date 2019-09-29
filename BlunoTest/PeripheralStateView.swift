//
//  PeripheralStateView.swift
//  BlunoTest
//
//  Created by Avario Babushka on 24/09/19.
//  Copyright © 2019 Avario Babushka. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct PeripheralStateView: View {
	let state: CBPeripheralState
	
	var body: some View {
		Group {
			if self.state == .connected {
				Image(systemName: "checkmark.circle.fill")
					.foregroundColor(.green)
				
			} else if self.state == .connecting {
				ActivityIndicator()
				
			} else if self.state == .disconnected {
				Image(systemName: "xmark.circle.fill")
					.foregroundColor(.orange)
			}
		}
	}
	
	struct ActivityIndicator: UIViewRepresentable {
		
		func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
			let activityIndicator = UIActivityIndicatorView(style: .medium)
			activityIndicator.startAnimating()
			return activityIndicator
		}
		
		func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
			
		}
	}
}

struct PeripheralStateView_Previews: PreviewProvider {
	static var previews: some View {
		PeripheralStateView(state: .connected)
	}
}
