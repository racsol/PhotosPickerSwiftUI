//
//  ContentView.swift
//  PhotosPicker
//
//  Created by Carlos Silva on 29/07/2022.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @ObservedObject var viewModel: ReportViewModel

    init(){
        viewModel = ReportViewModel()
    }
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images){
                Label("Select Image", systemImage: "photo")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            switch viewModel.imageState {
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            case .loading:
                ProgressView()
            case .empty:
                Text("No image selected")
            case .failure(let error):
                Text("Error loading image \(error.localizedDescription)")
            }
        }
        .onAppear {
            PHPhotoLibrary.requestAuthorization({_ in })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
