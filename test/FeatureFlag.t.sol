// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FeatureFlagRegistry} from "../src/FeatureFlagRegistry.sol";

contract FeatureFlagTest is Test {
    FeatureFlagRegistry public registry;
    address public owner;
    address public user1;
    address public user2;
    
    bytes32 public constant TEST_FLAG = keccak256("TEST_FLAG");
    bytes32 public constant ANOTHER_FLAG = keccak256("ANOTHER_FLAG");
    
    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        vm.startPrank(owner);
        registry = new FeatureFlagRegistry();
        vm.stopPrank();
    }
    
    function test_SetGlobalFlag() public {
        vm.startPrank(owner);
        registry.setFlag(TEST_FLAG, address(0), true);
        assertTrue(registry.isEnabled(TEST_FLAG, user1));
        assertTrue(registry.isEnabled(TEST_FLAG, user2));
        vm.stopPrank();
    }
    
    function test_SetUserFlag() public {
        vm.startPrank(owner);
        registry.setFlag(TEST_FLAG, user1, true);
        assertTrue(registry.isEnabled(TEST_FLAG, user1));
        assertFalse(registry.isEnabled(TEST_FLAG, user2));
        vm.stopPrank();
    }
    
    function test_RemoveFlag() public {
        vm.startPrank(owner);
        registry.setFlag(TEST_FLAG, user1, true);
        registry.removeFlag(TEST_FLAG, user1);
        assertFalse(registry.isEnabled(TEST_FLAG, user1));
        vm.stopPrank();
    }
    
    function test_OnlyOwnerCanSetFlags() public {
        vm.startPrank(user1);
        vm.expectRevert();
        registry.setFlag(TEST_FLAG, user2, true);
        vm.stopPrank();
    }
    
    function test_FlagExists() public {
        vm.startPrank(owner);
        assertFalse(registry.flagExists(TEST_FLAG));
        registry.setFlag(TEST_FLAG, address(0), true);
        assertTrue(registry.flagExists(TEST_FLAG));
        vm.stopPrank();
    }
} 