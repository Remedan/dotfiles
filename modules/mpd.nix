{ lib, mpdOverrides, ... }:
{
  services.mpd = lib.recursiveUpdate
    {
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
    }
    mpdOverrides;
  programs.ncmpcpp.enable = true;
}
