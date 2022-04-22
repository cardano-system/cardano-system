{ config, pkgs, lib, inputs, ... }:

let cfg = config.services.cardano-node;

in

with lib;

{
  options = {
    services.cardano-node = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Start a cardano-node
        '';
      };
      package = mkOption {
        type = types.package;
        description = ''
          The cardano-node package to use.
        '';
      };
      config-file = mkOption {
        type = types.path;
        description = ''
          The json config file.
        '';
        default = "${inputs.cardano-html}/mainnet-config.json";
      };
      topology-file = mkOption {
        type = types.path;
        description = ''
          The json topology file.
        '';
        default = "${inputs.cardano-html}/mainnet-topology.json";
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/cardano-system/node";
        description = ''
          The database store
        '';
      };
      socket-path = mkOption {
        type = types.path;
        default = "/var/cardano-system/node/node.sock";
        description = ''
          The node socket
        '';
      };
      port = mkOption {
        type = types.port;
        default = 9082;
        description = ''
          The port to run on
        '';
      };
      user = mkOption {
        type = types.str;
        default = "cardano-system";
        description = "User to run cardano-node";
      };
      group = mkOption {
        type = types.str;
        default = "cardano-system";
        description = "Group to run cardano-node";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cardano-node = {
      enable = true;
      description = "Cardano Node";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cardano-node +RTS -N -- run --topology ${cfg.topology-file} --config ${cfg.config-file} --database-path ${cfg.database-path} --socket-path ${cfg.socket-path} --port ${toString cfg.port}";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.database-path;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
