//
//  MathpixClient+Bundle.swift
//  Pods
//
//  Created by Дмитрий Буканович on 08.09.17.
//
//

import Foundation

// Getting recources from framework bundles

extension MathpixClient {
    /// Helping function ot get image from resource bundle
    internal class func getImageFromResourceBundle(name: String) -> UIImage? {
        let podBundle = Bundle(for: MathpixClient.self)
        if let url = podBundle.url(forResource: "Images", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
}

