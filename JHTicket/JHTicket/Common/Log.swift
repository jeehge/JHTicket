//
//  Log.swift
//  JHTicket
//
//  Created by JH on 2021/09/05.
//

// success ✅ ☘️ 🍏
// fail 💣 ❌ 🔥🍎
enum Log {
    static func debug(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("✅ [\(fileName)] \(functionName)(\(line)): \(message)")
        #endif
    }
    
    static func error(_ message: Any,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("❌ [\(fileName)] \(functionName)(\(line)): \(message)")
    }
}
