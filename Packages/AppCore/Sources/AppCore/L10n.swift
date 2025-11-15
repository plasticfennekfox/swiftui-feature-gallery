//
//  L10n.swift
//  AppCore
//
//  Created by Fuchs on 14/11/25.
//

import Foundation

public enum L10n {
    public static func tr(
        _ key: String,
        comment: String = "",
        _ args: CVarArg...
    ) -> String {
        let format = NSLocalizedString(
            key,
            tableName: "Localizable",
            bundle: .main,
            comment: comment
        )
        return String(format: format, locale: .current, arguments: args)
    }
}
