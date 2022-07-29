//
//  PhotosPickerViewModel.swift
//  PhotosPicker
//
//  Created by Carlos Silva on 29/07/2022.
//

import Foundation
import SwiftUI
import PhotosUI


@MainActor  class ReportViewModel: ObservableObject {
    enum ImageState {
        case empty, loading(Progress), success(UIImage), failure(Error)
    }
    
    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    if let image = UIImage(data: data) {
                        self.imageState = .success(image)
                    } else {
                        self.imageState = .empty
                    }
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
               
            }
        }
    }
}
