import Foundation

final class MessageTranslationStore {
    static let shared = MessageTranslationStore()
    
    struct Item {
        let originalText: String
        let translatedText: String
        var isShowingTranslation: Bool
    }
    
    private var storage: [String: Item] = [:]
    
    private init() {}
    
    func hasTranslation(for key: String) -> Bool {
        storage[key] != nil
    }
    
    func save(key: String, original: String, translated: String) {
        storage[key] = Item(
            originalText: original,
            translatedText: translated,
            isShowingTranslation: true
        )
    }
    
    func toggle(for key: String) {
        guard var item = storage[key] else { return }
        item.isShowingTranslation.toggle()
        storage[key] = item
    }
    
    func displayedText(for key: String) -> String? {
        guard let item = storage[key] else { return nil }
        return item.isShowingTranslation ? item.translatedText : item.originalText
    }
}
