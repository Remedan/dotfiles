{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.yubikey;
in
{
  options.user-modules.yubikey = {
    enable = mkEnableOption "YubiKey";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };
    programs.zsh.initExtra = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';
  };
}
