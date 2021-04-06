import Foundation
import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0)} ?? Observable<Element.Wrapped>.empty()
        }
    }
}

public extension Observable {
    func withLatestFrom<T, U, R>(_ other1: Observable<T>, _ other2: Observable<U>, selector: @escaping (Element, T, U) -> R) -> Observable<R> {
        return withLatestFrom(Observable<Any>.combineLatest(other1, other2)) { first, second in selector(first, second.0, second.1) }
    }
}

