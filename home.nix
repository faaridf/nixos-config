{ config, pkgs, ... }:

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
			nhs = "nh search --channel=nixos-unstable;"
		}
	}

  home.file.".config/qtile".source = ./config/qtile;
  home.file.".config/nvim".source = ./config/nvim;

  home.packages = with pkgs; [
    mpvScripts.mpris
    mpvScripts.thumbfast
    mpvScripts.mpv-webm
    mpvScripts.webtorrent-mpv-hook
    # ladybird
		kitty
  ];
}
