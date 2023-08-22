//
//  EmployeeListViewModelTests.swift
//  SquareTakeHome
//
//
//
//

import XCTest
import Combine
@testable import SquareTakeHome

class EmployeeListViewModelTests: XCTestCase {
    private let mockEnvironment: SquareTakeHomeEnvironmentMock = SquareTakeHomeEnvironmentMock()
    private let mockCoordinator = EmployeeListCoordinator(parentCoordinator: nil,
                                                          navigationController: UINavigationController())
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockEnvironment.reset()
        cancelBag = Set<AnyCancellable>()
    }
    
    // MARK: Online
    func testRefreshEmployees() {
        let mockEmployees: [Employee] = ModelMockData.makeMockEmployees(count: 10)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(EmployeesRequests.EmployeeList.Response(employees: mockEmployees))
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.refreshBegin.send(())
        
        XCTAssertTrue(viewModel.output.isLoading)
        
        viewModel.input.refresh.send(())
        
        let expectedRequest = EmployeesRequests.EmployeeList()
        XCTAssertFalse(viewModel.output.isLoading)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertTrue(mockEnvironment.mockApi.mockAPIRequestsCalled.contains { $0.path == expectedRequest.path })
        XCTAssertEqual(viewModel.output.employees, mockEmployees)
    }
    
    func testRefreshEmployeesServerError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.serverError)
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.serverError.message)
    }
    
    func testRefreshEmployeesEmptyError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(EmployeesRequests.EmployeeList.Response(employees: []))
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.serverError.message)
    }
    
    func testRefreshEmployeesLostConnectionError() {
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.lostConnection)
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 1)
        XCTAssertEqual(viewModel.output.error, APIError.lostConnection.message)
    }
    
    func testRefreshEmployeesOfflineError() {
        mockEnvironment.mockApi.mockIsConnectedToInternet = false
        mockEnvironment.mockApi.mockAPIResponses = [
            .failure(.lostConnection)
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.refresh.send(())
        
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
        XCTAssertEqual(viewModel.output.error, APIError.offline.message)
    }
    
    func testViewDidLoadShowsErrorIfOffline() {
        mockEnvironment.mockApi.mockIsConnectedToInternet = false
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(viewModel.output.employees.isEmpty)
        
        viewModel.input.viewDidLoad.send(())
        
        XCTAssertEqual(viewModel.output.error, APIError.offline.message)
        XCTAssertEqual(mockEnvironment.mockApi.mockAPIRequestsCalled.count, 0)
    }
    
    func testRefreshEmployeesImagesArePrefetched() {
        let mockEmployees: [Employee] = ModelMockData.makeMockEmployees(count: 20)
        mockEnvironment.mockApi.mockAPIResponses = [
            .success(EmployeesRequests.EmployeeList.Response(employees: mockEmployees))
        ]
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        
        XCTAssertTrue(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs.isEmpty)
        
        viewModel.input.refresh.send(())
        
        // prefetches only the first 10 images
        let prefetchImageURLs: [URL] = Array(mockEmployees.prefix(upTo: 10)).compactMap { $0.photoUrlSmall }
        XCTAssertEqual(mockEnvironment.mockApi.mockImageManager.mockPrefetchTaskURLs, prefetchImageURLs)
    }
    
    // MARK: TabBarItem
    func testTapTabBarItemDoesScrollToTop() {
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        var scrollToTopCount = 0
        viewModel.input.isTopOfPage = false
        viewModel.input.isScrolling = false
        
        viewModel.output.scrollToTop
            .sink { _ in
                scrollToTopCount += 1
            }
            .store(in: &cancelBag)
        
        mockCoordinator.tabBarItemTappedWhileDisplayed.send(())
        
        XCTAssertEqual(scrollToTopCount, 1)
    }
    
    func testTapTabBarItemDoesNotScrollsToTopWhileScrolling() {
        let viewModel = EmployeeListViewModel(environment: mockEnvironment,
                                              coordinator: mockCoordinator)
        viewModel.input.isTopOfPage = false
        viewModel.input.isScrolling = true
        
        viewModel.output.scrollToTop
            .sink { _ in
                XCTFail("scrollToTop called while scrolling")
            }
            .store(in: &cancelBag)
        
        mockCoordinator.tabBarItemTappedWhileDisplayed.send(())
    }
}
