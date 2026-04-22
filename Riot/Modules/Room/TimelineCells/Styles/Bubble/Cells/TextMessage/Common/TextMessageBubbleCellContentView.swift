//
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import UIKit
import Reusable

final class TextMessageBubbleCellContentView: UIView, NibLoadable {
    
    // MARK: - Properties
    
    var onTranslateTap: (() -> Void)?
    
    lazy var translateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.tintColor = ThemeService.shared().theme.colors.accent
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.addTarget(self, action: #selector(didTapTranslate), for: .touchUpInside)
        return button
    }()
    
    // MARK: Outlets
    
    @IBOutlet private(set) weak var bubbleBackgroundView: RoomMessageBubbleBackgroundView!
    
    @IBOutlet weak var bubbleBackgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleBackgroundViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet private(set) weak var textView: UITextView!
    
    // MARK: - Setup
    
    static func instantiate() -> TextMessageBubbleCellContentView {
        return TextMessageBubbleCellContentView.loadFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTranslateButton()
    }
    
    private func setupTranslateButton() {
        addSubview(translateButton)
        
        NSLayoutConstraint.activate([
            translateButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            translateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            translateButton.widthAnchor.constraint(equalToConstant: 24),
            translateButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func didTapTranslate() {
        onTranslateTap?()
    }
}
