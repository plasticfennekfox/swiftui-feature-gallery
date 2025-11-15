//
//  UIViewControllerRepresentable.swift
//  Features
//
//  Created by Fuchs on 13/11/25.
//

import UIKit
import SwiftUI

/// Share sheet (UIActivityViewController)
struct ActivityVC: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) { }
}

/// UITextView с двусторонним биндингом
struct UIKitTextView: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UIKitTextView

        init(_ parent: UIKitTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.font = .preferredFont(forTextStyle: .body)
        tv.isScrollEnabled = true
        tv.backgroundColor = UIColor.secondarySystemBackground
        tv.layer.cornerRadius = 12
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.secondarySystemFill.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        tv.delegate = context.coordinator
        tv.text = text
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
}

/// UISlider с синком значения в SwiftUI
struct UIKitSlider: UIViewRepresentable {
    @Binding var value: Double

    class Coordinator: NSObject {
        var parent: UIKitSlider

        init(_ parent: UIKitSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(value)
        slider.tintColor = UIColor.systemBlue
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        let newValue = Float(value)
        if uiView.value != newValue {
            uiView.value = newValue
        }
    }
}
