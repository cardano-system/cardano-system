{config, pkgs, lib, inputs, ...}:

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
      };
      topology-file = mkOption {
        type = types.path;
        description = ''
          The json topology file.
        '';
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/cardano-node/";
        description = ''
          The database store
        '';
      };
      socket-path = mkOption {
        type = types.path;
        default = "/var/cardano-node/node.sock";
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
        Restart="on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
