// 
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import Foundation
import UIKit
import SwiftUI


public class LightColors {
    private static let values = ColorValues(
        accent: UIColor(rgb:0xFF3D19),          // главный бренд
        alert: UIColor(rgb:0xD72600),           // ошибки темнее
        primaryContent: UIColor(rgb:0x111111),  // главный текст
        secondaryContent: UIColor(rgb:0x5F6368), // вторичный
        tertiaryContent: UIColor(rgb:0x8E8E93),  // слабый текст
        quarterlyContent: UIColor(rgb:0xC7C7CC),
        quinaryContent: UIColor(rgb:0xE5E5EA),
        separator: UIColor(rgb:0xE5E5EA),

        system: UIColor(rgb:0xF7F7F9),
        tile: UIColor(rgb:0xFFF1ED),            // мягкий оттенок бренда
        navigation: UIColor(rgb:0xFF3D19),
        background: UIColor(rgb:0xFFFFFF),

        ems: UIColor(rgb:0xFF3D19),

        links: UIColor(rgb:0xFF3D19),


        namesAndAvatars: [
            UIColor(rgb:0xFF3D19),
            UIColor(rgb:0xFF6A4D),
            UIColor(rgb:0xFF8C42),
            UIColor(rgb:0xFFB347),
            UIColor(rgb:0x2C2C2E),
            UIColor(rgb:0x48484A),
            UIColor(rgb:0x636366),
            UIColor(rgb:0xFF3D19)
        ]
    )
    
    public static var uiKit = ColorsUIKit(values: values)
    public static var swiftUI = ColorSwiftUI(values: values)
}





