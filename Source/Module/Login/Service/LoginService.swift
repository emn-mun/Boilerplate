import Foundation
import RxSwift

protocol LoginServiceProtocol {
    func loginUser(with email: String, password: String) -> Single<AuthenticationData?>
}

final class LoginService: LoginServiceProtocol {

    func loginUser(with email: String, password: String) -> Single<AuthenticationData?> {
        let params = ["email": email, "password": password]
        do {
          let request = try Request<AuthenticationData?>
            .post(at: "/test/authenticate",
                  input: Request.Input<[String: String]>.json(params),
                  output: Request.Output.json)

          let api = API(scheme: "https",
                        host: "p0jtvgfrj3.execute-api.eu-central-1.amazonaws.com")
            return try api.result(for: request)
                .catchErrorJustReturn(nil)
        } catch {
          return Single.error(NetworkError.apiRequestFailed)
        }
    }

}

enum NetworkError: Error {
  case apiRequestFailed
  
  var localizedDescription: String {
    switch self {
    case .apiRequestFailed:
      return "Request Failed"
    }
  }
}

