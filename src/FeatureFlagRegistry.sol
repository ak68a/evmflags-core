// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title FeatureFlagRegistry
/// @notice A registry for managing feature flags in smart contracts
/// @dev Allows for both global and user-specific feature flags
contract FeatureFlagRegistry is Ownable {
    // Events
    event FlagSet(bytes32 indexed flag, address indexed user, bool value);
    event FlagRemoved(bytes32 indexed flag, address indexed user);
    
    // Constants
    bytes32 public constant GLOBAL_SCOPE = bytes32(0);
    
    // Storage
    // flag => (user => enabled)
    mapping(bytes32 => mapping(address => bool)) internal _flags;
    
    // flag => (global scope enabled)
    mapping(bytes32 => bool) internal _globalFlags;
    
    // flag => exists
    mapping(bytes32 => bool) internal _flagExists;
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Set a feature flag for a specific user
    /// @param flag The feature flag identifier
    /// @param user The user address (use address(0) for global scope)
    /// @param value The flag value
    function setFlag(bytes32 flag, address user, bool value) external onlyOwner {
        if (user == address(0)) {
            _globalFlags[flag] = value;
        } else {
            _flags[flag][user] = value;
        }
        _flagExists[flag] = true;
        emit FlagSet(flag, user, value);
    }
    
    /// @notice Remove a feature flag for a specific user
    /// @param flag The feature flag identifier
    /// @param user The user address (use address(0) for global scope)
    function removeFlag(bytes32 flag, address user) external onlyOwner {
        if (user == address(0)) {
            delete _globalFlags[flag];
        } else {
            delete _flags[flag][user];
        }
        emit FlagRemoved(flag, user);
    }
    
    /// @notice Check if a feature flag is enabled for a user
    /// @param flag The feature flag identifier
    /// @param user The user address to check
    /// @return bool True if the flag is enabled for the user
    function isEnabled(bytes32 flag, address user) external view returns (bool) {
        return _isEnabledInternal(flag, user);
    }
    
    /// @dev Internal logic for checking if a feature flag is enabled for a user
    function _isEnabledInternal(bytes32 flag, address user) internal view returns (bool) {
        // Check user-specific flag first
        if (_flags[flag][user]) {
            return true;
        }
        // Fall back to global flag
        return _globalFlags[flag];
    }
    
    /// @notice Check if a flag exists in the registry
    /// @param flag The feature flag identifier
    /// @return bool True if the flag exists
    function flagExists(bytes32 flag) external view returns (bool) {
        return _flagExists[flag];
    }
    
    /// @notice Get all flags for a specific user
    /// @param user The user address
    /// @return flags Array of flag identifiers
    /// @return values Array of flag values
    function getUserFlags(address user) external view returns (bytes32[] memory flags, bool[] memory values) {
        // Note: This is a simplified version. In production:
        // 1. Add pagination
        // 2. Cache flag list
        // 3. Use events for off-chain indexing
        uint256 count = 0;
        bytes32[] memory tempFlags = new bytes32[](100); // Arbitrary max size
        bool[] memory tempValues = new bool[](100);
        
        // Iterate through all flags (in production, use events or off-chain indexing)
        for (uint256 i = 0; i < 100; i++) {
            bytes32 flag = bytes32(i);
            if (_flagExists[flag]) {
                tempFlags[count] = flag;
                tempValues[count] = _isEnabledInternal(flag, user);
                count++;
            }
        }
        
        // Create properly sized arrays
        flags = new bytes32[](count);
        values = new bool[](count);
        
        for (uint256 i = 0; i < count; i++) {
            flags[i] = tempFlags[i];
            values[i] = tempValues[i];
        }
    }
} 