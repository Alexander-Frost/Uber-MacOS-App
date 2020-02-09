//
//  UberLoader.swift
//  MacOobur
//
//  Created by Alex on 10/13/19.
//  Copyright © 2019 AlexMata. All rights reserved.
//

import Foundation
import OAuth2

class UberLoader: OAuth2DataLoader {

    // MARK: - Properties
    
//	let baseURL = URL(string: "https://api.uber.com/v1.2/")!
	let baseURL = URL(string: "https://sandbox-api.uber.com/v1.2/")!

	static let shared = UberLoader()

    // MARK: - Init
    
	public init() {
		let oauth = OAuth2CodeGrant(settings: [
			"client_id": "V7lMcOHZp_8Q-fCzSkEQZKnwcUAZlwDx",
			"client_secret": "Xt4tzWuSvTrRGDc4Nj2vEzkpT5ep1xYqvkSXLniX",
			"authorize_uri": "https://login.uber.com/oauth/v2/authorize",
			"token_uri": "https://login.uber.com/oauth/v2/token",
			"redirect_uris": ["macoobur://oauth/callback"],
//			"scope": "profile history",
			"verbose": true,
		])
		super.init(oauth2: oauth)
	}

    // MARK: - Methods
    
	func test(path: String, callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
		oauth2.logger = OAuth2DebugLogger(.trace)
		let url = baseURL.appendingPathComponent(path)
		var req = oauth2.request(forURL: url)
		req.addValue("application/json", forHTTPHeaderField: "Content-Type")

		perform(request: req) { response in
			do {
				let dict = try response.responseJSON()
				callback(dict, nil)
			} catch {
				NSLog("error loading result: \(error)")
				callback(nil, error)
			}
		}
	}
}
