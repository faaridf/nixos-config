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
  };

	programs.bash = {
		enable = true;
		shellAliases = {
			cf = "clear && fastfetch";
			gg = "echo wow, so cool";
		};
		#profileExtra = ''
		#	if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
		#		exec uwsm start select hyprland-uwsm.desktop
		#	fi
		#'';
	};
	home.file.".config/qtile".source = ./config/qtile;
	home.file.".config/nvim".source = ./config/nvim;


	home.packages = with pkgs; [
		neovim
		ripgrep
		nil
		nixpkgs-fmt
		nodejs
		gcc
		nh
		nvd
		nix-output-monitor
		tealdeer
		mpvScripts.mpris
		mpvScripts.thumbfast
		mpvScripts.mpv-webm
		mpvScripts.webtorrent-mpv-hook
    ladybird
    wl-clipboard
	];
}
