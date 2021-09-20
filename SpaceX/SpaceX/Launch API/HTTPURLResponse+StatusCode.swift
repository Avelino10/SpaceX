//
//  HTTPURLResponse+StatusCode.swift
//  SpaceX
//
//  Created by Avelino Rodrigues on 20/09/2021.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
