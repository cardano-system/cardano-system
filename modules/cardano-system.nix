{config, pkgs, lib, inputs, ...}:

let cfg = config.services.cardano-system;

in

with lib;

{

  options = {
    services.cardano-system = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Start a cardano system suite.
        '';
      };
      socketPath = mkOption {
        type = types.path;
        default = "/var/cardano-node/node.sock";
        description = ''
          The node socket
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.cardano-node = {
      enable = true;
      environment = "mainnet";
      rtsArgs = ["-N"];
      port = 9082;
      socketPath = cfg.socketPath;
    };
  };
}
