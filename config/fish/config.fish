source /usr/share/cachyos-fish-config/cachyos-config.fish
thefuck --alias | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

zoxide init fish | source
set -gx EDITOR nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
# set -gx PROTON_ENABLE_WAYLAND 0
# set -gx PROTON_NO_WM_DECORATION 0
# set -gx PROTON_USE_NTSYNC 0
#oh-my-posh init fish --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/1_shell.omp.json' | source

#################### BEGIN image display things ######################

# image display things for kitty [https://sw.kovidgoyal.net/kitty/]
#                        & wezterm [https://wezfurlong.org/wezterm/]
#
# - use 'icat $path/to/image' (in either) to display image in terminal
# - on inner workings of the image display protocols, see:
#   - for kitty:    https://sw.kovidgoyal.net/kitty/kittens/icat/
#   - for wezterm:  https://wezterm.org/cli/imgcat.html

# if we're in kitty:
if [ "$TERM" = xterm-kitty ]
    alias icat-full "kitten icat" # alias the default kitty icat behaviour to `icat-full'

    # function icat-auto
    function icat # define auto-resizing version of kitty's `icat'
        # calculate kitty window size parameters:
        set -l kittysize (kitten icat --print-window-size) # get kitty window size
        set -l kittywidth (echo $kittysize | cut -dx -f1) # extract width of kitty window
        set -l kittyheight (echo $kittysize | cut -dx -f2) # extract height of kitty window
        set -l argcount (count $argv) # count how argumnets to icat there are

        # calculate target image size parameters: [requires ImageMagick!]
        set -l imagesize (identify -format '%wx%h' "$argv[$argcount]") # `identify' is part of ImageMagick
        set -l imagewidth (echo $imagesize | cut -dx -f1) # extract width of image
        set -l imageheight (echo $imagesize | cut -dx -f2) # extract height of image
        set -l reducebyy 1.0 # initialise and set to '100%' [no change] y-axis reduction percentage
        set -l reducebyx 1.0 # initialise and set to '100%' [no change] x-axis reduction percentage

        # test if target image is bigger than kitty window
        if [ $imageheight -gt $kittyheight ] # if it's taller than the terminal window
            # divide terminal window height by image height
            set reducebyy (math $kittyheight / $imageheight)
        end
        if [ $imagewidth -gt $kittywidth ] # if it's widre than the terminal window
            # divide terminal window width by image width
            set reducebyx (math $kittywidth / $imagewidth)
        end
        if [ $reducebyy -lt $reducebyx ] # set both reducebyx, reducebyy to smallest of 2 values
            set reducebyx $reducebyy
        else
            set reducebyy $reducebyx
        end
        # calculate target image height and width to fit fully in terminal window
        set imageheight (math floor (math $reducebyy x $imageheight))
        set imagewidth (math floor (math $reducebyx x $imagewidth))

        # call the `kitten icat' kitty command using the calculated image size
        if [ "$argcount" -gt 1 ] # if the user has passed more args than just the target image filepath
            # then pass all of those separately along with `--use-window-size' parameter
            command kitten icat --use-window-size $COLUMNS,$LINES,"$imagewidth","$imageheight" $argv[1..(math (count $argv) - 1)] $argv[(count $argv)]
        else
            command kitten icat --use-window-size $COLUMNS,$LINES,"$imagewidth","$imageheight" $argv[1]
        end
    end

    # if we're in WezTerm, alias `icat' to wezterm's imgcat
else if [ "$TERM_PROGRAM" = WezTerm ]
    alias icat "wezterm imgcat"
    # NOTE: currently not sure best way of emulating kitty's default image display behaviour
    #      - mainly because I don't know how to get the WezTerm window size in a
    #        fashion that's window-manager neutral and neutral between
    #        graphical display protocol (i.e., X11 vs Wayland)

    # draft version of default kitty icat-like behaviour for `imgcat'
    # function icat-full
    #   set -l imagesize (identify -format '%w' "$argv[$argcount]")
    # end
    # alias icat-full "wezterm imgcat --width 100%"
end

#################### END image display things ######################
