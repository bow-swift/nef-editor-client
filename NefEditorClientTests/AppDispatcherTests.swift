import XCTest
import Bow
import BowEffects
import BowArch
@testable import NefEditorClient

class AppDispatcherTests: XCTestCase {
    
    func testAddDependency() {
        let id = UUID()
        let recipe = Recipe(id: id, title: "A", description: "B", dependencies: [])
        let updatedRecipe = Recipe(id: id, title: "A", description: "B", dependencies: [Dependency(repository: bow.name, url: bow.htmlUrl, requirement: sampleRequirements[0])])
        
        let appState = AppState(
            panelState: .catalog,
            editState: .notEditing,
            searchState: SearchState(loadingState: .initial, modalState: .noModal),
            catalog: Catalog(featured: CatalogSection(title: "1", items: []),
                             userCreated: CatalogSection(title: "2", items: [.regular(recipe)])),
            selectedItem: .regular(recipe))
        
        let expected = AppState(
            panelState: .catalog,
            editState: .notEditing,
            searchState: SearchState(loadingState: .initial, modalState: .noModal),
            catalog: Catalog(featured: CatalogSection(title: "1", items: []),
                             userCreated: CatalogSection(title: "2", items: [.regular(updatedRecipe)])),
            selectedItem: .regular(updatedRecipe))
        
        assert(dispatcher: addDependencyDispatcher,
               on: .dependencySelected(sampleRequirements[0], from: bow),
               initialState: appState,
               expectedState: expected)
    }
    
    func testAddDependencyAppDispatcher() {
        let id = UUID()
        let recipe = Recipe(id: id, title: "A", description: "B", dependencies: [])
        let updatedRecipe = Recipe(id: id, title: "A", description: "B", dependencies: [Dependency(repository: bow.name, url: bow.htmlUrl, requirement: sampleRequirements[0])])
        
        let appState = AppState(
            panelState: .catalog,
            editState: .notEditing,
            searchState: SearchState(loadingState: .initial, modalState: .noModal),
            catalog: Catalog(featured: CatalogSection(title: "1", items: []),
                             userCreated: CatalogSection(title: "2", items: [.regular(recipe)])),
            selectedItem: .regular(recipe))
        
        let expected = AppState(
            panelState: .catalog,
            editState: .notEditing,
            searchState: SearchState(loadingState: .initial, modalState: .noModal),
            catalog: Catalog(featured: CatalogSection(title: "1", items: []),
                             userCreated: CatalogSection(title: "2", items: [.regular(updatedRecipe)])),
            selectedItem: .regular(updatedRecipe))
        
        assert(dispatcher: appDispatcher,
               on: .searchAction(
                .repositoryDetailAction(
                    .dependencySelected(sampleRequirements[0], from: bow))),
               initialState: appState,
               expectedState: expected)
    }
    
    func assert<E, S: Equatable, I>(
        dispatcher: StateDispatcher<E, S, I>,
        on input: I,
        with environment: E,
        initialState: S,
        expectedState: S) {
        
        let actions = dispatcher.on(input)
        let finalState = actions.reduce(initialState) { state, next in
            try! next.map { action in
                action^.runS(state)^.value
            }^
            .provide(environment)
            .unsafeRunSync()
        }
        
        XCTAssertEqual(finalState, expectedState)
    }
    
    func assert<S: Equatable, I>(
        dispatcher: StateDispatcher<Any, S, I>,
        on input: I,
        initialState: S,
        expectedState: S) {
        
        assert(
            dispatcher: dispatcher,
            on: input,
            with: (),
            initialState: initialState,
            expectedState: expectedState)
    }
}
