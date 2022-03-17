{
  description = "Cardano System";

  inputs = {
    cardano-node.url = "github:input-output-hk/cardano-node";
    cardano-wallet = {
      url ="github:input-output-hk/cardano-wallet";
      flake = false;
    };
    plutus-apps = {
      url = "github:input-output-hk/plutus-apps/1828bcc7762cd6bdcf45ee9e3a7009279cd6b0a7";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , cardano-node
    , cardano-wallet
    , plutus-apps
    , ...
    }@inputs: 
      let cardano-wallet-module = { pkgs, ... }: {
            imports = ["${cardano-wallet}/nix/nixos/cardano-wallet-service.nix"];
           };
           plutus-chain-index = (import plutus-apps {}).plutus-chain-index;
      in {
        nixosModules = {
          cardano-node = cardano-node.outputs.nixosModules.cardano-node;
          cardano-system = ./modules/cardano-system.nix;
          cardano-wallet = cardano-wallet-module;
          plutus-chain-index = ./modules/plutus-chain-index.nix;
        };
      };
}
