{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos-dots/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    kitty = "kitty";
    mpv = "mpv";
    yt-dlp = "yt-dlp";
    ncspot = "ncspot";
  };
in {
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
    NH_FLAKE = "/home/niko/nixos-dots"; # gonna keep my dots here its convenient
    NH_DEFAULT_CHANNEL = "nixos-26.05"; # not sure if this works
  };

  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs
    // {
      "kcminputrc".source = create_symlink "${dotfiles}/kcminputrc";
    }; # looping over the config files

  # programs.bash = {
  #   enable = true;
  #   shellAliases = {
  #     cf = "clear && fastfetch";
  #     gg = "echo wow, so cool";
  #   };
  # };

  programs.fish = {
    # switched to fish
    enable = true;
    shellAliases = {
      cf = "clear && fastfetch";

      # unstable nh search
      nhs = "nh search --channel=nixos-unstable";
    };
  };

  # home.file.".config/qtile".source = ./config/qtile;
  # home.file.".config/nvim".source = ./config/nvim;
  # home.file.".config/fish".source = ./config/fish;

  # xdg.configFile."nvim" = {
  #   # source = config.lib.file.mkOutOfStoreSymlink "/home/niko/nixos-dots/config/nvim/";
  #   source = create_symlink "${dotfiles}/nvim";
  #   recursive = true;
  # };

  # xdg.configFile."kitty" = {
  #   source = create_symlink "${dotfiles}/kitty";
  #   recursive = true;
  # };

  # xdg.configFile."mpv" = {
  #   source = create_symlink "${dotfiles}/mpv";
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    mpvScripts.mpris
    mpvScripts.thumbfast
    mpvScripts.mpv-webm
    mpvScripts.webtorrent-mpv-hook
    # ladybird #ts actually works on here idk if its built from scratch everytime
    kitty
    # vscodium #nope used below, should move it to a differernet nix but thats for #add LATER
    unstable.vesktop
    # alejandra #not needed??
  ];

  services.flatpak = {
    packages = [
      "com.github.Anuken.Mindustry" # hell yea
      "org.vinegarhq.Sober" #roblox
    ];
  };

  #vscodium with nix ide
  programs.vscodium = {
    enable = true;
    # package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      kamadorueda.alejandra # doesnt need the
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
      "git.autofetch" = "all";
    };
  };
}
