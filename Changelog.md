# Changelog for cardano-system

## Unreleased changes

* Add `cardano-node`, `cardano-wallet` and `plutus-chain-index` systemd
module services. These can be enabled with `services.cardano-node.enable =
true`, `services.cardano-wallet.enable = true`, and
`services.plutus-chain-index.enable = true`. All three can be simultaneously
enabled with `services.cardano-system.enable = true;
  * By default, the `cardano-node` service will run against the mainnet. This can
be overriden with the `services.cardano-node.config-file` and
`services.cardano-node.topology-file` options.
* Add virtual machine tests to check the sockets and http interfaces appear.
* Add bash library for interacting with services via the terminal. This can be enabled
 with `services.cardano-system.library.enable = true".
