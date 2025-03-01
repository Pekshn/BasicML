//
//  ContentView.swift
//  BasicML
//
//  Created by Petar  on 1.3.25..
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    let images = ["1", "2", "3", "4"]
    @State private var currentIndex = 0
    @State private var predictions: [String: Double] = [:]
    
    let model = try! MobileNetV2(configuration: MLModelConfiguration())
    
    var body: some View {
        VStack {
            Image(images[currentIndex])
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            HStack {
                Button("Previous") {
                    currentIndex -= 1
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == 0)
                
                Button("Next") {
                    currentIndex += 1
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == images.count - 1)
            }
            
            Button("Predict") {
                guard let uiImage = UIImage(named: images[currentIndex]) else { return }
                let resizedImage = uiImage.resize(to: CGSize(width: 224, height: 224))
                
                guard let buffer = resizedImage.toCVPixelBuffer() else { return }
                do {
                    let prediction = try model.prediction(image: buffer)
                    self.predictions = prediction.classLabelProbs
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            .buttonStyle(.borderedProminent)
            
            //Predictions
            PredictionsListView(predictions: $predictions)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
