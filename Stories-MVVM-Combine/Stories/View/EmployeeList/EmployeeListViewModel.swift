//
//  EmployeeListViewModel.swift
//  Stories
//
//
//

import Foundation
import Combine

protocol EmployeeListViewModelContract: StoriesViewModel
where Input == EmployeeListViewModelInput, Output == EmployeeListViewModelOutput {
    var imageManager: ImageManagerContract { get }
}

// MARK: Input
class EmployeeListViewModelInput: ObservableObject {
    /// The view did load.
    var viewDidLoad = PassthroughSubject<Void, Never>()
    /// The employee list is in the loading state and ready to refresh the data.
    var refresh = PassthroughSubject<Void, Never>()
    /// The user performs an action which intends to refresh the employee list.
    var refreshBegin = PassthroughSubject<Void, Never>()
    /// The employee list is currently scrolling automatically.
    @Published var isScrolling: Bool = false
    /// The user is at the top of the employee list.
    @Published var isTopOfPage: Bool = true
    /// A cell at a row index was tapped in the employee list.
    var cellTapped = PassthroughSubject<Int, Never>()
}

// MARK: Output
class EmployeeListViewModelOutput: ObservableObject {
    /// The employees list to display.
    @Published fileprivate(set) var employees: [Employee] = []
    /// Show the employee list in a loading and refreshing state.
    @Published fileprivate(set) var isLoading: Bool = false
    /// Show an error message to display over the employee list.
    @Published fileprivate(set) var error: String = ""
    /// Scroll the employee list to the top automatically.
    private(set) var scrollToTop = PassthroughSubject<Void, Never>()
}

// MARK: ViewModel
class EmployeeListViewModel: EmployeeListViewModelContract, ObservableObject {
    @Published var input = EmployeeListViewModelInput()
    @Published var output = EmployeeListViewModelOutput()
    private let coordinator: EmployeeListCoordinator
    private var cancelBag = Set<AnyCancellable>()
    
    private let environment: EnvironmentContract
    var imageManager: ImageManagerContract {
        return environment.api.imageManager
    }
    
    init(environment: EnvironmentContract,
         coordinator: EmployeeListCoordinator) {
        self.environment = environment
        self.coordinator = coordinator
        
        // bind inputs and outputs
        setViewDidLoad()
        setRefresh()
        setCellTapped()
        setTabBarItemTappedWhileDisplayed()
    }
    
    private func setViewDidLoad() {
        input.viewDidLoad.sink { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.environment.api.isConnectedToInternet() {
                strongSelf.output.error = APIError.offline.message
                strongSelf.output.isLoading = false
            } else {
                strongSelf.input.refreshBegin.send(())
            }
        }
        .store(in: &cancelBag)
    }

    private func setRefresh() {
        input.refreshBegin.sink { [weak self] refreshType in
            guard let strongSelf = self else { return }
            strongSelf.output.isLoading = true
        }
        .store(in: &cancelBag)

        // all animations should be completed after refreshBegin and before starting the refresh
        input.refresh
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                if !strongSelf.environment.api.isConnectedToInternet() {
                    strongSelf.output.error = APIError.offline.message
                    strongSelf.output.isLoading = false
                } else {
                    strongSelf.updateData()
                }
            }
            .store(in: &cancelBag)
    }

    private func updateData() {
        environment.api.get(request: EmployeesRequests.EmployeeList()) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard !data.employees.isEmpty else {
                    // if no employees were recieved, assume there is an issue with the API
                    // keep whatever the previous state of the employees list was, and send an error
                    strongSelf.output.error = APIError.serverError.message
                    break
                }

                let newEmployees = data.employees
                strongSelf.output.employees = newEmployees
                // prefetch the first 10 employee images required for the cells
                strongSelf.prefetchImages(employees: Array(newEmployees.prefix(10)))
            case .failure(let error):
                // keep whatever the previous state of the employees list was, and send an error
                strongSelf.output.error = error.message
            }
            strongSelf.output.isLoading = false
        }
    }

    private func prefetchImages(employees: [Employee]) {
        let prefetchImageURLs = employees.compactMap { $0.photoUrlSmall }
        environment.api.imageManager.prefetchImages(prefetchImageURLs, reset: true)
    }

    private func setCellTapped() {
        input.cellTapped.map { ($0, self.output.employees) }
            .sink { (row, employees) in
                // no op
            }
            .store(in: &cancelBag)
    }
    
    private func setTabBarItemTappedWhileDisplayed() {
        coordinator.tabBarItemTappedWhileDisplayed.map { ($0, self.input.isTopOfPage, self.input.isScrolling) }
            .filter { _, isTopOfPage, isScrolling in !isTopOfPage && !isScrolling }
            .sink { [weak self] _, _, _ in
                self?.output.scrollToTop.send(())
            }
            .store(in: &cancelBag)
    }
}

