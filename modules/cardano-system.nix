{ pkgs, config, lib, ... }:

let cfg = config.services.cardano-system;

in

with lib;
{
  options = {
    services.cardano-system = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
      network = {
        name = mkOption {
          default = pkgs.cardano-system.networks.mainnet.name;
          type = types.str;
        };
        topology = mkOption {
          default = pkgs.cardano-system.networks.mainnet.topology;
          type = types.path;
        };
        config = mkOption {
          default = pkgs.cardano-system.networks.mainnet.config;
          type = types.path;
        };
        id = mkOption {
          default = pkgs.cardano-system.networks.mainnet.id;
          type = types.int;
        };
        genesis = mkOption {
          default = pkgs.cardano-system.networks.mainnet.genesis;
          type = types.path;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.cardano-node = {
      enable = true;
      topology-file = config.services.cardano-system.network.topology;
      config-file = config.services.cardano-system.network.config;
      database-path = "/var/cardano-system/${cfg.network.name}/node";
      socket-path = "/var/cardano-system/${cfg.network.name}/node/node.sock";
    };
    services.cardano-wallet = {
      enable = true;
      database-path = "/var/cardano-system/${cfg.network.name}/wbe";
      byron-genesis-path = config.services.cardano-system.network.genesis;
    };
    services.plutus-chain-index = {
      enable = true;
      database-path = "/var/cardano-system/${cfg.network.name}/chain-index/chain-index.db";
      network-id = config.services.cardano-system.network.id;
    };
    users = {
      groups.cardano-system.gid = 8020;
      users.cardano-system =
        {
          group = "cardano-system";
          shell = "${pkgs.bash}/bin/bash";
          uid = 8020;
          isSystemUser = true;
        };
    };
    systemd.tmpfiles.rules = [
      "d /var/cardano-system                                   0770 cardano-system cardano-system - -"
      "d /var/cardano-system/${cfg.network.name}               0770 cardano-system cardano-system - -"
      "d /var/cardano-system/${cfg.network.name}/node          0770 cardano-system cardano-system - -"
      "d /var/cardano-system/${cfg.network.name}/wbe           0770 cardano-system cardano-system - -"
      "d /var/cardano-system/${cfg.network.name}/chain-index   0770 cardano-system cardano-system - -"
    ];
  };
}
