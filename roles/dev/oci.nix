{ config, ...}:
{
  services.dockerRegistry = {
    enable = true;
    storagePath = "/mnt/data/oci-registry";
    enableDelete = true;
  };
  systemd.tmpfiles.rules = [
    "d ${config.services.dockerRegistry.storagePath} 740 ${config.users.users.docker-registry.name} ${config.users.groups.docker-registry.name}"
  ];
}
