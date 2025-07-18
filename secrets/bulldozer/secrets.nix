{
  sops.secrets.mlabs-vpn = {
    format = "binary";
    sopsFile = ./wireguard/mlabs-vpn.wg;
    restartUnits = ["wireguard-wg0.service"];
  };
}
