import Foundation

extension Request {
    public struct Output<T> {
        public let contentType: String
        public let decode: (Data) throws -> T
        private init(contentType: String, decode: @escaping (Data) throws -> T) {
            self.contentType = contentType
            self.decode = decode
        }
    }
}

extension Request.Output where T : Decodable {
    public static var json: Request.Output<T> {
        return Request.Output<T>(contentType: "application/json") { data in
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw Error.invalidOutput(expectedType: T.self, data: data, underlyingError: error)
            }
        }
    }
}

extension Request.Output {
    public enum Error: Swift.Error {
        case invalidOutput(expectedType: Any.Type, data: Data, underlyingError: Swift.Error?)
    }
}
