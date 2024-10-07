import Foundation

enum CalculationError: Error {
    case invalidOperation
    case invalidToken
}

func evaluate(tokens: [String]) throws -> Float {
    func precedence(_ sign: Character) -> Int {
        if sign == "+" || sign == "-" {
            return 1
        }
        if sign == "*" || sign == "/" {
            return 2
        }
        return 0
    }
    
    func applyOperator(signs: inout [Character], values: inout [Float]) throws -> Void {
        guard let sign = signs.popLast(),
              let right = values.popLast(),
              let left = values.popLast()
        else {
            return
        }
        
        if sign == "+" {
            values.append(left + right)
        } else if sign == "-" {
            values.append(left - right)
        } else if sign == "*" {
            values.append(left * right)
        } else {
            if right == 0 {
                throw CalculationError.invalidOperation
            }
            values.append(left / right)
        }
    }
    
    var values: [Float] = []
    var signs: [Character] = []
    
    for token in tokens {
        if token == "(" {
            signs.append(Character(token))
        } else if token == ")" {
            while signs.last != "(" {
                try applyOperator(signs: &signs, values: &values)
            }
            _ = signs.popLast()
        } else if let tokenChar = token.first, ["*", "/", "+", "-"].contains(tokenChar) {
            while let lastSign = signs.last, precedence(lastSign) >= precedence(tokenChar) {
                try applyOperator(signs: &signs, values: &values)
            }
            signs.append(tokenChar)
        } else if let value = Float(token) {
            values.append(value)
        } else {
            throw CalculationError.invalidToken
        }
    }
    
    while signs.count > 0 {
        try applyOperator(signs: &signs, values: &values)
    }
    
    guard let result = values.first else {
        throw CalculationError.invalidToken
    }
    
    return result
}
