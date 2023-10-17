{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
    in
    {
      formatter = builtins.listToAttrs (builtins.map
        (system: {
          name = system;
          value = (mkPkgs system).nixpkgs-fmt;
        }) [ "x86_64-linux" "aarch64-darwin" ]);

      homeConfigurations.vimes =
        let
          pkgs = mkPkgs "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home = {
                username = "remedan";
                homeDirectory = "/home/remedan";
              };
              xsession.profileExtra = ''
                nvidia-settings -l
              '';
              user-modules = {
                common = {
                  colorscheme = "selenized-dark";
                  terminal = "run-alacritty";
                };
                zsh.enable = true;
                alacritty.enable = true;
                emacs.enable = true;
                dunst.enable = true;
                git.enable = true;
                i3 = {
                  enable = true;
                  workspaceOutput =
                    map
                      (number: {
                        workspace = toString number;
                        output = "DP-0";
                      })
                      (pkgs.lib.range 1 3)
                    ++
                    map
                      (number: {
                        workspace = toString number;
                        output = "DP-2";
                      })
                      (pkgs.lib.range 4 10);
                  startup = [
                    {
                      command = "xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --output DP-0 --mode 1920x1080 --rate 144.00 --left-of DP-4 --primary";
                      notification = false;
                    }
                    {
                      command = "polybar b1";
                      notification = false;
                    }
                    {
                      command = "blueman-applet";
                      notification = false;
                    }
                  ];
                };
                mpd = {
                  enable = true;
                  musicDirectory = "~/Network/Media/Audio";
                };
                nixgl.enable = true;
                fonts.enable = true;
                packages.enable = true;
                polybar = {
                  enable = true;
                  bar0Override = {
                    monitor = "\${env:MONITOR:DP-0}";
                  };
                  bar1Override = {
                    monitor = "\${env:MONITOR:DP-2}";
                  };
                };
                rofi.enable = true;
                zathura.enable = true;
              };
            }
          ] ++ import ./user-modules/module-list.nix { lib = pkgs.lib; };
        };

      homeConfigurations.atuin =
        let
          pkgs = mkPkgs "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home = {
                username = "vojta";
                homeDirectory = "/home/vojta";
                packages = [
                  nix-search-cli.packages.${pkgs.system}.default
                ];
              };
              xsession.profileExtra = ''
                xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Tapping Enabled" 1
                xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Natural Scrolling Enabled" 1
              '';
              user-modules = {
                common = {
                  colorscheme = "gruvbox-dark";
                  terminal = "WINIT_X11_SCALE_FACTOR=1 run-alacritty";
                };
                zsh.enable = true;
                alacritty.enable = true;
                emacs = {
                  enable = true;
                  pythonTabs = true;
                };
                autorandr.enable = true;
                dunst.enable = true;
                i3 = {
                  enable = true;
                  appWorkspace = {
                    "1" = [{ class = "firefox"; }];
                    "2" = [{ class = "thunderbird"; }];
                    "3" = [{ class = "obsidian"; }];
                    "8" = [{ class = "Slack"; }];
                    "9" = [{ class = "Spotify"; }];
                  };
                  startup = [
                    {
                      command = "xautolock -time 30 -locker ~/.config/i3/lock.sh";
                      notification = false;
                    }
                    {
                      command = "blueman-applet";
                      notification = false;
                    }
                    {
                      command = "birdtray";
                      notification = false;
                    }
                    {
                      command = "solaar -w hide";
                      notification = false;
                    }
                    { command = "firefox"; }
                    { command = "thunderbird"; }
                    { command = "obsidian"; }
                    { command = "i3-msg 'workspace number 4; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty'"; }
                    { command = "slack"; }
                    { command = "spotify-launcher"; }
                  ];
                };
                mpd.enable = true;
                nixgl.enable = true;
                nodejs.enable = true;
                packages.enable = true;
                polybar = {
                  enable = true;
                  bar0Override = {
                    monitor = "\${env:MONITOR:DP-1-2}";
                    monitor-fallback = "\${env:MONITOR:eDP-1}";
                    monitor-strict = true;
                    font = [
                      "Symbols\ Nerd\ Font:10;2"
                      "Open Sans:pixelsize=11;2"
                      "Source\ Han\ Sans:pixelsize=10;2"
                    ];
                    modules-right = "filesystem xkeyboard cpu memory backlight battery date powermenu";
                  };
                  bar1Override = {
                    monitor = "\${env:MONITOR:DP-1-3}";
                    monitor-strict = true;
                  };
                };
                picom.enable = true;
                fonts.enable = true;
                rofi.enable = true;
                zathura.enable = true;
              };
            }
          ] ++ import ./user-modules/module-list.nix { lib = pkgs.lib; };
        };

      homeConfigurations.angua =
        let
          pkgs = mkPkgs "aarch64-darwin";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home = {
                username = "remedan";
                homeDirectory = "/Users/remedan";
              };
              user-modules = {
                common.colorscheme = "dracula";
                zsh.enable = true;
                emacs.enable = true;
              };
            }
          ] ++ import ./user-modules/module-list.nix { lib = pkgs.lib; };
        };
    };
}
