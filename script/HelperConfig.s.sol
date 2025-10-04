// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        uint256 minimumStake;
        address account;
    }

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant POLYGON_AMOY_CHAIN_ID = 80001;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    NetworkConfig public localNetworkConfig;
    mapping(uint256 => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaConfig();
        networkConfigs[POLYGON_AMOY_CHAIN_ID] = getPolygonAmoyConfig();
    }

    function getConfigChainId(uint256 chainId) public view returns (NetworkConfig memory) {
        if (networkConfigs[chainId].minimumStake != 0) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return getConfigChainId(block.chainid);
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            minimumStake: 0.000001 ether,
            account: 0xe7FDf6cA472c484FA8b7b2E11a5E62adaF1e649F
        });
    }

    function getPolygonAmoyConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            minimumStake: 0.01 ether,
            account: 0xe7FDf6cA472c484FA8b7b2E11a5E62adaF1e649F
        });
    }

    function getOrCreateAnvilEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            minimumStake: 0.1 ether,
            account: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        });
    }
}