// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {TaskManager} from "src/TaskManager.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CreateTask is Script {
    function createTask(address taskManager) public {
        vm.startBroadcast();

        TaskManager(taskManager).createTask{value: 25}("Tarefa de teste", "Apenas um teste", block.timestamp + 7 days);

        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("TaskManager", block.chainid);
        createTask(mostRecentlyDeployed);
    }
}

contract CompleteTask is Script {
    function completeTask(address taskManager, uint256 taskId) public {
        vm.startBroadcast();

        TaskManager(taskManager).completeTask(taskId);

        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("TaskManager", block.chainid);
        completeTask(mostRecentlyDeployed, 0);
    }
}
