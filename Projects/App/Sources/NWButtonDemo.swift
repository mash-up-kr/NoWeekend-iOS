//
//  NWButtonDemo.swift
//  App
//
//  Created by SiJongKim on 6/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct NWButtonDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // XL Size - Enabled
                NWButton.primary("Primary XL") { }
                NWButton.black("Black XL") { }
                NWButton.outline("Outline XL") { }
                
                // XL Size - Disabled
                NWButton.primary("Primary XL Disabled", isEnabled: false) { }
                NWButton.black("Black XL Disabled", isEnabled: false) { }
                NWButton.outline("Outline XL Disabled", isEnabled: false) { }
                
                // MD Size - Enabled
                NWButton.primary("Primary MD", size: .md) { }
                NWButton.black("Black MD", size: .md) { }
                NWButton.outline("Outline MD", size: .md) { }
                
                // MD Size - Disabled
                NWButton.primary("Primary MD Disabled", size: .md, isEnabled: false) { }
                NWButton.black("Black MD Disabled", size: .md, isEnabled: false) { }
                NWButton.outline("Outline MD Disabled", size: .md, isEnabled: false) { }
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    NWButtonDemo()
}
#endif
