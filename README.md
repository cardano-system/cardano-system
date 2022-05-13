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
     cardano-system.nixosModule.x86_64-linux
     {
       services.cardano-system.enable = true;
       services.cardano-system.library.enable = true;
     }
   ]
```

## Notes

* The cardano-node is run with `+RTS -N`, where as the cardano-node in daedalus
is limited to two cores.
* Everything currently defaults to the mainnet, but this is overridable.

Default ports:
  * cardano-wallet: 9081
  * cardano-node: 9082
  * plutus-chain-index: 9083
