import UIKit

public enum CounterMode {
    case descending
    case ascending
    case standard
}

class TextCounterLabel: UILabel, UITextViewDelegate {

    var counterMode = CounterMode.standard
    var counterMaxLength: Int = 10 {
        didSet {
            updateCounter(contentLength: textView.text.count)
        }
    }
    var textView: UITextView! {
        didSet {
            textView.delegate = self
            updateCounter(contentLength: textView.text.count)
        }
    }
    var counterTextColor: UIColor = .black
    var counterErrorTextColor: UIColor = .red
    
    private func updateCounter(contentLength: Int) {
        switch counterMode {
        case .descending:
            text = "\(counterMaxLength - contentLength)"
        case .ascending:
            text = "\(contentLength)"
        case .standard:
            text = "\(contentLength) / \(counterMaxLength)"
        }
        if contentLength > counterMaxLength {
            textColor = counterErrorTextColor
        } else {
            textColor = counterTextColor
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updateCounter(contentLength: textView.text.count)
    }
    
}

