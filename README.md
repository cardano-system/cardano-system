# Cardano System

`cardano-system` is a collection of NixOS systemd modules for cardano and
plutus power users. This should be a system level replacement of pab-cli from
[plutus-apps](https://github.com/input-output-hk/plutus-apps).

## Installing

You should use this as a system flake input.

```
inputs = {
  cardano-system.url = "github:cardano-system/cardano-system";
}

...

mySystem = {
   system = "x86_64-linux";
   modules = [
     cardano-system.modules.cardano-node
     cardano-system.modules.cardano-wallet
     cardano-system.modules.plutus-chain-index
     cardano-system.defaults
     {
       services.cardano-node.enable = true;
       services.plutus-chain-index.enable = true;
       services.cardano-wallet.enable = true;
     }
   ]
```

## Notes

* The cardano-node is run with `+RTS -N`, where as the cardano-node in daedalus
is limited to two cores.
* `cardano-system.defaults` sets the packages for the wallet, node and chain-index, but these
are overridable.
* `cardano-system.defaults` also defaults to the mainnet as this is the primary use case, but
this could be used to set up a testnet VM.

Default ports:
  * cardano-wallet: 9081
  * cardano-node: 9082
  * plutus-chain-index: 9083
