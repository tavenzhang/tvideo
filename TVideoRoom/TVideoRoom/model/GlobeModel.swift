import Foundation
import SwiftyJSON

import Foundation
import UIKit

class VersionModel: NSObject, DictModelProtocol {
	var name: String?;
	var version: NSNumber?;
	var page_active: String?;
	var domains: [DomainModel]?;

	static func customClassMapping() -> [String: String]? {
		return ["domains": "\(DomainModel.self)"];
	}
}

class DomainModel: NSObject {
	var domain: String?;
	var vdomain: String?;
	var pdomain: String?;
	var isOneRoom: NSNumber?;
}
