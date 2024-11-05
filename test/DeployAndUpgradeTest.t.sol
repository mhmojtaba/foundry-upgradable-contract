// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Deploy} from "script/Deploy.s.sol";
import {Upgrade} from "script/Upgrade.s.sol";
import {V1} from "src/V1.sol";
import {V2} from "src/V2.sol";

contract DeployAndUpgradeTest is Test {
    Deploy public deployer;
    Upgrade public upgrader;
    address public owner = makeAddr("owner");
    address public proxy;
    V2 public v2;
    function setUp() public {
        deployer = new Deploy();
        upgrader = new Upgrade();
        proxy = deployer.run();// point to V1
        
    }

    function testProxyStartAsV1() public {
        vm.expectRevert();
        V2(proxy).setNumber(10);
    }

    function testUpgrade() public {
        v2 = new V2();
        upgrader.upgradeProxy(proxy, address(v2));

        uint256 expectedVersion = 2 ;
        assertEq(V2(proxy).version(), expectedVersion);

        V2(proxy).setNumber(10);
        assertEq(V2(proxy).getNumber(), 10);
    }
    
}