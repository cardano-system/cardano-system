{ pkgs, config, lib, ... }:

let cfg = config.services.cardano-system;

in

with lib;
{
  options = {
    services.cardano-system = {
      enable = mkOption {
        default = false;
        types = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    services.plutus-chain-index.enable = true; 
    services.cardano-wallet.enable = true; 
    services.cardano-node.enable = true; 
    users = {
      groups.cardano-system.gid = 8020;
      users.cardano-system =
        { group = "cardano-system";
          shell = "${pkgs.bash}/bin/bash";
          uid = 8020;
          isSystemUser = true;
        };
    };
    systemd.tmpfiles.rules = [
      "d /var/cardano-system                           0770 cardano-system cardano-system - -"
      "d /var/cardano-system/node                      0770 cardano-system cardano-system - -"
      "d /var/cardano-system/wbe                       0770 cardano-system cardano-system - -"
      "d /var/cardano-system/chain-index               0770 cardano-system cardano-system - -"
    ];
  };
}
