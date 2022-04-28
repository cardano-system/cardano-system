{ pkgs, config, lib, ... }:
let
  cfg = config.services.cardano-system.library;

  wallet-backend = "http://localhost:${toString config.services.cardano-wallet.port}";

  postJSON = data: url: "${pkgs.curl}/bin/curl -H \"Content-Type: application/json\" -X POST -d ${data} ${url}";

  getJSON = url: "${pkgs.curl}/bin/curl ${url} | ${pkgs.jq}/bin/jq";

  getWallets = getJSON "${wallet-backend}/v2/wallets";

  createWallet = data: postJSON data "${wallet-backend}/v2/wallets";

  getWalletsBin = pkgs.writers.writeBashBin "wallets" getWallets;

  createWalletBin = pkgs.writers.writeBashBin "add-wallet" ''
    ${createWallet "@$1"}
  '';

in

with lib;

rec {
  options = {
    services.cardano-system.library = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      getWalletsBin
      createWalletBin
    ];
  };
}
