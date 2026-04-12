{ ... }:

{
  services.zrepl = {
    enable = true;

    settings = {
      global.logging = [
        {
          type = "stdout";
          level = "info";
          format = "human";
          time = false;
          color = false;
        }
      ];

      jobs = [
        {
          name = "local-sink";
          type = "sink";

          root_fs = "tank/zrepl";

          serve = {
            type = "local";
            listener_name = "localsink";
          };
        }

        {
          name = "snap-tank-home";
          type = "snap";

          filesystems = {
            "tank/home" = true;
          };

          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            interval = "1h";
          };

          pruning.keep = [
            {
              type = "grid";
              regex = "^zrepl_.*";
              grid = "24x1h | 7x1d | 4x7d";
            }
          ];
        }

        {
          name = "snap-tank-raid";
          type = "snap";

          filesystems = {
            "tank/raid" = true;
          };

          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            interval = "1h";
          };

          pruning.keep = [
            {
              type = "grid";
              regex = "^zrepl_.*";
              grid = "24x1h | 7x1d | 4x7d | 6x30d";
            }
          ];
        }

        {
          name = "snap-tank-games";
          type = "snap";

          filesystems = {
            "tank/games" = true;
          };

          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            interval = "1d";
          };

          pruning.keep = [
            {
              type = "grid";
              regex = "^zrepl_.*";
              grid = "7x1d | 4x7d";
            }
          ];
        }

        {
          name = "nvme-to-tank";
          type = "push";

          connect = {
            type = "local";
            listener_name = "localsink";
            client_identity = "bulldozer";
          };

          filesystems = {
            "nvme<" = true;
            "nvme/reserved" = false;
            "nvme/reserved<" = false;
          };

          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            interval = "1h";
          };

          pruning = {
            keep_sender = [
              { type = "not_replicated"; }
              {
                type = "regex";
                negate = true;
                regex = "^zrepl_.*";
              }
            ];

            keep_receiver = [
              {
                type = "grid";
                regex = "^zrepl_.*";
                grid = "24x1h | 7x1d | 4x7d";
              }
            ];
          };
        }
      ];
    };
  };
}
