//
//  ContentView.swift
//  BasicML
//
//  Created by Petar  on 1.3.25..
//

import SwiftUI
import CoreML
import PhotosUI

struct ContentView: View {
    
    @State private var isCameraSelected = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var predictions: [String: Double] = [:]
    @State private var uiImage: UIImage? = UIImage(named: "cat_118")!
    let model = try! CatsVsDogsImagesClassifier(configuration: MLModelConfiguration())
    
    var body: some View {
        VStack {
            
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            
            HStack {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Text("Select a Photo")
                }
                
                Button("Camera") {
                    isCameraSelected = true
                }
                .buttonStyle(.bordered)
            }
            
            Button("Predict") {
                guard let resizedImg = uiImage?.resize(to: CGSize(width: 299, height: 299)) else { return }
                guard let buffer = resizedImg.toCVPixelBuffer() else { return }
                do {
                    let prediction = try model.prediction(image: buffer)
                    predictions = prediction.targetProbability
                } catch {
                    print(error.localizedDescription)
                }
            }
            .buttonStyle(.borderedProminent)
            
            //Predictions
            PredictionsListView(predictions: $predictions)
        }
        .onChange(of: selectedPhotoItem, initial: false, {
            selectedPhotoItem?.loadTransferable(type: Data.self, completionHandler: { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        uiImage = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        })
        .fullScreenCover(isPresented: $isCameraSelected, content: {
            ImagePicker(image: $uiImage, sourceType: .camera)
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
