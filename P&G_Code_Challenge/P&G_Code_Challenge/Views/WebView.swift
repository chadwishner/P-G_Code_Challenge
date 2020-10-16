//  Webview.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import Foundation
import SwiftUI
import SafariServices

/** Web view struct to open url of a qualified story
*/
struct WebView: UIViewControllerRepresentable {
	let url: String

	// Build and return SafariViewController
	func makeUIViewController(context: UIViewControllerRepresentableContext<WebView>) -> SFSafariViewController {
		// Convert string to URL
		let url = URL(string: self.url)!
		
		return SFSafariViewController(url: url)
	}

	// Required function for UIViewControllerRepresentable
	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<WebView>) {

	}
	
}
