// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title DecentralizedTodoList
 * @dev A smart contract for managing personal to-do lists on the blockchain
 */
contract DecentralizedTodoList {
    // Task structure
    struct Task {
        uint256 id;
        string content;
        bool isCompleted;
        uint256 createdAt;
        uint256 updatedAt;
        uint256 completedAt;
        uint256 deadline;     // Optional deadline (0 if no deadline)
        uint8 priority;       // Priority level: 0 (none), 1 (low), 2 (medium), 3 (high)
        string category;      // Optional task category
    }

    // Mapping from user address to their task IDs
    mapping(address => uint256[]) private userTaskIds;
    
    // Mapping from user address and task ID to Task
    mapping(address => mapping(uint256 => Task)) private userTasks;
    
    // Mapping to track if a task ID exists for a user
    mapping(address => mapping(uint256 => bool)) private taskExists;
    
    // Counter to generate unique task IDs for each user
    mapping(address => uint256) private taskCounter;
    
    // Events
    event TaskCreated(address indexed user, uint256 indexed taskId, string content);
    event TaskUpdated(address indexed user, uint256 indexed taskId, string content);
    event TaskCompleted(address indexed user, uint256 indexed taskId);
    event TaskUncompleted(address indexed user, uint256 indexed taskId);
    event TaskDeleted(address indexed user, uint256 indexed taskId);
    event DeadlineSet(address indexed user, uint256 indexed taskId, uint256 deadline);
    event PrioritySet(address indexed user, uint256 indexed taskId, uint8 priority);
    event CategorySet(address indexed user, uint256 indexed taskId, string category);
    
    /**
     * @dev Create a new task
     * @param _content Content of the task
     * @param _deadline Optional deadline timestamp (0 if no deadline)
     * @param _priority Priority level: 0 (none), 1 (low), 2 (medium), 3 (high)
     * @param _category Optional task category
     * @return taskId The ID of the newly created task
     */
    function createTask(
        string memory _content, 
        uint256 _deadline, 
        uint8 _priority, 
        string memory _category
    ) public returns (uint256) {
        require(bytes(_content).length > 0, "Task content cannot be empty");
        require(_priority <= 3, "Priority must be between 0 and 3");
        
        // Generate unique task ID for the user
        uint256 taskId = taskCounter[msg.sender];
        taskCounter[msg.sender]++;
        
        // Create new task
        Task memory newTask = Task({
            id: taskId,
            content: _content,
            isCompleted: false,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            completedAt: 0,
            deadline: _deadline,
            priority: _priority,
            category: _category
        });
        
        // Store task
        userTasks[msg.sender][taskId] = newTask;
        userTaskIds[msg.sender].push(taskId);
        taskExists[msg.sender][taskId] = true;
        
        // Emit event
        emit TaskCreated(msg.sender, taskId, _content);
        
        if (_deadline > 0) {
            emit DeadlineSet(msg.sender, taskId, _deadline);
        }
        
        if (_priority > 0) {
            emit PrioritySet(msg.sender, taskId, _priority);
        }
        
        if (bytes(_category).length > 0) {
            emit CategorySet(msg.sender, taskId, _category);
        }
        
        return taskId;
    }
    
    /**
     * @dev Update the content of a task
     * @param _taskId ID of the task to update
     * @param _content New content for the task
     */
    function updateTaskContent(uint256 _taskId, string memory _content) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        require(bytes(_content).length > 0, "Task content cannot be empty");
        
        Task storage task = userTasks[msg.sender][_taskId];
        task.content = _content;
        task.updatedAt = block.timestamp;
        
        emit TaskUpdated(msg.sender, _taskId, _content);
    }
    
    /**
     * @dev Mark a task as completed
     * @param _taskId ID of the task to complete
     */
    function completeTask(uint256 _taskId) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        
        Task storage task = userTasks[msg.sender][_taskId];
        require(!task.isCompleted, "Task is already completed");
        
        task.isCompleted = true;
        task.completedAt = block.timestamp;
        task.updatedAt = block.timestamp;
        
        emit TaskCompleted(msg.sender, _taskId);
    }
    
    /**
     * @dev Mark a completed task as uncompleted
     * @param _taskId ID of the task to uncomplete
     */
    function uncompleteTask(uint256 _taskId) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        
        Task storage task = userTasks[msg.sender][_taskId];
        require(task.isCompleted, "Task is not completed");
        
        task.isCompleted = false;
        task.completedAt = 0;
        task.updatedAt = block.timestamp;
        
        emit TaskUncompleted(msg.sender, _taskId);
    }
    
    /**
     * @dev Delete a task
     * @param _taskId ID of the task to delete
     */
    function deleteTask(uint256 _taskId) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        
        // Mark task as non-existent
        taskExists[msg.sender][_taskId] = false;
        
        // Remove task ID from the array
        uint256[] storage taskIds = userTaskIds[msg.sender];
        for (uint i = 0; i < taskIds.length; i++) {
            if (taskIds[i] == _taskId) {
                // Replace with the last element and pop
                taskIds[i] = taskIds[taskIds.length - 1];
                taskIds.pop();
                break;
            }
        }
        
        emit TaskDeleted(msg.sender, _taskId);
    }
    
    /**
     * @dev Set or update a task's deadline
     * @param _taskId ID of the task
     * @param _deadline New deadline timestamp (0 to remove deadline)
     */
    function setDeadline(uint256 _taskId, uint256 _deadline) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        
        Task storage task = userTasks[msg.sender][_taskId];
        task.deadline = _deadline;
        task.updatedAt = block.timestamp;
        
        emit DeadlineSet(msg.sender, _taskId, _deadline);
    }
    
    /**
     * @dev Set or update a task's priority
     * @param _taskId ID of the task
     * @param _priority New priority level: 0 (none), 1 (low), 2 (medium), 3 (high)
     */
    function setPriority(uint256 _taskId, uint8 _priority) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        require(_priority <= 3, "Priority must be between 0 and 3");
        
        Task storage task = userTasks[msg.sender][_taskId];
        task.priority = _priority;
        task.updatedAt = block.timestamp;
        
        emit PrioritySet(msg.sender, _taskId, _priority);
    }
    
    /**
     * @dev Set or update a task's category
     * @param _taskId ID of the task
     * @param _category New category
     */
    function setCategory(uint256 _taskId, string memory _category) public {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        
        Task storage task = userTasks[msg.sender][_taskId];
        task.category = _category;
        task.updatedAt = block.timestamp;
        
        emit CategorySet(msg.sender, _taskId, _category);
    }
    
    /**
     * @dev Get a specific task
     * @param _taskId ID of the task
     * @return Task structure with all details
     */
    function getTask(uint256 _taskId) public view returns (Task memory) {
        require(taskExists[msg.sender][_taskId], "Task does not exist");
        return userTasks[msg.sender][_taskId];
    }
    
    /**
     * @dev Get all tasks for the calling user
     * @return Array of Task structures
     */
    function getAllTasks() public view returns (Task[] memory) {
        uint256[] memory taskIds = userTaskIds[msg.sender];
        Task[] memory tasks = new Task[](taskIds.length);
        
        uint256 resultIndex = 0;
        for (uint256 i = 0; i < taskIds.length; i++) {
            uint256 taskId = taskIds[i];
            if (taskExists[msg.sender][taskId]) {
                tasks[resultIndex] = userTasks[msg.sender][taskId];
                resultIndex++;
            }
        }
        
        // If there are deleted tasks, resize the array
        if (resultIndex < taskIds.length) {
            assembly {
                mstore(tasks, resultIndex)
            }
        }
        
        return tasks;
    }
    
    /**
     * @dev Get all active (non-completed) tasks for the calling user
     * @return Array of Task structures
     */
    function getActiveTasks() public view returns (Task[] memory) {
        Task[] memory allTasks = getAllTasks();
        uint256 activeCount = 0;
        
        // Count active tasks
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted) {
                activeCount++;
            }
        }
        
        // Create array for active tasks
        Task[] memory activeTasks = new Task[](activeCount);
        uint256 resultIndex = 0;
        
        // Fill active tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted) {
                activeTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return activeTasks;
    }
    
    /**
     * @dev Get all completed tasks for the calling user
     * @return Array of Task structures
     */
    function getCompletedTasks() public view returns (Task[] memory) {
        Task[] memory allTasks = getAllTasks();
        uint256 completedCount = 0;
        
        // Count completed tasks
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (allTasks[i].isCompleted) {
                completedCount++;
            }
        }
        
        // Create array for completed tasks
        Task[] memory completedTasks = new Task[](completedCount);
        uint256 resultIndex = 0;
        
        // Fill completed tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (allTasks[i].isCompleted) {
                completedTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return completedTasks;
    }
    
    /**
     * @dev Get tasks by category
     * @param _category Category to filter by
     * @return Array of Task structures
     */
    function getTasksByCategory(string memory _category) public view returns (Task[] memory) {
        Task[] memory allTasks = getAllTasks();
        uint256 categoryCount = 0;
        
        // Count tasks in the category
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (keccak256(bytes(allTasks[i].category)) == keccak256(bytes(_category))) {
                categoryCount++;
            }
        }
        
        // Create array for category tasks
        Task[] memory categoryTasks = new Task[](categoryCount);
        uint256 resultIndex = 0;
        
        // Fill category tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (keccak256(bytes(allTasks[i].category)) == keccak256(bytes(_category))) {
                categoryTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return categoryTasks;
    }
    
    /**
     * @dev Get tasks by priority
     * @param _priority Priority level to filter by
     * @return Array of Task structures
     */
    function getTasksByPriority(uint8 _priority) public view returns (Task[] memory) {
        require(_priority <= 3, "Priority must be between 0 and 3");
        
        Task[] memory allTasks = getAllTasks();
        uint256 priorityCount = 0;
        
        // Count tasks with the priority
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (allTasks[i].priority == _priority) {
                priorityCount++;
            }
        }
        
        // Create array for priority tasks
        Task[] memory priorityTasks = new Task[](priorityCount);
        uint256 resultIndex = 0;
        
        // Fill priority tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (allTasks[i].priority == _priority) {
                priorityTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return priorityTasks;
    }
    
    /**
     * @dev Get tasks with upcoming deadlines
     * @param _within Tasks with deadlines within this many seconds from now
     * @return Array of Task structures
     */
    function getUpcomingDeadlines(uint256 _within) public view returns (Task[] memory) {
        Task[] memory allTasks = getAllTasks();
        uint256 upcomingCount = 0;
        uint256 currentTime = block.timestamp;
        uint256 futureTime = currentTime + _within;
        
        // Count tasks with upcoming deadlines
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted && 
                allTasks[i].deadline > 0 && 
                allTasks[i].deadline > currentTime && 
                allTasks[i].deadline <= futureTime) {
                upcomingCount++;
            }
        }
        
        // Create array for upcoming tasks
        Task[] memory upcomingTasks = new Task[](upcomingCount);
        uint256 resultIndex = 0;
        
        // Fill upcoming tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted && 
                allTasks[i].deadline > 0 && 
                allTasks[i].deadline > currentTime && 
                allTasks[i].deadline <= futureTime) {
                upcomingTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return upcomingTasks;
    }
    
    /**
     * @dev Get overdue tasks
     * @return Array of Task structures
     */
    function getOverdueTasks() public view returns (Task[] memory) {
        Task[] memory allTasks = getAllTasks();
        uint256 overdueCount = 0;
        uint256 currentTime = block.timestamp;
        
        // Count overdue tasks
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted && 
                allTasks[i].deadline > 0 && 
                allTasks[i].deadline < currentTime) {
                overdueCount++;
            }
        }
        
        // Create array for overdue tasks
        Task[] memory overdueTasks = new Task[](overdueCount);
        uint256 resultIndex = 0;
        
        // Fill overdue tasks array
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (!allTasks[i].isCompleted && 
                allTasks[i].deadline > 0 && 
                allTasks[i].deadline < currentTime) {
                overdueTasks[resultIndex] = allTasks[i];
                resultIndex++;
            }
        }
        
        return overdueTasks;
    }
    
    /**
     * @dev Get task count stats
     * @return total Total task count
     * @return active Count of active tasks
     * @return completed Count of completed tasks
     * @return overdue Count of overdue tasks
     */
    function getTaskStats() public view returns (
        uint256 total,
        uint256 active,
        uint256 completed,
        uint256 overdue
    ) {
        Task[] memory allTasks = getAllTasks();
        uint256 currentTime = block.timestamp;
        
        total = allTasks.length;
        active = 0;
        completed = 0;
        overdue = 0;
        
        for (uint256 i = 0; i < allTasks.length; i++) {
            if (allTasks[i].isCompleted) {
                completed++;
            } else {
                active++;
                
                if (allTasks[i].deadline > 0 && allTasks[i].deadline < currentTime) {
                    overdue++;
                }
            }
        }
        
        return (total, active, completed, overdue);
    }
}
