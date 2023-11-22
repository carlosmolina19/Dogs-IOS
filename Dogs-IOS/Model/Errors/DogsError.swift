import Foundation

enum DogsError: Error {
    case invalidFormat
    case deallocated
    case genericError(Error)
}
