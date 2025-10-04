// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

contract TaskManager {
    error TaskManager__InsufficientStake(uint256 providedStake, uint256 minimumStake);
    error TaskManager__TaskNotFound(uint256 id);
    error TaskManager__Unauthorized(address caller, address owner);
    error TaskManager__TaskAlreadyCompleted(uint256 id);
    error TaskManager__TransferFailed(address to, uint256 amount);
    error TaskManager__TaskIsOverdue(uint256 id);

    struct Task {
        uint256 id;
        uint256 stake;
        string title;
        string description;
        uint256 createdAt;
        uint256 completedAt;
        uint256 dueDate;
        bool isCompleted;
        address owner;
    }

    uint256 private immutable i_minimumStake; // Minimum stake required to create a task
    Task[] private s_tasks;
    mapping(address => uint256[]) private s_userTasks;
    // To keep track of the next task ID
    // This is a simple counter to assign unique IDs to tasks
    uint256 private s_nextTaskId;

    event TaskCreated(
        uint256 indexed id,
        uint256 indexed stake,
        string title,
        string description,
        uint256 createdAt,
        uint256 completedAt,
        uint256 indexed dueDate,
        bool isCompleted,
        address owner
    );
    event TaskCompleted(uint256 indexed id, uint256 indexed createdAt, uint256 indexed completedAt);

    constructor(uint256 _minimumStake) {
        s_nextTaskId = 0; // Initialize the next task ID
        i_minimumStake = _minimumStake;
    }

    function createTask(string memory _title, string memory _description, uint256 _dueDate) external payable {
        if (msg.value < i_minimumStake) {
            revert TaskManager__InsufficientStake(msg.value, i_minimumStake);
        }
        Task memory newTask = Task({
            id: s_nextTaskId,
            stake: msg.value,
            title: _title,
            description: _description,
            createdAt: block.timestamp,
            completedAt: 0,
            dueDate: _dueDate,
            isCompleted: false,
            owner: msg.sender
        });

        s_tasks.push(newTask);
        s_userTasks[msg.sender].push(s_nextTaskId);

        emit TaskCreated({
            id: s_nextTaskId,
            stake: newTask.stake,
            title: _title,
            description: _description,
            createdAt: newTask.createdAt,
            completedAt: newTask.completedAt,
            dueDate: _dueDate,
            isCompleted: newTask.isCompleted,
            owner: msg.sender
        });
        s_nextTaskId++;
    }

    function completeTask(uint256 _id) external {
        if (s_tasks[_id].owner != msg.sender) {
            revert TaskManager__Unauthorized(msg.sender, s_tasks[_id].owner);
        }
        if (s_userTasks[msg.sender].length == 0) {
            revert TaskManager__TaskNotFound(_id);
        }
        if (s_tasks[_id].isCompleted) {
            revert TaskManager__TaskAlreadyCompleted(_id);
        }
        if (s_tasks[_id].dueDate < block.timestamp) {
            revert TaskManager__TaskIsOverdue(_id); // Task is overdue, cannot complete
        }
        s_tasks[_id].isCompleted = true;
        s_tasks[_id].completedAt = block.timestamp;

        // Return the stake to the user when task is completed
        uint256 stakeAmount = s_tasks[_id].stake;
        s_tasks[_id].stake = 0; // Reset stake to prevent re-entrancy
        (bool success, ) = payable(msg.sender).call{value: stakeAmount}("");
        if (!success) {
            revert TaskManager__TransferFailed(msg.sender, stakeAmount);
        }

        emit TaskCompleted({id: _id, createdAt: s_tasks[_id].createdAt, completedAt: block.timestamp});
    }

    function getTask(uint256 _id) external view returns (Task memory) {
        if (s_userTasks[msg.sender].length == 0) {
            revert TaskManager__TaskNotFound(_id);
        }
        return s_tasks[_id];
    }

    function getTasks() external view returns (Task[] memory) {
        uint256[] memory userTaskIds = s_userTasks[msg.sender];
        Task[] memory userTasksArray = new Task[](userTaskIds.length);
        for (uint256 i = 0; i < userTaskIds.length; i++) {
            userTasksArray[i] = s_tasks[userTaskIds[i]];
        }
        return userTasksArray;
    }

    function getTasksCount() external view returns (uint256) {
        return s_userTasks[msg.sender].length;
    }

    function getMinimumStake() external view returns (uint256) {
        return i_minimumStake;
    }
}
