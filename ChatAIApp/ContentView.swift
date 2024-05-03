//
//  ContentView.swift
//  ChatAIApp
//
//  Created by itkhld on 2.05.2024.
//

import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject {
    init() {}
    
    private var OpenAI: OpenAISwift?
    
    func setup() {
        // You can paste the token you copy in the "TOKEN"
        // OpenAI = OpenAISwift(authToken: "TOKEN")
        }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        OpenAI?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case.success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(models, id: \.self) { string in
                Text(string)
            }
            
            Spacer()
            
            HStack {
                TextField("Type here...", text: $text)
                Button("Send") {
                    send()
                }
            }
        }
        .onAppear {
            viewModel.setup()
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: "+response)
                self.text = ""
            }
        }
    }
}

#Preview {
    ContentView()
}
