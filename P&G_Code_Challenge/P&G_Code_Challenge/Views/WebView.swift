//  Webview.swift
//  P&G_Code_Challenge
//
//  Created by Chad Wishner on 10/15/20.

import Foundation
import SwiftUI
import WebKit

/** Web view struct to open url of a qualified story
*/
struct WebView: UIViewRepresentable {
	// Necessary function for UIViewRepresentable
	func updateUIView(_ uiView: UIViewType, context: Context) {
	}
	
	// Param for url
	var url: String
	
	/** Function to return WKWebView
	*/
	func makeUIView(context: Context) -> some WKWebView {
		// Create URL if prossible else return empty WKWebView
		guard let url = URL(string: self.url) else {
			return WKWebView()
		}
		
		// Build and return WKWebView
		let request = URLRequest(url: url)
		let wkWebView = WKWebView()
		wkWebView.load(request)
		return wkWebView
    }
	
}
