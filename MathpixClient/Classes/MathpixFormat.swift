//
//  Formatable.swift
//  Pods
//
//  Created by Дмитрий Буканович on 29.08.17.
//
//

import Foundation

    /// Additional field "formats" in request body.
public protocol MathpixFormat {
    var json : (key: String, value: Any) { get }
}

    ///  The latex field, if present, is one of “raw” (result is the unmodified OCR output), “defaultValue” (result is OCR output with extraneous spaces removed), or “simplified” (result has spaces removed, operator shortcuts, and is split into lists where appropriate).
public enum FormatLatex {
    case raw, defaultValue, simplified
}


extension FormatLatex: MathpixFormat {
    public var json: (key: String, value: Any) {
        switch self {
        case .raw:
            return (key: "latex", value: "raw")
        case .defaultValue:
            return (key: "latex", value: "default")
        case .simplified:
            return (key: "latex", value: "simplified")
        }
    }
}
    /// The mathml field, if present and set to on, indicates the server should add a mathml field to the JSON result that is a string containing the MathML markup for the recognized math. In the case of an incompatible result, the server will instead add a mathml_error.
public enum FormatMathml {
    case on
}

extension FormatMathml: MathpixFormat {
    public var json: (key: String, value: Any) {
        switch self {
        case .on:
            return (key: "mathml", value: true)
        }
    }
}

    /// The wolfram field, if present and set to on, indicates the server should add a wolfram field to the JSON result that is a string compatible with the Wolfram Alpha engine. In the case of an incompatible result, the server will instead add a wolfram_error field.
public enum FormatWolfram {
    case on
}

extension FormatWolfram: MathpixFormat {
    public var json: (key: String, value: Any) {
        switch self {
        case .on:
            return (key: "wolfram", value: true)
        }
    }
}



