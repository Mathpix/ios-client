//
//  ImageRecognitionResult.swift
//  MathPix
//
//  Created by Дмитрий Буканович on 15.07.17.
//  Copyright © 2017 MathPix. All rights reserved.
//

import Foundation


public struct RecognitionResult {
    let parsed: NSDictionary?
    let data: Data?
    
    init(data: Data) throws {
        
        var JSONObject: Any?
        var parsedObject: NSDictionary?
        
        // Parse response data to check Parse Error or Image Recognition Error (not math)
        do {
            JSONObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
        } catch {
            throw RecognitionError.failedParseJSON
        }
        
        // Check if image not math
        if let object = JSONObject as? NSDictionary {
            if let responseError = object["error"] as? String , responseError.count > 0 {
                if responseError == "Invalid credentials" {
                    throw RecognitionError.invalidCredentials
                } else {
                    throw RecognitionError.notMath(description: responseError)
                }
            }
            parsedObject = object
        }
        
        self.parsed = parsedObject
        self.data = data
    }

    func toLatexListString() -> String? {
        if let latexArray = self.parsed?["latex_list"] as? Array<String> {
            return "[\(latexArray.map({elem in "\""+elem.replacingOccurrences(of: "\\", with: "\\\\")+"\"" }).joined(separator: ","))]"
        } else {
            return nil
        }
    }
}



















