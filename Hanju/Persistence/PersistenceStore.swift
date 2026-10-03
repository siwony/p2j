import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class PersistenceStore {
    private(set) var container: ModelContainer?
    private(set) var failureMessage: String?

    func open() {
        guard container == nil else { return }
        do {
            container = try Self.makeContainer()
            failureMessage = nil
        } catch {
            failureMessage = "저장된 데이터를 열지 못했어요. 데이터를 지우지 않고 다시 시도할 수 있어요."
        }
    }

    static func makeContainer(
        inMemory: Bool = false,
        storeURL: URL? = nil
    ) throws -> ModelContainer {
        let schema = Schema(versionedSchema: HanjuSchemaV1.self)
        let configuration: ModelConfiguration
        if let storeURL {
            configuration = ModelConfiguration(
                schema: schema, url: storeURL, cloudKitDatabase: .none
            )
        } else {
            configuration = ModelConfiguration(
                schema: schema, isStoredInMemoryOnly: inMemory, cloudKitDatabase: .none
            )
        }
        let container = try ModelContainer(for: schema, configurations: [configuration])
        container.mainContext.autosaveEnabled = false
        return container
    }
}
