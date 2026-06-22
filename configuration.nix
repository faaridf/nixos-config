# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
# let
#   unstable = import inputs.nixpkgs-unstable {
#     system = pkgs.stdenv.hostPlatform.system;
#     config.allowUnfree = true;
#   };
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    #packages can be put to unstable with unstable.[package] even in home
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # awesome this just works but my
  #system is currently still the same as what tony does
  # 1g boot 4g swap rest ext4
  # i guess i dont need btrfs anymore with nixos tho
  # what about swap?

  # Bootloader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";
  # boot.loader.grub.useOSProber = true;

  # Bootloader Limine
  # boot.loader.limine = {
  #   enable = true;
  #   biosSupport = true;
  #   biosDevice = "/dev/vda"; # Matches your target drive from GRUB

  #   # Optional: Limits boot menu clutter
  #   maxGenerations = 10;
  # };

  # services.getty.autologinUser = "niko";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  #networing.wireless.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # services.xserver = {
  #   enable = true;
  #   autoRepeatDelay = 200;
  #   autoRepeatInterval = 35;
  #   windowManager.qtile.enable = true;
  # };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

  #programs.hyprland = {
  #  enable = true;
  #  withUWSM = true;
  #  xwayland.enable = true;
  #};

  # Enable sound.
  # services.pulseaudio.enable = true;

  #services.pipewire = {
  #  enable = true;
  #  pulse.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.niko = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.firefox.enable = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    micro
    fastfetch
    btop
    yt-dlp
    mpv
    mpvc
    git
    # kitty
    bat
    btop
    # vscodium
    #nixfmt use alejandra
    # alejandra
    neovim
    ripgrep
    nil
    # nixfmt
    nixpkgs-fmt
    nodejs
    gcc
    nh
    nvd
    nix-output-monitor
    tealdeer
    wl-clipboard
  ];
  # i dont suppose i need anything unstable in here..

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.mononoki # love this font!! (for monospace)
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "/home/niko/nixos-dots";
    flags = [
      "--print-build-logs"
      "--commit-lock-file" # If you want to automatically commit the updated flake.lock
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
  systemd.services.nixos-upgrade.environment = {
    GIT_AUTHOR_NAME = "niko";
    GIT_AUTHOR_EMAIL = "173501018+faaridf@users.noreply.github.com";
    GIT_COMMITTER_NAME = "niko";
    GIT_COMMITTER_EMAIL = "173501018+faaridf@users.noreply.github.com";
  };
  programs.git = {
    enable = true;
    config = {
      safe.directory = "/home/niko/nixos-dots";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true; # system.copySystemConfiguration is not supported with flakes

  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  system.stateVersion = "26.05"; # Did you read the comment?
}
