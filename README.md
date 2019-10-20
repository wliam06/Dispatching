# Dispatching

GCD (Grand Central Dispatch) is a framework to managing task with concurrent operations provided by Apple. In GCD, this system works with a number of tasks into dispatch queues which will in turn run on multiple threads and will be managed by system. A queue is a block of code that can be run [sync](https://en.wikipedia.org/wiki/Synchronization_(computer_science)) or [async](https://en.wikipedia.org/wiki/Asynchrony_(computer_programming)) in either the main or background thread.

To perform multiple batch `async tasks in the background `, or `receive` a notification once they completed we can used [Dispatch Group](https://developer.apple.com/documentation/dispatch/dispatchgroup).

We will use the [Dispatch Semaphore](https://developer.apple.com/documentation/dispatch/dispatchsemaphore) to limit of concurrent simultaneous task in executing a queue.
