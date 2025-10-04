// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {TaskManager} from "src/TaskManager.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployTaskManager is Script {
    function run() external returns (TaskManager, HelperConfig.NetworkConfig memory) {
        return deployContract();
    }

    function deployContract() public returns (TaskManager taskManager, HelperConfig.NetworkConfig memory config) {
        HelperConfig helperConfig = new HelperConfig();
        config = helperConfig.getConfig();

        vm.startBroadcast(config.account);
        taskManager = new TaskManager(config.minimumStake);
        vm.stopBroadcast();
    }
}
