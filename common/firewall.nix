{ lib, ... }:
with lib;
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };
  networking.firewall = {
    enable = true;
    rejectPackets = true;
    allowPing = true;
    extraCommands = mkBefore ''
      # Default Policy
      ip46tables -P INPUT DROP
      ip46tables -P FORWARD DROP
      # Flush Old Rules
      ip46tables -t nat -F
      ip46tables -F FORWARD
      ip46tables -F INPUT
    '';
  };
  systemd.services.firewall.postStop = mkAfter ''
    # Flush Old Rules
    ip46tables -t nat -F || true
    ip46tables -F FORWARD || true
    ip46tables -F INPUT || true
    # Undo Default Policy
    ip46tables -P INPUT ACCEPT || true
    ip46tables -P FORWARD ACCEPT || true
  '';
}
