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
        dataService.passthroughPublisher
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
    
//    @Published var basicPublisher: String = ""
    let currentValuePublisher = CurrentValueSubject<String, Error>("")
    let passthroughPublisher = PassthroughSubject<String, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.currentValuePublisher.send("Text \(i)")
                self.passthroughPublisher.send("Text \(i)")
            }
        }
        
        
    }
}
