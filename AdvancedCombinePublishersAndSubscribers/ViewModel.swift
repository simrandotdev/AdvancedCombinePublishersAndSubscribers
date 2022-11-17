//
//  ViewModel.swift
//  AdvancedCombinePublishersAndSubscribers
//
//  Created by Simran Preet Narang on 2022-11-17.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var data: [String] = []
    
    private let dataService = DataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$basicPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("❌ ERROR: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)

    }
}








//-------------------------------------------------------------------------//
// MARK: - Data Service

class DataService {
    
    @Published var basicPublisher: String = ""
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.basicPublisher = "Item \(i)"
            }
        }
        
        
    }
}
