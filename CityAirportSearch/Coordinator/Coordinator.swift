import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func add(coordinator: Coordinator) -> Void {
        childCoordinators.append(coordinator)
    }
    func remove(coordinator: Coordinator) -> Void {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
