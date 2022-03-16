{config, pkgs, lib, inputs, ...}:

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
        description = ''
          The cardano-wallet package to use.
        '';
      };
      database-path = mkOption {
        type = types.path;
        default = "/var/cardano-wallet/";
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
      port = mkOption {
        type = types.port;
        default = 9081;
        description = ''
          The port to run on
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cardano-wallet = {
      enable = true;
      description = "Cardano Wallet";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cardano-wallet serve --mainnet --database ${cfg.database-path} --node-socket ${cfg.socket-path} --port ${toString cfg.port}";
        Restart="on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
