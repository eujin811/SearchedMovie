//
//  MovieDetailViewController+.swift
//  SearchedMovie
//
//

import UIKit
import WebKit

extension MovieDetailViewController {
    func loadWebView(url: URL?) {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self

        guard let url = url else { return }
        let request = URLRequest(url: url)

        webView.load(request)
    }

}

extension MovieDetailViewController: WKUIDelegate { }

extension MovieDetailViewController: WKNavigationDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
