//
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import UIKit

class TextMessageBaseBubbleCell: SizableBaseRoomCell, RoomCellURLPreviewDisplayable, RoomCellReactionsDisplayable, RoomCellThreadSummaryDisplayable, RoomCellReadReceiptsDisplayable, RoomCellReadMarkerDisplayable {
    
    // MARK: - Properties
    
    weak var textMessageContentView: TextMessageBubbleCellContentView?
    
    private var originalMessageText: String?
    
    override var messageTextView: UITextView! {
        get {
            return self.textMessageContentView?.textView
        }
        set { }
    }
    
    private var translationKey: String? {
        guard let text = originalMessageText?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return nil
        }
        return text
    }
    
    // MARK: - Overrides
    
    override func setupViews() {
        
        roomCellContentView?.backgroundColor = .clear
        
        roomCellContentView?.innerContentViewBottomContraint.constant = BubbleRoomCellLayoutConstants.innerContentViewMargins.bottom
        roomCellContentView?.userNameLabelBottomConstraint.constant = BubbleRoomCellLayoutConstants.senderNameLabelMargins.bottom

        let textMessageContentView = TextMessageBubbleCellContentView.instantiate()

        roomCellContentView?.innerContentView.vc_addSubViewMatchingParent(textMessageContentView)
        
        self.textMessageContentView = textMessageContentView
        
        textMessageContentView.onTranslateTap = { [weak self] in
            self?.handleTranslateTap()
        }
        
        super.setupViews()
        
        refreshTranslationContext()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        originalMessageText = nil
        textMessageContentView?.translateButton.isEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshTranslationContext()
    }
    
    override func setupMessageTextViewLongPressGesture() {
        // Do nothing, otherwise default setup prevent link tap
    }
    
    func setupTranslationButton(isIncoming: Bool) {
        textMessageContentView?.translateButton.isHidden = !isIncoming
    }
    
    private func refreshTranslationContext() {
        guard let currentText = textMessageContentView?.textView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !currentText.isEmpty else {
            return
        }
        
        originalMessageText = currentText
        applyStoredTranslationIfNeeded()
    }
    
    private func applyStoredTranslationIfNeeded() {
        guard let key = translationKey else { return }
        
        if let displayedText = MessageTranslationStore.shared.displayedText(for: key) {
            textMessageContentView?.textView.attributedText = NSAttributedString(string: displayedText)
        } else if let originalMessageText {
            textMessageContentView?.textView.attributedText = NSAttributedString(string: originalMessageText)
        }
    }
    
    private func handleTranslateTap() {
        refreshTranslationContext()
        
        guard let key = translationKey,
              let originalText = originalMessageText,
              !originalText.isEmpty else {
            return
        }
        
        if MessageTranslationStore.shared.hasTranslation(for: key) {
            MessageTranslationStore.shared.toggle(for: key)
            applyStoredTranslationIfNeeded()
            return
        }
        
        textMessageContentView?.translateButton.isEnabled = false
        
        TranslationService.shared.translateToPortuguese(text: originalText) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.textMessageContentView?.translateButton.isEnabled = true
                
                switch result {
                case .success(let translatedText):
                    MessageTranslationStore.shared.save(
                        key: key,
                        original: originalText,
                        translated: translatedText
                    )
                    self.applyStoredTranslationIfNeeded()

                case .failure(let error):
                    MXLog.error("Translation failed")
                }
            }
        }
    }
}

// MARK: - RoomCellTimestampDisplayable
extension TextMessageBaseBubbleCell: TimestampDisplayable {
    
    func addTimestampView(_ timestampView: UIView) {
        guard let messageBubbleBackgroundView = self.textMessageContentView?.bubbleBackgroundView else {
            return
        }
        messageBubbleBackgroundView.removeTimestampView()
        messageBubbleBackgroundView.addTimestampView(timestampView)
    }
    
    func removeTimestampView() {
        guard let messageBubbleBackgroundView = self.textMessageContentView?.bubbleBackgroundView else {
            return
        }
        messageBubbleBackgroundView.removeTimestampView()
    }
}
