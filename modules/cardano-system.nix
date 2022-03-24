{ pkgs, config, ... }:

let cardano-system = config.services.cardano-system;

in
{
  config = {
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
    ];
  };
}
