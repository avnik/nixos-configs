{ config, pkgs, ... }:
{
    services.taskserver = {
        enable = true;
        organisations = {
            personal = {
                users = [ "avn" ];
                groups = [ "humans" ];
            };
        };
    };
}
