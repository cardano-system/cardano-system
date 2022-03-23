{ pkgs, config, ... }:
let
  wallet-backend = "http://localhost:${toString config.services.cardano-wallet.port}";

  postJSON = data: url: "${pkgs.curl}/bin/curl -H \"Content-Type: application/json\" -X POST -d ${data} ${url}";

  getJSON = url: "${pkgs.curl}/bin/curl ${url} | ${pkgs.jq}/bin/jq";

  getWallets = getJSON "${wallet-backend}/v2/wallets";

  getWalletsBin = pkgs.writers.writeBashBin "wallets" getWallets;

in
rec {
  config = {
    environment.systemPackages = [
      getWalletsBin
    ];
  };
}
