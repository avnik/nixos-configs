{
  sops.secrets.froggy-wifi-password = {
    sopsFile = ./wifi.yaml;
    key = "password";
  };
}
