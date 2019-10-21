//
//
import Foundation

public let HyberLogger = HyberSK.hyberLog

public extension HyberSK {

    static let hyberLog : Logger = {
        let log = Logger()
        return log
    }()

}

private let benchmarker = Benchmarker()

public enum Level {
    
    case trace, debug, info, warning, error
    
    var description: String {
        
        switch self {
        case .trace: return "✅ SPTrace"
        case .debug: return "🐞SPDEBUG"
        case .info: return "❗️SPInfo"
        case .warning: return "⚠️ SPWarinig"
        case .error: return "❌ SPERROR"
        }
    
    }
}

extension Level: Comparable {}

public func ==(x: Level, y: Level) -> Bool {
    return x.hashValue == y.hashValue
}

public func <(x: Level, y: Level) -> Bool {
    return x.hashValue < y.hashValue
}

open class Logger {
    
    public var enabled: Bool = true
    
    public var formatter: Formatter {
        didSet { formatter.logger = self }
    }
    
    public var theme: Theme?
    
    public var minLevel: Level
    
    public var format: String {
        return formatter.description
    }
    
    public var colors: String {
        return theme?.description ?? ""
    }
    
    private let queue = DispatchQueue(label: "SP.log")
    
   
    public init(formatter: Formatter = .default, theme: Theme? = nil, minLevel: Level = .trace) {
        self.formatter = formatter
        self.theme = theme
        self.minLevel = minLevel
        
        formatter.logger = self
    }
    
    open func trace(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.trace, items, separator, terminator, file, line, column, function)
    }
    
    open func debug(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.debug, items, separator, terminator, file, line, column, function)
    }
    
    open func info(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.info, items, separator, terminator, file, line, column, function)
    }
    
    open func warning(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.warning, items, separator, terminator, file, line, column, function)
    }
    
    open func error(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.error, items, separator, terminator, file, line, column, function)
    }
    
    private func log(_ level: Level, _ items: [Any], _ separator: String, _ terminator: String, _ file: String, _ line: Int, _ column: Int, _ function: String) {
        guard enabled && level >= minLevel else { return }
        
        let date = Date()
        
        let result = formatter.format(
            level: level,
            items: items,
            separator: separator,
            terminator: terminator,
            file: file,
            line: line,
            column: column,
            function: function,
            date: date
        )
        
        queue.async {
            Swift.print(result, separator: "", terminator: "")
        }
    }
    
    public func measure(_ description: String? = nil, iterations n: Int = 10, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function, block: () -> Void) {
        guard enabled && .debug >= minLevel else { return }
        
        let measure = benchmarker.measure(description, iterations: n, block: block)
        
        let date = Date()
        
        let result = formatter.format(
            description: measure.description,
            average: measure.average,
            relativeStandardDeviation: measure.relativeStandardDeviation,
            file: file,
            line: line,
            column: column,
            function: function,
            date: date
        )
        
        queue.async {
            Swift.print(result)
        }
    }
}
