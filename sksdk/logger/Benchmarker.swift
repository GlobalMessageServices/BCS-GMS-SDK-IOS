//
//

import Foundation

internal class Benchmarker {
    typealias Result = (
        description: String?,
        average: Double,
        relativeStandardDeviation: Double
    )
    
    
    func measure(_ description: String? = nil, iterations n: Int = 10, block: () -> Void) -> Result {
        precondition(n >= 1, "Iteration must be greater or equal to 1.")
        
        let durations = (0..<n).map { _ in duration { block() } }
        
        let average = self.average(durations)
        let standardDeviation = self.standardDeviation(average, durations: durations)
        let relativeStandardDeviation = standardDeviation * average * 100
        
        return (
            description: description,
            average: average,
            relativeStandardDeviation: relativeStandardDeviation
        )
    }
    
    private func duration(_ block: () -> Void) -> Double {
        let date = Date()
        
        block()
        
        return abs(date.timeIntervalSinceNow)
    }
    
    private func average(_ durations: [Double]) -> Double {
        return durations.reduce(0, +) / Double(durations.count)
    }
    
    private func standardDeviation(_ average: Double, durations: [Double]) -> Double {
        return durations.reduce(0) { sum, duration in
            return sum + pow(duration - average, 2)
        }
    }
}
