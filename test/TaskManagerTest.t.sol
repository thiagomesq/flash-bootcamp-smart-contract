// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {TaskManager} from "src/TaskManager.sol";
import {DeployTaskManager} from "script/DeployTaskManager.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract TaskManagerTest is Test {
    TaskManager private taskManager;
    HelperConfig.NetworkConfig private config;
    DeployTaskManager private deployer;
    address private user = makeAddr("user");

    function setUp() public {
        deployer = new DeployTaskManager();
        (taskManager, config) = deployer.run();

        user = makeAddr("user");
        vm.deal(user, 10000 ether); // Give user some ether for testing
    }

    function testCreateTask() public {
        string memory title = "Test Task";
        string memory description = "This is a test task.";
        uint256 dueDate = block.timestamp + 1 days;
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}(title, description, dueDate);

        TaskManager.Task memory task = taskManager.getTask(0);
        vm.stopPrank();
        assertEq(task.title, title);
        assertEq(task.description, description);
        assertEq(task.dueDate, dueDate);
        assertEq(task.isCompleted, false);
        assertEq(task.owner, user);
    }

    function testCompleteTask() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Test Task", "This is a test task.", block.timestamp + 1 days);
        taskManager.completeTask(0);

        TaskManager.Task memory task = taskManager.getTask(0);
        vm.stopPrank();
        assertEq(task.isCompleted, true);
        assertGt(task.completedAt, 0);
    }

    function testCompleteTaskRevertsIfNotOwner() public {
        vm.prank(user);
        taskManager.createTask{value: config.minimumStake}("Test Task", "This is a test task.", block.timestamp + 1 days);

        // Simulate another user trying to complete the task
        address otherUser = address(0x123);
        vm.startPrank(otherUser);
        vm.expectRevert(TaskManager.TaskManager__Unauthorized.selector, 0);
        taskManager.completeTask(0);
        vm.stopPrank();
    }

    function testCompleteTaskRevertsIfAlreadyCompleted() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Test Task", "This is a test task.", block.timestamp + 1 days);
        taskManager.completeTask(0);

        // Attempt to complete the task again
        vm.expectRevert(TaskManager.TaskManager__TaskAlreadyCompleted.selector, 0);
        taskManager.completeTask(0);
        vm.stopPrank();
    }

    function testGetTask() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Test Task", "This is a test task.", block.timestamp + 1 days);
        TaskManager.Task memory task = taskManager.getTask(0);
        vm.stopPrank();

        assertEq(task.id, 0);
        assertEq(task.title, "Test Task");
        assertEq(task.description, "This is a test task.");
        assertEq(task.dueDate, block.timestamp + 1 days);
        assertEq(task.isCompleted, false);
        assertEq(task.owner, user);
    }

    function testGetTaskRevertsIfNotFound() public {
        vm.expectRevert(TaskManager.TaskManager__TaskNotFound.selector, 0);
        taskManager.getTask(999); // Non-existent task ID
    }

    function testGetTasks() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Task 1", "Description 1", block.timestamp + 1 days);
        taskManager.createTask{value: config.minimumStake}("Task 2", "Description 2", block.timestamp + 2 days);

        TaskManager.Task[] memory tasks = taskManager.getTasks();
        vm.stopPrank();

        assertEq(tasks.length, 2);
        assertEq(tasks[0].title, "Task 1");
        assertEq(tasks[1].title, "Task 2");
    }

    function testGetTasksEmpty() public view {
        TaskManager.Task[] memory tasks = taskManager.getTasks();
        assertEq(tasks.length, 0);
    }

    function testGetTasksEmptyIfNotOwner() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Task 1", "Description 1", block.timestamp + 1 days);
        vm.stopPrank();

        // Simulate another user trying to get tasks
        address otherUser = address(0x123);
        vm.startPrank(otherUser);
        TaskManager.Task[] memory tasks = taskManager.getTasks();
        vm.stopPrank();

        assertEq(tasks.length, 0); // Should not return tasks of another user
    }

    function testCreateTaskRevertsIfInsufficientStake() public {
        vm.startPrank(user);
        vm.expectRevert(TaskManager.TaskManager__InsufficientStake.selector, 0);
        taskManager.createTask{value: 5}("Test Task", "This is a test task.", block.timestamp + 1 days);
        vm.stopPrank();
    }

    function testCreateTaskRevertsIfNoStake() public {
        vm.startPrank(user);
        vm.expectRevert(TaskManager.TaskManager__InsufficientStake.selector, 0);
        taskManager.createTask("", "", block.timestamp + 1 days);
        vm.stopPrank();
    }

    function testGetTasksCount() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Task 1", "Description 1", block.timestamp + 1 days);
        taskManager.createTask{value: config.minimumStake}("Task 2", "Description 2", block.timestamp + 2 days);

        uint256 count = taskManager.getTasksCount();
        vm.stopPrank();

        assertEq(count, 2);
    }

    function testGetTasksCountEmpty() public view {
        uint256 count = taskManager.getTasksCount();
        assertEq(count, 0);
    }

    function testGetTasksCountEmptyIfNotOwner() public {
        vm.startPrank(user);
        taskManager.createTask{value: config.minimumStake}("Task 1", "Description 1", block.timestamp + 1 days);
        vm.stopPrank();

        // Simulate another user trying to get tasks count
        address otherUser = address(0x123);
        vm.startPrank(otherUser);
        uint256 count = taskManager.getTasksCount();
        vm.stopPrank();

        assertEq(count, 0); // Should not return tasks count of another user
    }
}
