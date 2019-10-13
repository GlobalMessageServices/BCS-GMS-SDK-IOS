//
//

public enum Component {
    case date(String)
    case message
    case level
    case file(fullPath: Bool, fileExtension: Bool)
    case line
    case column
    case function
    case location
    case block(() -> Any?)
}

public class Formatters {}

public class Formatter: Formatters {
    /// The formatter format.
    private var format: String
    
    /// The formatter components.
    private var components: [Component]
    
    /// The date formatter.
    fileprivate let dateFormatter = DateFormatter()
    
    /// The formatter logger.
    internal weak var logger: Logger!
    
    /// The formatter textual representation.
    internal var description: String {
        return String(format: format, arguments: components.map { (component: Component) -> CVarArg in
            return String(describing: component).uppercased()
        })
    }
    
    public convenience init(_ format: String, _ components: Component...) {
        self.init(format, components)
    }
    
    public init(_ format: String, _ components: [Component]) {
        self.format = format
        self.components = components
    }
    
    internal func format(level: Level, items: [Any], separator: String, terminator: String, file: String, line: Int, column: Int, function: String, date: Date) -> String {
        let arguments = components.map { (component: Component) -> CVarArg in
            switch component {
            case .date(let dateFormat):
                return format(date: date, dateFormat: dateFormat)
            case .file(let fullPath, let fileExtension):
                return format(file: file, fullPath: fullPath, fileExtension: fileExtension)
            case .function:
                return String(function)
            case .line:
                return String(line)
            case .column:
                return String(column)
            case .level:
                return format(level: level)
            case .message:
                return items.map({ String(describing: $0) }).joined(separator: separator)
            case .location:
                return format(file: file, line: line)
            case .block(let block):
                return block().flatMap({ String(describing: $0) }) ?? ""
            }
        }
        
        return String(format: format, arguments: arguments) + terminator
    }
    
    func format(description: String?, average: Double, relativeStandardDeviation: Double, file: String, line: Int, column: Int, function: String, date: Date) -> String {
        
        let arguments = components.map { (component: Component) -> CVarArg in
            switch component {
            case .date(let dateFormat):
                return format(date: date, dateFormat: dateFormat)
            case .file(let fullPath, let fileExtension):
                return format(file: file, fullPath: fullPath, fileExtension: fileExtension)
            case .function:
                return String(function)
            case .line:
                return String(line)
            case .column:
                return String(column)
            case .level:
                return format(description: description)
            case .message:
                return format(average: average, relativeStandardDeviation: relativeStandardDeviation)
            case .location:
                return format(file: file, line: line)
            case .block(let block):
                return block().flatMap({ String(describing: $0) }) ?? ""
            }
        }
        
        return String(format: format, arguments: arguments)
    }
}

private extension Formatter {

    func format(date: Date, dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    func format(file: String, fullPath: Bool, fileExtension: Bool) -> String {
        var file = file
        
        if !fullPath      { file = file.lastPathComponent }
        if !fileExtension { file = file.stringByDeletingPathExtension }
        
        return file
    }
    
    func format(file: String, line: Int) -> String {
        return [
            format(file: file, fullPath: false, fileExtension: true),
            String(line)
        ].joined(separator: ":")
    }
    
    func format(level: Level) -> String {
        let text = level.description
        
        if let color = logger.theme?.colors[level] {
            return text.withColor(color)
        }
        
        return text
    }
    
    func format(description: String?) -> String {
        var text = "MEASURE"
        
        if let color = logger.theme?.colors[.debug] {
            text = text.withColor(color)
        }
        
        if let description = description {
            text = "\(text) \(description)"
        }
        
        return text
    }
    
    func format(average: Double, relativeStandardDeviation: Double) -> String {
        let average = format(average: average)
        let relativeStandardDeviation = format(relativeStandardDeviation: relativeStandardDeviation)
        
        return "Time: \(average) sec (\(relativeStandardDeviation) STDEV)"
    }
    
    func format(average: Double) -> String {
        return String(format: "%.3f", average)
    }
    
    func format(durations: [Double]) -> String {
        var format = Array(repeating: "%.6f", count: durations.count).joined(separator: ", ")
        format = "[\(format)]"
        
        return String(format: format, arguments: durations.map{ $0 as CVarArg })
    }
    
    func format(standardDeviation: Double) -> String {
        return String(format: "%.6f", standardDeviation)
    }
    
    func format(relativeStandardDeviation: Double) -> String {
        return String(format: "%.3f%%", relativeStandardDeviation)
    }
}
