///
/// CircularSliderView.swift
/// How to create a Circular Slider in SwiftUI
///
/// Xcode version 14.0
/// Swift version 5
///
/// Created by Eric Callanan on 25 / September / 2022.
///
///
/// see more
/// https://swdevnotes.com/swift/2022/create-a-circular-slider-in-swiftui/
///

import SwiftUI

struct CircularSliderView<Content>: View where Content: View {
    @Binding var progress: Double {
        didSet {
            self.rotationAngle = .degrees(progressFraction * 360)
        }
    }
    
    @State private var rotationAngle = Angle(degrees: 0)
    private var minValue = 0.0
    private var maxValue = 1.0
    
    private let label: () -> Content
    
    init(value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1, trackWidth: Double = 25, @ViewBuilder label: @escaping () -> Content) {
        self._progress = progress
        self.label = label
        self.trackWidth = trackWidth
        
        self.minValue = Double(bounds.first ?? 0)
        self.maxValue = Double(bounds.last ?? 1)
        self.rotationAngle = Angle(degrees: progressFraction * 360.0)
    }
    
    private var progressFraction: Double {
        return ((progress - minValue) / (maxValue - minValue))
    }
    
    private func changeAngle(location: CGPoint) {
        // Create a Vector for the location (reversing the y-coordinate system on iOS)
        let vector = CGVector(dx: location.x, dy: -location.y)
        
        // Calculate the angle of the vector
        let angleRadians = atan2(vector.dx, vector.dy)
        
        // Convert the angle to a range from 0 to 360 (rather than having negative angles)
        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
        
        // Update slider progress value based on angle
        progress = ((positiveAngle / (2.0 * .pi)) * (maxValue - minValue)) + minValue
        rotationAngle = Angle(radians: positiveAngle)
    }
    
    var ticks: Bool = false
    
    /// The width of the slider track
    let trackWidth: Double

    
    var body: some View {
        
        GeometryReader { gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0) - trackWidth / 2
            
            ZStack {
                Circle()
                    .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9),
                            style: StrokeStyle(lineWidth: trackWidth))
                    .overlay() {
                        label()
                    }
                
                if ticks {
                    Circle()
                        .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.6),
                                style: StrokeStyle(lineWidth: trackWidth * 0.75,
                                                   dash: [2, (2 * .pi * radius)/24 - 2]))
                        .rotationEffect(Angle(degrees: -90))
                }
                
                Circle()
                    .trim(from: 0, to: progressFraction)
                    .stroke(Color(hue: 0.0, saturation: 0.5, brightness: 0.9),
                            style: StrokeStyle(lineWidth: trackWidth, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1 / trackWidth)
                    .frame(width: trackWidth, height: trackWidth)
                    .offset(y: -radius)
                    .rotationEffect(rotationAngle)
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged() { value in
                                changeAngle(location: value.location)
                            }
                    )
            }
            .position(x: gr.frame(in: .local).midX,
                      y: gr.frame(in: .local).midY)
            .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
            
            
            .onAppear {
                self.rotationAngle = Angle(degrees: progressFraction * 360.0)
            }
        }
    }
}


struct CircularSlider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularSliderView(value: .constant(10), in: 0...50, trackWidth: 30) {
                Text("\(10, specifier: "%.2f")")
                    .font(.system(size: 80, weight: .bold, design:.rounded))
            }
            .padding()
            CircularSliderView(value: .constant(10), in: 0...50, trackWidth: 20) {
                Text("\(10, specifier: "%.2f")")
                    .font(.system(size: 80, weight: .bold, design:.rounded))
            }
            .padding()
            CircularSliderView(value: .constant(10), in: 0...50) {
                Text("\(10, specifier: "%.2f")")
                    .font(.system(size: 80, weight: .bold, design:.rounded))
            }
            .padding()
        }
    }
}
