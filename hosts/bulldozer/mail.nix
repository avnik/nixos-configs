{ config, pkgs, lib, ... }:

let
  maildropWrapper = pkgs.writeScript "maildrop-wrapper" ''
    #!${pkgs.bash}/bin/sh -e
    PATH="${pkgs.maildrop}/bin:${pkgs.notmuch}/bin:${pkgs.coreutils}/bin:/bin:/usr/bin"
    export PATH
    ${pkgs.maildrop}/bin/maildrop "$@" || exit 75
  '';
  rspamdLocalConfig = ''
        classifier "bayes" {
          autolearn = true;
        }
    #    dkim_signing {
    #      path = "/var/lib/rspamd/dkim/$domain.$selector.key";
    #      selector = "default";
    #      allow_username_mismatch = true;
    #    }
    #    arc {
    #      path = "/var/lib/rspamd/dkim/$domain.$selector.key";
    #      selector = "default";
    #      allow_username_mismatch = true;
    #    }
        milter_headers {
          use = ["authentication-results", "x-spam-status"];
          authenticated_headers = ["authentication-results"];
        }
        replies {
          action = "no action";
        }
        url_reputation {
          enabled = true;
        }
        phishing {
          openphish_enabled = true;
          phishtank_enabled = true;
        }
  '';
in
{
  services = {
    dovecot2 = {
      enable = true;
      enableImap = true;
      enablePop3 = false;
      mailLocation = "maildir:/mnt/maildir/%u";
      #modules = [ pkgs.dovecot_pigeonhole ];
    };
    postfix = {
      enable = true;
      hostname = "bulldozer";
      domain = "avnik.info";
      destination = [ "bulldozer.avnik.info" "bulldozer.home" "daemon.hole.ru" "avnik.info" "mareicheva.info" "master" "bulldozer" "alexawm.com" ];
      rootAlias = "avn";
      postmasterAlias = "avn";
      origin = "avnik.info";
      relayHost = "172.16.228.1";
      networks = [ "172.16.228.0/24" ];
      extraConfig = ''
        mailbox_size_limit = 512000000
        local_destination_concurrency_limit = 1
        local_destination_recipient_limit = 1
        soft_bounce = yes
        forward_path =
          /etc/users/$user/forward
          /home/$user/.forward
        milter_default_action = accept  
      '';
      extraAliases = ''
        awm: avn
        alexawm: avn
        hans.black: avn
      '';
    };
    rspamd = {
      enable = true;
      postfix.enable = true;
      extraConfig = ''
        ${rspamdLocalConfig}
      '';
      workers.controller = {
        extraConfig = ''
          count = 1;
          static_dir = "''${WWWDIR}";
          password = "$2$cifyu958qabanmtjyofmf5981posxie7$dz3taiiumir9ew5ordg8n1ia3eb73y1t55kzc9qsjdq1n8esmqqb";
          enable_password = "$2$cifyu958qabanmtjyofmf5981posxie7$dz3taiiumir9ew5ordg8n1ia3eb73y1t55kzc9qsjdq1n8esmqqb";
        '';
      };
      workers.rspamd_proxy = {
        extraConfig = ''
          milter = yes; # Enable milter mode
          timeout = 120s; # Needed for Milter usually
          count = 1; # Do not spawn too many processes of this type
        '';
      };
    };
  };

  environment = {
    etc = {
      "users/kris/forward" = {
        text = "|${pkgs.dovecot}/libexec/dovecot/dovecot-lda";
        mode = "0444";
        user = "kris";
      };
      "users/olga/forward" = {
        text = "|${pkgs.dovecot}/libexec/dovecot/dovecot-lda";
        mode = "0444";
        user = "olga";
      };
      "users/avn/forward" = {
        text = "|${maildropWrapper}";
        mode = "0444";
        user = "avn";
      };
    };
    systemPackages = with pkgs; [
      neomutt
      procmail
      notmuch
      maildrop
    ];
  };
}
