//
//  NWTextViewCoordinator.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import SwiftUI
import UIKit

public final class NWTextViewCoordinator: NSObject, UITextViewDelegate {
    @Binding private var text: String
    @Binding private var errorMessage: String?
    @Binding private var isEditing: Bool
    private let placeholder: String
    
    public init(
        text: Binding<String>,
        errorMessage: Binding<String?>,
        isEditing: Binding<Bool>,
        placeholder: String
    ) {
        self._text = text
        self._errorMessage = errorMessage
        self._isEditing = isEditing
        self.placeholder = placeholder
        super.init()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
        
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = UIColor(DS.Colors.Text.netural)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
        
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor(DS.Colors.Neutral.gray400)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text != placeholder {
            text = textView.text
        } else {
            text = ""
        }
        
        textView.invalidateIntrinsicContentSize()
        DispatchQueue.main.async {
            textView.invalidateIntrinsicContentSize()
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        if textView.text == placeholder && !text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor(DS.Colors.Text.netural)
        }
        return true
    }
}
