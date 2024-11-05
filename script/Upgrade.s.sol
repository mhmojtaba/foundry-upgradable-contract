// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {V2} from "src/V2.sol";
import {V1} from "src/V1.sol";

contract Upgrade is Script {
    function run() public returns(address) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy",block.chainid);
        vm.startBroadcast();
        V2 v2 = new V2();
        vm.stopBroadcast();
        address proxy = upgradeProxy(mostRecentlyDeployed, address(v2));
        return proxy;
    }

    function upgradeProxy(address proxy, address newImplementation) public returns(address) {
        vm.startBroadcast();
        V1 v1 = V1(proxy);
        v1.upgradeToAndCall(address(newImplementation),"");
        vm.stopBroadcast();
        return address(v1);
    }
}