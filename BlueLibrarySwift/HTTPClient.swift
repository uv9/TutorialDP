//
//  HTTPClient
//  BlueLibrarySwift
//
//  Created by Udit on 11/09/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import UIKit

class HTTPClient {
	
	func getRequest(url: String) -> (AnyObject) {
		return NSData()
	}
	
	func postRequest(url: String, body: String) -> (AnyObject){
		return NSData()
	}
	
	func downloadImage(url: String) -> (UIImage) {
		let aUrl = NSURL(string: url)
		var data = NSData(contentsOfURL: aUrl!)
		let image = UIImage(data: data!)
		return image!
	}
	
}