//
//  RecognitionError.swift
//  MathPix-API-Sample
//
//  Created by Дмитрий Буканович on 05.02.17.
//  Copyright © 2017 MathPix. All rights reserved.
//

import Foundation

/// Error type that can be thrown if recognition failed.
public enum RecognitionError: Error {

    /// Failed parse JSON, incorrect data returned
    case failedParseJSON
    /// Server can't recognize image as math
    case notMath(description: String)
    /// Invalid credentials, set correct api keys
    case invalidCredentials
    
}
