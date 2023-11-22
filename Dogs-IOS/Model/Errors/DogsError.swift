import Foundation

enum DogsError: Error {
    case invalidFormat
    case genericError(Error)
}
