{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.git;
in
{
  options.user-modules.git = {
    enable = mkEnableOption "Git";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";

        gpg = {
          format = "ssh";
          ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
          ssh.allowedSignersFile = "~/.config/git/allowed_signers";
        };
      };

      userName = "Vojtěch Balák";
      userEmail = "vojtech@balak.me";

      signing.signByDefault = true;
      signing.key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrvW1wIRC7BJ6Hp7NUlO4q4VUQPze2Gn+XstOOgL81PC/Rkkp2awx33suCkLvxdNL5YyXiw8N0JmFA4DsjWhFXnQuNAtMB01CICUVwexTxw8ZtmEOOcY5xwNaK/xfbl5+QCNgq0bEl3SBYmfnh2sNXHHMQNchPIjYZtLLzZ7QTDZrjOTmeqr0otmH6JK8oo/f/8G2/9NkY75GDcjwaPv6R4aH7nlO4hehLp58bYo3A/u7hcrvXz77h8On9mDyLu1u/LkH7rqBxjYfvNAqInCxT7BWb4YDci0Ho8c5NkRuHADzmkR6uViwCmJHWccu9yX5JddC9ySmsATuRlNBab9VD";
    };
    xdg.configFile."git/allowed_signers".text = ''
      vojtech@balak.me ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrvW1wIRC7BJ6Hp7NUlO4q4VUQPze2Gn+XstOOgL81PC/Rkkp2awx33suCkLvxdNL5YyXiw8N0JmFA4DsjWhFXnQuNAtMB01CICUVwexTxw8ZtmEOOcY5xwNaK/xfbl5+QCNgq0bEl3SBYmfnh2sNXHHMQNchPIjYZtLLzZ7QTDZrjOTmeqr0otmH6JK8oo/f/8G2/9NkY75GDcjwaPv6R4aH7nlO4hehLp58bYo3A/u7hcrvXz77h8On9mDyLu1u/LkH7rqBxjYfvNAqInCxT7BWb4YDci0Ho8c5NkRuHADzmkR6uViwCmJHWccu9yX5JddC9ySmsATuRlNBab9VD
    '';
  };
}
