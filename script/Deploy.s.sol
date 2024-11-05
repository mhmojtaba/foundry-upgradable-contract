// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {V1} from "src/V1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    function run() public returns(address) {
        address proxy = deployV1();
        return proxy;
    }

    function deployV1() public returns(address) {
        vm.startBroadcast();
        V1 v1 = new V1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(v1), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}