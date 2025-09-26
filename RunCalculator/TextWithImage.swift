//
//  TextWithImage.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/5/23.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder fileprivate func onCondition<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

struct DecorativeImageHeight: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    var decorativeImageHeight: CGFloat? {
        get { self[DecorativeImageHeight.self] }
        set { self[DecorativeImageHeight.self] = newValue }
    }
}

struct DecorativeImageWidth: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    var decorativeImageWidth: CGFloat? {
        get { self[DecorativeImageWidth.self] }
        set { self[DecorativeImageWidth.self] = newValue }
    }
}

extension View {
    func decorativeImageHeight(_ height: CGFloat?) -> some View {
        environment(\.decorativeImageHeight, height)
    }
    
    func decorativeImageWidth(_ width: CGFloat?) -> some View {
        environment(\.decorativeImageWidth, width)
    }
}

struct TextWithImage: View {
    var text: Text
    var imageName: String
    
    @Environment(\.decorativeImageWidth)
    var imageWidth: CGFloat?
    
    @Environment(\.decorativeImageHeight)
    var imageHeight: CGFloat?
    
    init(_ resource: LocalizedStringResource, image imageName: String = "arrow.up", placement: Alignment = .leading) {
        self.text = Text(resource)
        self.imageName = imageName
        self.imagePlacement = placement
    }
    
    init<S>(_ content: S, image imageName: String = "arrow.up", placement: Alignment = .leading) where S : StringProtocol {
        self.text = Text(content)
        self.imageName = imageName
        self.imagePlacement = placement
    }
    
    init(_ attributedContent: AttributedString, image imageName: String = "arrow.up", placement: Alignment = .leading) {
        self.text = Text(attributedContent)
        self.imageName = imageName
        self.imagePlacement = placement
    }
    
    init<F>(
        _ input: F.FormatInput,
        format: F,
        image imageName: String = "arrow.up",
        placement: Alignment = .leading
    ) where F : FormatStyle, F.FormatInput : Equatable, F.FormatOutput == String {
        self.text = Text(input, format: format)
        self.imageName = imageName
        self.imagePlacement = placement
    }
    
    var imagePlacement: Alignment = .leading
    
    private var image: Image {
        Image(systemName: imageName)
    }
    
    var body: some View {
        let image = image
            .onCondition({
                (imageHeight ?? 0) > 0
            }(), transform: { image in
                image
                    .frame(height: imageHeight)
            })
            .onCondition({
                (imageWidth ?? 0) > 0
            }(), transform: { image in
                image
                    .frame(width: imageWidth)
            })
        
        HStack(spacing: 0) {
            switch imagePlacement {
            case .trailing:
                text
                image
            default:
                image
                text
            }
        }
    }
}

struct TextWithImagePreview: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            TextWithImage("Up", image: "arrow.up")
            TextWithImage("Down", image: "arrow.down")
            TextWithImage("Left", image: "arrow.left")
            TextWithImage("Right", image: "arrow.right")
            TextWithImage("Right", image: "arrow.right", placement: .trailing)
        }
        .decorativeImageWidth(30)
    }
}
