// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract TaskManager {
    error TaskManager__InsufficientStake(uint256 providedStake, uint256 minimumStake);
    error TaskManager__TaskNotFound(uint256 id);
    error TaskManager__Unauthorized(address caller, address owner);
    error TaskManager__TaskAlreadyCompleted(uint256 id);

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

    Task[] private tasks;
    mapping(address => uint256[]) private userTasks;
    // To keep track of the next task ID
    // This is a simple counter to assign unique IDs to tasks
    uint256 private nextTaskId;

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

    function createTask(string memory _title, string memory _description, uint256 _dueDate) external payable {
        if (msg.value < 10) {
            revert TaskManager__InsufficientStake(msg.value, 10);
        }
        Task memory newTask = Task({
            id: nextTaskId,
            stake: msg.value,
            title: _title,
            description: _description,
            createdAt: block.timestamp,
            completedAt: 0,
            dueDate: _dueDate,
            isCompleted: false,
            owner: msg.sender
        });

        tasks.push(newTask);
        userTasks[msg.sender].push(nextTaskId);

        emit TaskCreated({
            id: nextTaskId,
            stake: newTask.stake,
            title: _title,
            description: _description,
            createdAt: newTask.createdAt,
            completedAt: newTask.completedAt,
            dueDate: _dueDate,
            isCompleted: newTask.isCompleted,
            owner: msg.sender
        });
        nextTaskId++;
    }

    function completeTask(uint256 _id) external {
        if (userTasks[msg.sender].length == 0) {
            revert TaskManager__TaskNotFound(_id);
        }
        if (tasks[_id].owner != msg.sender) {
            revert TaskManager__Unauthorized(msg.sender, tasks[_id].owner);
        }
        if (tasks[_id].isCompleted) {
            revert TaskManager__TaskAlreadyCompleted(_id);
        }
        tasks[_id].isCompleted = true;
        tasks[_id].completedAt = block.timestamp;
        emit TaskCompleted({id: _id, createdAt: tasks[_id].createdAt, completedAt: block.timestamp});
    }

    function getTask(uint256 _id) external view returns (Task memory) {
        if (userTasks[msg.sender].length == 0) {
            revert TaskManager__TaskNotFound(_id);
        }
        return tasks[_id];
    }

    function getTasks() external view returns (Task[] memory) {
        uint256[] memory userTaskIds = userTasks[msg.sender];
        Task[] memory userTasksArray = new Task[](userTaskIds.length);
        for (uint256 i = 0; i < userTaskIds.length; i++) {
            userTasksArray[i] = tasks[userTaskIds[i]];
        }
        return userTasksArray;
    }

    function getTasksCount() external view returns (uint256) {
        return userTasks[msg.sender].length;
    }
}
