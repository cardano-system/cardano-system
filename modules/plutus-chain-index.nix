{config, pkgs, lib, inputs, ...}:

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
        description = ''
          The plutus-chain-index package to use
        '';
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/plutus-chain-index/chain-index.db";
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
      append-batch-size = mkOption {
        type = types.int;
        default = 15000;
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
    };
  };

  config = mkIf cfg.enable {
    systemd.services.plutus-chain-index = {
      enable = true;
      description = "Plutus Chain Index";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
         ExecStart = "${cfg.package}/bin/plutus-chain-index start-index  --db-path ${cfg.database-path} --socket-path ${cfg.socket-path} --port ${toString cfg.port} --append-queue-size ${toString cfg.append-batch-size} --network-id ${toString cfg.network-id}";
        Restart="on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
