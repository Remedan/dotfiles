{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.mpd;
in
{
  options.user-modules.mpd = {
    enable = mkEnableOption "MPD";
    musicDirectory = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };
  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
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
    } // optionalAttrs (cfg.musicDirectory != null) {
      musicDirectory = cfg.musicDirectory;
    };
    programs.ncmpcpp.enable = true;
  };
}
