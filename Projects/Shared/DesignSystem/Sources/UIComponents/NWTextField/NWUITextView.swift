//
//  NWTextView.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import UIKit

public final class NWUITextView: UITextView {
    private var needsContentSizeUpdate = false
    
    public override var intrinsicContentSize: CGSize {
        let size = sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        let height = max(24, size.height)
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateContentSizeIfNeeded()
    }
    
    public override var text: String? {
        didSet {
            scheduleContentSizeUpdate()
        }
    }
    
    public override var font: UIFont? {
        didSet {
            scheduleContentSizeUpdate()
        }
    }
    
    // MARK: - Private Methods
    private func scheduleContentSizeUpdate() {
        guard !needsContentSizeUpdate else { return }
        needsContentSizeUpdate = true
        
        DispatchQueue.main.async { [weak self] in
            self?.updateContentSizeIfNeeded()
        }
    }
    
    private func updateContentSizeIfNeeded() {
        guard needsContentSizeUpdate else { return }
        needsContentSizeUpdate = false
        invalidateIntrinsicContentSize()
    }
}
