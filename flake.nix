{
  description = "Cardano System";

  inputs = {
    cardano-node-flake.url = "github:input-output-hk/cardano-node";
    cardano-wallet-flake.url = "github:input-output-hk/cardano-wallet";
    plutus-apps-flake.url = "github:input-output-hk/plutus-apps/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , cardano-node-flake
    , cardano-wallet-flake
    , plutus-apps-flake
    , ...
    }@inputs:
    {
      nixosModule.x86_64-linux = {
        imports = [
          self.nixosModules.x86_64-linux.cardano-node
          self.nixosModules.x86_64-linux.cardano-wallet
          self.nixosModules.x86_64-linux.cardano-system
          self.nixosModules.x86_64-linux.plutus-chain-index
          self.nixosModules.x86_64-linux.lib
        ];
      };
      nixosModules.x86_64-linux = {
        cardano-node = { pkgs, lib, config, ... }: {
          imports = [ ./modules/cardano-node.nix ];
          nixpkgs.overlays = [ inputs.self.overlays.default ];
        };
        cardano-wallet = { pkgs, lib, config, ... }: {
          imports = [ ./modules/cardano-wallet.nix ];
          nixpkgs.overlays = [ inputs.self.overlays.default ];
        };
        cardano-system = ./modules/cardano-system.nix;
        plutus-chain-index = { pkgs, lib, config, ... }: {
          imports = [ ./modules/plutus-chain-index.nix ];
          nixpkgs.overlays = [ inputs.self.overlays.default ];
        };
        lib = { pkgs, lib, config, ... }: {
          imports = [ ./modules/lib.nix ];
          nixpkgs.overlays = [ inputs.self.overlays.default ];
        };
      };
      overlays.default = final: prev: {
        cardano-system = {
          cardano-cli = cardano-node-flake.packages.${final.hostPlatform.system}.cardano-cli;
          cardano-node = cardano-node-flake.packages.${final.hostPlatform.system}.cardano-node;
          cardano-wallet = cardano-wallet-flake.packages.${final.hostPlatform.system}.cardano-wallet;
          plutus-chain-index = plutus-apps-flake.legacyPackages.${final.hostPlatform.system}.plutus-chain-index;
          mainnet-topology = "${inputs.cardano-node-flake}/configuration/cardano/mainnet-topology.json";
          mainnet-config = "${inputs.cardano-node-flake}/configuration/cardano/mainnet-config.json";
          testnet-topology = "${inputs.cardano-node-flake}/configuration/cardano/testnet-topology.json";
          testnet-config = "${inputs.cardano-node-flake}/configuration/cardano/testnet-config.json";
          mainnet-byron-genesis = "${inputs.cardano-node-flake}/configuration/cardano/mainnet-byron-genesis.json";
          testnet-byron-genesis = "${inputs.cardano-node-flake}/configuration/cardano/testnet-byron-genesis.json";
          networks = {
            mainnet = {
              name = "mainnet";
              topology = final.cardano-system.mainnet-topology;
              config = final.cardano-system.mainnet-config;
              id = 764824073;
              genesis = final.cardano-system.mainnet-byron-genesis;
            };
            testnet = {
              name = "testnet";
              topology = final.cardano-system.testnet-topology;
              config = final.cardano-system.testnet-config;
              id = 1097911063;
              genesis = final.cardano-system.testnet-byron-genesis;
            };
          };
        };
      };
      checks.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          system = pkgs.hostPlatform.system;
          vmTests = import ./tests {
            makeTest = (import (nixpkgs + "/nixos/lib/testing-python.nix") { inherit system; }).makeTest;
            inherit pkgs inputs;
          };
        in
        pkgs.lib.optionalAttrs pkgs.stdenv.isLinux vmTests # vmTests can only be ran on Linux, so append them only if on Linux.
        //
        {
          # Other checks here...
        };
    };
}
