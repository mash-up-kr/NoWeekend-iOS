// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
public enum JSONFiles {
  public enum Fire: LottieFileRepresentable {
    private static let _document = JSONDocument(path: "fire.json")
    public static let name = "fire.json"
    public static let assets: [[String: Any]] = _document["assets"]
    public static let ddd: Int = _document["ddd"]
    public static let fr: Int = _document["fr"]
    public static let h: Int = _document["h"]
    public static let ip: Int = _document["ip"]
    public static let layers: [[String: Any]] = _document["layers"]
    public static let markers: [[String: Any]] = _document["markers"]
    public static let nm: String = _document["nm"]
    public static let op: Int = _document["op"]
    public static let v: String = _document["v"]
    public static let w: Int = _document["w"]
  }
  public enum Loading: LottieFileRepresentable {
    private static let _document = JSONDocument(path: "loading.json")
    public static let name = "loading.json"
    public static let assets: [String] = _document["assets"]
    public static let ddd: Int = _document["ddd"]
    public static let fr: Int = _document["fr"]
    public static let h: Int = _document["h"]
    public static let ip: Int = _document["ip"]
    public static let layers: [[String: Any]] = _document["layers"]
    public static let markers: [String] = _document["markers"]
    public static let meta: [String: Any] = _document["meta"]
    public static let nm: String = _document["nm"]
    public static let op: Int = _document["op"]
    public static let v: String = _document["v"]
    public static let w: Int = _document["w"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func objectFromJSON<T>(at path: String) -> T {
  guard let url = Bundle.module.url(forResource: path, withExtension: nil),
    let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []),
    let result = json as? T else {
    fatalError("Unable to load JSON at path: \(path)")
  }
  return result
}

private struct JSONDocument {
  let data: [String: Any]

  init(path: String) {
    self.data = objectFromJSON(at: path)
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}
