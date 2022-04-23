{ config, pkgs, lib, ... }:

let cfg = config.services.plutus-chain-index;

in

with lib;

{
  options = {
    services.plutus-chain-index = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Start a plutus-chain-index
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.cardano-system.plutus-chain-index;
        description = ''
          The plutus-chain-index package to use
        '';
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/cardano-system/chain-index/chain-index.db";
        description = ''
          The database store
        '';
      };
      socket-path = mkOption {
        type = types.path;
        default = config.services.cardano-node.socket-path;
        description = ''
          The node socket
        '';
      };
      append-transaction-queue-size = mkOption {
        type = types.int;
        default = 1000;
        description = ''
          The --append-batch-size arg
        '';
      };
      network-id = mkOption {
        type = types.int;
        default = 764824073;
        description = ''
          Magic network id
        '';
      };
      port = mkOption {
        type = types.port;
        default = 9083;
        description = ''
          The port to run on
        '';
      };
      user = mkOption {
        type = types.str;
        default = config.services.cardano-node.user;
        description = ''
          The user to run the systemd service
        '';
      };
      group = mkOption {
        type = types.str;
        default = config.services.cardano-node.group;
        description = ''
          The group to run the systemd service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.plutus-chain-index = {
      enable = true;
      after = [ "cardano-node.service" ];
      description = "Plutus Chain Index";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/plutus-chain-index start-index  --db-path ${cfg.database-path} --socket-path ${cfg.socket-path} --port ${toString cfg.port} --append-transaction-queue-size ${toString cfg.append-transaction-queue-size} --network-id ${toString cfg.network-id}";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
