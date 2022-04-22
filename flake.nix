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
    let
      cardano-node = cardano-node-flake.packages.x86_64-linux.cardano-node;
      cardano-wallet = cardano-wallet-flake.packages.x86_64-linux.cardano-wallet;
      plutus-chain-index = plutus-apps-flake.legacyPackages.x86_64-linux.plutus-chain-index;
    in
    {
      nixosModules.x86_64-linux = {
        cardano-node = ./modules/cardano-node.nix;
        cardano-wallet = ./modules/cardano-wallet.nix;
        plutus-chain-index = ./modules/plutus-chain-index.nix;
        cardano-system = ./modules/cardano-system.nix;
        lib = ./modules/lib.nix;
      };
        };
      };
    };
}
