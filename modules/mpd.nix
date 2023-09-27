{ lib, mpd, ... }:
lib.recursiveUpdate
{
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
  };
  programs.ncmpcpp.enable = true;
}
  mpd.override or { }
