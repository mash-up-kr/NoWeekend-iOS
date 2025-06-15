//
//  LottieView.swift
//  DesignSystem
//
//  Created by 김나희 on 6/16/25.
//

import Foundation
import SwiftUI
import Lottie

public protocol LottieFileRepresentable {
    static var name: String { get }
}

public struct LottieView: UIViewRepresentable {
    let type: LottieFileRepresentable.Type
    let loopMode: LottieLoopMode
    @Binding var isPlaying: Bool

    /**
     - Parameters:
        - type: 자동 생성한 Lottie 리소스 타입(예: `JSONFiles.Loading.self`)
        - loopMode: 애니메이션 반복 모드 (기본값: .loop)
        - isPlaying: 애니메이션 재생 여부 바인딩 (기본값: true)
     */
    public init(
        type: LottieFileRepresentable.Type,
        loopMode: LottieLoopMode = .loop, isPlaying: Binding<Bool> = .constant(true)) {
        self.type = type
        self.loopMode = loopMode
        self._isPlaying = isPlaying
    }

    public func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let animationView = LottieAnimationView(name: type.name, bundle: .module)
        
        animationView.loopMode = loopMode
        if isPlaying { animationView.play() }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView else {
            return
        }
        if isPlaying {
            animationView.play()
        } else {
            animationView.pause()
        }
    }
}
