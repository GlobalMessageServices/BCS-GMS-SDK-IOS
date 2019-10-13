//
//

public class Themes {}

public class Theme: Themes {
    internal var colors: [Level: String]
    
    internal var description: String {
        return colors.keys.sorted().map {
            $0.description.withColor(colors[$0]!)
        }.joined(separator: " ")
    }
    
    
    public init(trace: String, debug: String, info: String, warning: String, error: String) {
        self.colors = [
            .trace:   Theme.formatHex(trace),
            .debug:   Theme.formatHex(debug),
            .info:    Theme.formatHex(info),
            .warning: Theme.formatHex(warning),
            .error:   Theme.formatHex(error)
        ]
    }
    
        private static func formatHex(_ hex: String) -> String {
        let scanner = Scanner(string: hex)
        var hex: UInt32 = 0
        
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hex)
        
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0xFF00) >> 8
        let b = (hex & 0xFF)
        
        return [r, g, b].map({ String($0) }).joined(separator: ",")
    }
}


