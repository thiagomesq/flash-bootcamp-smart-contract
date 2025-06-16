// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import { Script } from "forge-std/Script.sol";
import { TaskManager } from "src/TaskManager.sol";

contract DeployTaskManager is Script {
    function run() external returns (TaskManager taskManager) {
        vm.startBroadcast();
        taskManager = new TaskManager();
        vm.stopBroadcast();
    }
}