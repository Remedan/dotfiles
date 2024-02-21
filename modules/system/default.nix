[
  ./common.nix
  ./nvidia.nix
] ++ (if builtins.pathExists ./local.nix then [ ./local.nix ] else [ ])
