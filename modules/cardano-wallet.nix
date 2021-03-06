{ config, pkgs, lib, ... }:

let cfg = config.services.cardano-wallet;

in

with lib;

{
  options = {
    services.cardano-wallet = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Start a cardano-wallet
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.cardano-system.cardano-wallet;
        description = ''
          The cardano-wallet package to use.
        '';
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/cardano-system/wbe";
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
      byron-genesis-path = mkOption {
        type = types.path;
        default = pkgs.cardano-system.mainnet-byron-genesis;
        description = ''
           Path to the genesis file
        '';
      };
      port = mkOption {
        type = types.port;
        default = 9081;
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
    systemd.services.cardano-wallet = {
      after = [ "cardano-node.service" ];
      enable = true;
      description = "Cardano Wallet";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cardano-wallet serve --database ${cfg.database-path} --node-socket ${cfg.socket-path} --port ${toString cfg.port} --testnet ${cfg.byron-genesis-path}";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
