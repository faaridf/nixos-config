{
  config,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  home.username = "niko";
  home.homeDirectory = "/home/niko";
  programs.git = {
    enable = true;
    userName = "niko";
    userEmail = "173501018+faaridf@users.noreply.github.com";
  };
  home.stateVersion = "26.05";
  #home.stateVersion = 25.11;

  home.sessionVariables = {
    NH_FLAKE = "/home/niko/nixos-dots";
    NH_DEFAULT_CHANNEL = "nixos-26.05";
  };

  # programs.bash = {
  #   enable = true;
  #   shellAliases = {
  #     cf = "clear && fastfetch";
  #     gg = "echo wow, so cool";
  #   };
  # };

  programs.fish = {
    enable = true;
    shellAliases = {
      cf = "clear && fastfetch";

      # unstable nh search
      nhs = "nh search --channel=nixos-unstable";
    };
  };

  home.file.".config/qtile".source = ./config/qtile;
  # home.file.".config/nvim".source = ./config/nvim;
  # home.file.".config/fish".source = ./config/fish;

  xdg.configFile."nvim" = {
    # source = config.lib.file.mkOutOfStoreSymlink "/home/niko/nixos-dots/config/nvim/";
    source = create_symlink "${dotfiles}/nvim";
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = create_symlink "${dotfiles}/kitty";
    recursive = true;
  };

  # xdg.configFile."fish" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "/home/niko/nixos-dots/config/fish/";
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    mpvScripts.mpris
    mpvScripts.thumbfast
    mpvScripts.mpv-webm
    mpvScripts.webtorrent-mpv-hook
    # ladybird
    kitty
    # vscodium
    unstable.vesktop
  ];

  programs.vscodium = {
    enable = true;
    # package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      kamadorueda.alejandra

    ];

    profiles.default.userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "alejandra";
      # "nix.serverSettings" = {
      #   "nil" = {
      #     # "formatting" = {
      #     #   "command" = [ "alejandra" ];
      #     # };
      #   };
      # };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
        "editor.validate.enable" = true;
      };
      "update.showReleaseNotes" = false;
      "editor.fontFamily" = "'Mononoki Nerd Font', monospaced Font";
      "editor.wordWrap" = "on";
    };
  };
}
