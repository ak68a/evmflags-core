# EVMFlags

A decentralized feature flag registry for EVM-compatible blockchains, for [Radius](https://radiustech.xyz) smart contracts. This system provides granular control over feature flags through multiple access levels:

- Global flags that apply to all users
- User-specific flags for individual address control
- Version-specific flags for contract version targeting
- Group-based flags for managing access tiers and user groups

The system supports creating and managing user groups, allowing efficient feature flag management for different access tiers (e.g., Premium users, Beta testers, Early access). Each flag can be enabled at any combination of these levels, with a clear precedence order: user-specific flags take highest priority, followed by group flags, and finally global flags.