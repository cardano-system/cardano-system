{
  description = "Cardano System";

  inputs = {
    cardano-node.url = "github:input-output-hk/cardano-node";
    cardano-wallet.url = "github:input-output-hk/cardano-wallet/";
    plutus-chain-index-source.url = "github:input-output-hk/plutus-apps/aa2bf43f61905fabac9fc637cac715086fada29a";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , cardano-node
    , cardano-wallet
    , plutus-chain-index-source
    , ...
    }@inputs: 
      let cardano-wallet = (import cardano-wallet {}).cardano-wallet;
          plutus-chain-index = (import plutus-chain-index-source {}).plutus-chain-index;
      in {
        nixosModules = {
          cardano-node = cardano-node.outputs.nixosModules.cardano-node;
          cardano-system = import ./modules/cardano-system.nix { inherit inputs; };
          cardano-wallet = ./modules/cardano-wallet.nix;
          plutus-chain-index = ./modules/plutus-chain-index.nix;
        };
      };
}
