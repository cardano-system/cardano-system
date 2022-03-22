{
  description = "Cardano System";

  inputs = {
    cardano-node-flake.url = "github:input-output-hk/cardano-node";
    cardano-node-source = {
      url = "github:input-output-hk/cardano-node";
      flake = false; 
    };
    cardano-wallet-source = {
      url = "github:input-output-hk/cardano-wallet";
      flake = false;
    };
    plutus-chain-index-source = {
      url = "github:input-output-hk/plutus-apps";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , cardano-node-flake
    , cardano-node-source
    , cardano-wallet-source
    , plutus-chain-index-source
    , ...
    }@inputs: 
      let cardano-node = cardano-node-flake.outputs.packages.x86_64-linux.cardano-node;
          cardano-html = (import (cardano-node-source + "/release.nix") {}).cardano-deployment;
          cardano-wallet = (import cardano-wallet-source {}).cardano-wallet;
          plutus-chain-index = (import plutus-chain-index-source {}).plutus-chain-index;
      in {
        modules = {
          cardano-node = ./modules/cardano-node.nix;
          cardano-wallet = ./modules/cardano-wallet.nix;
          plutus-chain-index = ./modules/plutus-chain-index.nix;
        };
        defaults = {
          services.cardano-node = {
            package = cardano-node;
            config-file = "${cardano-html}/mainnet-config.json";
            topology-file = "${cardano-html}/mainnet-topology.json";
          };
          services.plutus-chain-index = {
            package = plutus-chain-index;
          };
          services.cardano-wallet = {
            package = cardano-wallet;
          };
        };
      };
}
