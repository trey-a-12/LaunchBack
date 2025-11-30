//
//  AppCategorizer.swift
//  LaunchBack
//
//  Created by Jon Alaniz on 10/11/25.
//

import Foundation
import UniformTypeIdentifiers

final class AppCategorizer {
    static func getLocalizedCategory(for identifier: String?) -> String {
        let type = UTType(identifier ?? "")
        return type?.localizedDescription ?? "Other"
    }
}
