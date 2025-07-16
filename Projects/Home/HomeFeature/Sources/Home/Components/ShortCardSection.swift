//
//  HomeView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ShortCardSection: View {
    @Binding var currentPage: Int
    @Binding var selectedDate: Date
    let cards: [VacationCardItem]
    var onCardTapped: ((VacationCardType) -> Void)? = nil
    var onDateButtonTapped: (() -> Void)? = nil
    let onAddTapped: (VacationCardType) -> Void
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("1년까지의 휴가를 모두 모아봤어요.")
                    .font(.heading5)
                Spacer()
            }
          
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                ForEach(cards.indices, id: \.self) { idx in
                    let cardData = cards[idx]
                    VacationCardView(
                        vactionType: cardData.type,
                        variableText: cardData.dateString,
                        attributedText: cardData.attributedText,
                        onTap: {
                            onAddTapped(cardData.type)
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
    
        PageControl(currentPage: $currentPage, numberOfPages: (cards.count/4))
            .padding(.top, 16)
            .padding(.bottom, 24)
            .frame(alignment: .center)
            .frame(maxWidth: .infinity)
    }
} 
