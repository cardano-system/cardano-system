{ pkgs, makeTest, inputs }:
makeTest {
  nodes = {
    cardanoSystem = { ... }: {
      imports = [
        inputs.self.nixosModules.${pkgs.hostPlatform.system}.cardano-node
        inputs.self.nixosModules.${pkgs.hostPlatform.system}.cardano-wallet
        inputs.self.nixosModules.${pkgs.hostPlatform.system}.plutus-chain-index
        inputs.self.nixosModules.${pkgs.hostPlatform.system}.cardano-system
        inputs.self.nixosModules.${pkgs.hostPlatform.system}.lib
      ];
      services.cardano-system.enable = true;
    };
  };
  testScript = { nodes, ... }: ''
    cardanoSystem.wait_for_file("${toString nodes.cardanoSystem.config.services.cardano-node.socket-path}")
    cardanoSystem.wait_for_open_port("${toString nodes.cardanoSystem.config.services.cardano-node.port}")
    cardanoSystem.wait_for_open_port("${toString nodes.cardanoSystem.config.services.plutus-chain-index.port}")
    cardanoSystem.wait_for_open_port("${toString nodes.cardanoSystem.config.services.cardano-wallet.port}")
  '';
}
