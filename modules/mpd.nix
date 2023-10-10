{ config, lib, ... }:
with lib;
let
  cfg = config.modules.mpd;
in
{
  options.modules.mpd = {
    enable = mkEnableOption "MPD";
    musicDirectory = mkOption {
      type = types.str;
      default = config.services.mpd.musicDirectory;
    };
  };
  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = cfg.musicDirectory;
      extraConfig = ''
        audio_output {
            type    "pipewire"
            name    "PipeWire Sound Server"
        }

        audio_output {
            type    "fifo"
            name    "my_fifo"
            path    "/tmp/mpd.fifo"
            format  "44100:16:2"
        }
      '';
    };
    programs.ncmpcpp.enable = true;
  };
}
