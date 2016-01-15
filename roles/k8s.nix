{ config, pkgs, ... }:

{
    services.kubernetes = {
        roles = ["master" "node"];
    };
}
