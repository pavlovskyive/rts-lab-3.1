//
//  ContentView.swift
//  rts-lab-3
//
//  Created by Vsevolod Pavlovskyi on 16.05.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject
    var viewModel = FermatViewModel()
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                TextField("Enter number", text: $viewModel.input)
                    .numberStyle(style: .bordered)
                    .font(.title2)
                    .onAppear {
                        viewModel.onAppear()
                    }
                
                Text(result)
                    .numberStyle()
            }
            .padding()
        }
    }
    
    var result: String {
        viewModel.result
            .map(String.init)
            .joined(separator: " × ")
    }
    
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}

final public class FermatViewModel: ObservableObject {
    
    @Published var input = "1"
    @Published var result = [Int]()
    
    var cancellable = Set<AnyCancellable>()
    
    private var oldInput = ""
    
}

public extension FermatViewModel {
    
    func onAppear() {
        subscribeToNumber()
    }
    
}

private extension FermatViewModel {
    
    func compute(_ n: Int) -> [Int] {

        // If n <= 3 -> n is prime
        guard n > 3 else {
            return []
        }
        
        // If even -> divide by two and continue recursively.
        guard n % 2 != 0 else {
            var result = [2]
            
            let factorize = compute(Int(n / 2))
            
            guard factorize.count > 0 else {
                result.append(Int(n / 2))
                return result
            }
            
            result.append(contentsOf: factorize)
            
            return result
        }
        
        // Smallest number, which power 2 is more than given number.
        var x = Int(ceil(sqrt(Double(n))))

        while !perfectSquare(x * x - n) {
            x += 1
        }
        
        let y = Int(sqrt(Double(x * x - n)))
        let a = x - y
        let b = x + y
        
        var result = [Int]()
        
        // If number is divided not only by itself and "1", factorize recursively.
        if a != 1,
           b != 1 {
            let factorizedA = compute(a)
            let factorizedB = compute(b)
            
            // If a can be factorized -> append its products.
            // If not, append only a.
            result.append(contentsOf: factorizedA.count > 0 ? factorizedA : [a])
            result.append(contentsOf: factorizedB.count > 0 ? factorizedB : [b])
        }

        return result
    }
    
    func perfectSquare(_ number: Int) -> Bool {
        floor(sqrt(Double(number))) == sqrt(Double(number))
    }
    
}

private extension FermatViewModel {
    
    func subscribeToNumber() {
        $input
            .receive(on: RunLoop.main)
            .sink { [weak self] input in
                guard let self = self else {
                    return
                }
                
                let filtered = input.filter { "0123456789".contains($0) }
                if filtered != input {
                    self.input = filtered
                }
                
                if self.oldInput == input {
                    return
                }
                
                self.oldInput = input
                
                guard let number = Int(self.input) else {
                    print("Input cannot be parsed to Int")
                    return
                }
                
                self.result = self.compute(number).sorted()
            }
            .store(in: &cancellable)
    }
    
}
