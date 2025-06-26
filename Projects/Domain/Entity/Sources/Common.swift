import Foundation

// MARK: - Network Error
public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(String)
    case encodingError(String)
    case serverError(String)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case noInternetConnection
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError(let message):
            return "데이터 변환 오류: \(message)"
        case .encodingError(let message):
            return "데이터 인코딩 오류: \(message)"
        case .serverError(let message):
            return "서버 오류: \(message)"
        case .unauthorized:
            return "인증이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "리소스를 찾을 수 없습니다."
        case .timeout:
            return "요청 시간을 초과했습니다."
        case .noInternetConnection:
            return "인터넷 연결을 확인해주세요."
        }
    }
}

// MARK: - Storage Error
public enum StorageError: Error, LocalizedError {
    case keyNotFound
    case saveFailed(String)
    case loadFailed(String)
    case deleteFailed(String)
    case corruptedData
    
    public var errorDescription: String? {
        switch self {
        case .keyNotFound:
            return "키를 찾을 수 없습니다."
        case .saveFailed(let message):
            return "저장 실패: \(message)"
        case .loadFailed(let message):
            return "로드 실패: \(message)"
        case .deleteFailed(let message):
            return "삭제 실패: \(message)"
        case .corruptedData:
            return "손상된 데이터입니다."
        }
    }
}

// MARK: - Repository Error
public enum RepositoryError: Error, LocalizedError {
    case dataNotFound
    case invalidData
    case networkFailure(NetworkError)
    case storageFailure(StorageError)
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "데이터를 찾을 수 없습니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .networkFailure(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .storageFailure(let error):
            return "저장소 오류: \(error.localizedDescription)"
        case .unknown(let message):
            return "알 수 없는 오류: \(message)"
        }
    }
}

// MARK: - Result Extensions
public extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var value: Success? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
} 