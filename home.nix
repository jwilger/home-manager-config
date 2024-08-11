{ config, pkgs, stylix, lib, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;
  stylix = {
    enable = true;
    image = ./catppuccin-wallpapers/misc/cat-sound.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
  };

  news.display = "silent";

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jwilger";
  home.homeDirectory = "/home/jwilger";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.sessionVariables = {
    NIX_BUILD_SHELL = "zsh";
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "/home/jwilger/.1password/agent.sock";
  };

  home.file.".zprofile".text = ''
    if [[ "$(tty)" == "/dev/tty1" ]]; then
      Hyprland
    fi
  '';

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify
    unzip
    neovim
    tree-sitter
    gdu
    bottom
    python312
    python312Packages.pynvim
    nodePackages.nodejs
    nodePackages.neovim
    powerline
    powerline-fonts
    powerline-symbols
    git-crypt
    _1password
    _1password-gui
    gcc
    gnumake
    go
    cargo
    nerdfonts
    noto-fonts-color-emoji
    slack
    ripgrep
    font-awesome
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jwilger/etc/profile.d/hm-session-vars.sh
  #

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 200;
          on-timeout = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
    };
  };

  services.swaync = {
    enable = true;
  };

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
      style = ''
        * {
          font-size: 16;
          font-family: "JetBrainsMono Nerd Font";
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 36;
          margin-top = 5;
          mode = "dock";
          spacing = 20;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/submap"
          ];
          modules-center = [
          ];
          modules-right = [
            "cpu"
            "memory"
            "disk"
            "wireplumber"
            "custom/notification"
            "tray"
            "clock"
          ];

          cpu = {
            format = "󰻠 {usage}%";
          };

          memory = {
            format = " {percentage}%";
          };

          disk = {
            format = " {percentage_used}%";
          };

          wireplumber = {
            format = " {volume}%";
            format-muted = " {volume}%";
            max-volume = 100;
            on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          };

          clock = {
            format = " {:%H:%M}";
            format-alt = " {:%A, %B %d, %Y (%R)}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc69d'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>{}</b></span>";
                weedays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          "hyprland/workspaces" = {
            format = "{icon}";
          };

          "custom/notification" = {
            "tooltip" = false;
            "format" = "{icon} ";
            "format-icons" = {
              "notification" = " <span foreground='red'><sup></sup></span>";
              "none" = " ";
              "dnd-notification" = " <span foreground='red'><sup></sup></span>";
              "dnd-none" = "";
              "inhibited-notification" = " <span foreground='red'><sup></sup></span>";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = " <span foreground='red'><sup></sup></span>";
              "dnd-inhibited-none" = "";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "escape" = true;
          };

          tray = {
            show-passive-items = true;
            spacing = 10;
            icon-size = 21;
          };
        };
      };
    };
    hyprlock = {
      enable = true;
      settings = {
        background = {
          path = "${./catppuccin-wallpapers/misc/virus.png}";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        };

        general = {
          no_fade_in = false;
          no_fade_out = false;
          hide_cursor = false;
          grace = 0;
          disable_loading_bar = true;
        };

        input-field = {
          size = "800, 60";
          outline_thickness = 3;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0.8)";
          inner_color = "rgba(0, 0, 0, 0.0)";
          font_color = "rgb(255,255,255)";
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          placeholder_text = "<i>YOU SHALL NOT PASS...unless you have the right password, man.</i>";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            text = ''
              cmd[update:1000] echo "$(date +"%A, %B %d")"
            '';
            color = "rgba (242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            text = ''
              cmd[update:1000] echo "$(date +"%A, %B %d")"
            '';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            text = ''
              cmd[update:1000] echo "$(date +"%A, %B %d")"
            '';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }

          {
            text = ''
              cmd[update:1000] echo "$(date +"%-I:%M")"
            '';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 95;
            font_family = "JetBrainsMono Nerd Font Extrabold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];

        image = [
          {
            path = "${./profile-picture.jpg}";
            size = 400;
            border_size = 2;
            border_color = "#cdd6f4";
            position = "0, -100";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
    home-manager.enable = true;

    kitty = {
      enable = true;
      font = {
        name = lib.mkForce "JetBrainsMono Nerd Font";
        size = lib.mkForce 10.0;
      };
      settings = {
        draw_minimal_borders = "yes";
        hide_window_decorations = "yes";
      };
    };

    firefox = {
      enable = true;
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          expandFocusedSidePanel = true;
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
      };
    };
    git = {
      enable = true;
      userName = "John Wilger";
      userEmail = "john@johnwilger.com";

      ignores = [
        # ignore direv files
        ".envrc"
        ".direnv/"
      ];
      difftastic = {
        enable = true;
      };

      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${config.xdg.configFile."ssh/allowed_signers".target}";
        commit.gpgsign = true;
        merge.conflictstyle = "zdiff3";
        merge.tool = "nvimdiff";
        diff.tool = "nvimdiff";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU";
        gpg.ssh.program = "op-ssh-sign";
        log.showSignature = true;

        pull = {
          ff = "only";
        };
        push = {
          default = "current";
        };
      };
    };

    gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [
        {
          source = builtins.fetchurl {
            url = "https://github.com/web-flow.gpg";
            sha256 = "117gldk49gc76y7wqq6a4kjgkrlmdsrb33qw2l1z9wqcys3zd2kf";
          };
          trust = 4;
        }
      ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      controlMaster = "yes";
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "[╭╴](fg:#505050)$os$username$hostname$sudo$directory$git_branch$git_commit$git_state$git_metrics$git_status$jobs$memory_usage[ ](fg:#242424)$cmd_duration$fill$line_break[╰╴](fg:#505050)[$status $localip $character]($style)";
        add_newline = true;
        os = {
          format = "[$symbol ]($style)[ ]()";
          style = "fg:#AAAAAA";
          disabled = false;
          symbols = {
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "";
            CentOS = "";
            Debian = "";
            DragonFly = "🐉";
            Emscripten = "🔗";
            EndeavourOS = "";
            Fedora = "";
            FreeBSD = "";
            Garuda = "";
            Gentoo = "";
            HardenedBSD = "聯";
            Illumos = "🐦";
            Linux = "";
            Macos = "";
            Manjaro = "";
            Mariner = "";
            MidnightBSD = "🌘";
            Mint = "";
            NetBSD = "";
            NixOS = "";
            OpenBSD = "";
            OpenCloudOS = "☁️";
            openEuler = "";
            openSUSE = "";
            OracleLinux = "⊂⊃";
            Pop = "";
            Raspbian = "";
            Redhat = "";
            RedHatEnterprise = "";
            Redox = "🧪";
            Solus = "";
            SUSE = "";
            Ubuntu = "";
            Unknown = "";
            Windows = "";
          };
        };
        username = {
          format = "[ ](fg:green bold)[$user]($style)[ ]()";
          style_user = "fg:green bold";
          style_root = "fg:red bold";
          show_always = false;
          disabled = false;
        };
        hostname = {
          format = "[$ssh_symbol ](fg:green bold)[$hostname](fg:green bold)[ ]()";
          ssh_only = true;
          ssh_symbol = "";
          disabled = false;
        };
        directory = {
          format = "[ ](fg:cyan bold)[$read_only]($read_only_style)[$repo_root]($repo_root_style)[$path]($style)";
          style = "fg:cyan bold";
          home_symbol = " ~";
          read_only = " ";
          read_only_style = "fg:cyan";
          truncation_length = 3;
          truncation_symbol = "…/";
          truncate_to_repo = true;
          repo_root_format = "[ ](fg:cyan bold)[$read_only]($read_only_style)[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[ ]()";
          repo_root_style = "fg:cyan bold";
          use_os_path_sep = true;
          disabled = false;
        };
        git_branch = {
          format = "[❯ $symbol $branch(:$remote_branch)]($style)[ ]()";
          style = "fg:#E04D27";
        };
        git_commit = {
          format = "[\($hash$tag\)]($style)[ ]()";
          style = "fg:#E04D27";
          commit_hash_length = 8;
          tag_symbol = " ";
          disabled = false;
        };
        git_metrics = {
          format = "[[+\${added}/](\${added_style})[-\${deleted}](\${deleted_style})[  ]()]()";
          added_style = "fg:#E04D27";
          deleted_style = "fg:#E04D27";
          disabled = false;
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style))";
          style = "fg:#E04D27";
          conflicted = "[  \${count} ](fg:red)";
          ahead = "[ ⇡ \${count} ](fg:yellow)";
          behind = "[ ⇣ \${count} ](fg:yellow)";
          diverged = "[ ⇕ \${ahead_count}⇡ \${behind_count}⇣ ](fg:yellow)";
          up_to_date = "[ ✓ ](fg:green)";
          untracked = "[ ﳇ \${count} ](fg:red)";
          stashed = "[  \${count} ](fg:#A52A2A)";
          modified = "[  \${count} ](fg:#C8AC00)";
          staged = "[  \${count} ](fg:green)";
          renamed = "[ ᴂ \${count} ](fg:yellow)";
          deleted = "[ 🗑 \${count} ](fg:orange)";
          disabled = false;
        };
        jobs = {
          format = "[  ](fg:blue bold)[$number$symbol]($style)";
          style = "fg:blue";
          symbol = "省";
          symbol_threshold = 1;
          number_threshold = 4;
          disabled = false;
        };
        memory_usage = {
          format = "[  ](fg:purple bold)[$symbol \${ram} \${swap}]($style)";
          style = "fg:purple";
          symbol = "﬙ 北";
          threshold = 75;
          disabled = false;
        };
        cmd_duration = {
          format = "[  $duration ]($style)";
          style = "fg:yellow";
          min_time = 500;
          disabled = false;
        };
        fill = {
          style = "fg:#505050";
          symbol = "─";
        };
        status = {
          format = "[$symbol$status $hex_status  $signal_number-$signal_name ]($style)";
          style = "fg:red";
          symbol = "✘ ";
          disabled = false;
        };
        localip = {
          format = "[$localipv4 ](fg:green bold)";
          ssh_only = true;
          disabled = true;
        };
      };
    };
    tmux = {
      aggressiveResize = true;
      baseIndex = 1;
      enable = true;
      extraConfig = ''
        set -g default-terminal tmux-256color
        set -g detach-on-destroy off
        set -g set-clipboard on
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE 'vim|neovim|nvim'"
        bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
        bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
        bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
        bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
        setw -g mode-keys vi
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
        set -g other-pane-width 10
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x
        bind i last-window
        set -g renumber-windows on
        bind-key C-a send-prefix
        unbind-key C-z
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux configuration!"
        bind \\ split-window -h
        bind - split-window -v
        setw -g monitor-activity off
        set -g visual-activity on
        set-window-option -g window-active-style bg=terminal,fg=terminal
        set-window-option -g window-style bg=terminal,fg=gray
      '';
      keyMode = "vi";
      mouse = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            source ${powerline}/share/tmux/powerline.conf
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"
            set -g @catppuccin_status_modules_right "user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"
            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
        tmuxPlugins.yank
        tmuxPlugins.prefix-highlight
      ];
      shortcut = "a";
      tmuxinator.enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      history = {
        ignoreDups = true;
        share = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "keychain"
          "direnv"
          "mix"
          "pyenv"
          "gpg-agent"
        ];
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
      shellAliases = {
        # Git
        gst = "git status";
        gci = "git commit";
        gap = "git add --patch";

        # OS
        ls = "ls -lGh";
        envs = "env | sort";
        envg = "env | grep -i";

        # Random
        guid = ''uuidgen | tr "[:upper:]" "[:lower:]"'';
        publicip = "dig +short myip.opendns.com @resolver1.opendns.com";
        localip = ''ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'';

        # tmuxinator
        tma = "tmux attach";
        tm = "tmuxinator start";

        # Neovim
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";

        # GitHub CLI
        ghr = "gh run watch";

        # NixOS and Home Manager Stuff
        full-rebuild = "sudo nixos-rebuild switch && home-manager switch";
      };
      syntaxHighlighting = {
        enable = true;
      };
    };
    wlogout.enable = true;
    fuzzel = {
      enable = true;
      settings.main = {
        layer = "overlay";
        terminal = "${pkgs.kitty}/bin/kitty";
        width = 40;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "${pkgs.slack}/bin/slack"
        "${pkgs._1password-gui}/bin/1password"
      ];
      monitor = ",preferred,auto,auto";
      "$terminal" = "kitty";
      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 5;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        dim_inactive = false;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = true;
      };
      master = {
        new_status = "master";
        no_gaps_when_only = true;
      };
      misc = {
        font_family = "JetBrainsMono Nerd Font";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        focus_on_activate = true;
      };
      cursor = {
        inactive_timeout = 10;
        hide_on_key_press = true;
      };

      "$mainMod" = "SUPER";
      "$menu" = "${pkgs.fuzzel}/bin/fuzzel";
      bind = [
        "$mainMod SHIFT,Q,exec,${pkgs.wlogout}/bin/wlogout"
        "$mainMod,RETURN,exec,$terminal"

        "$mainMod, C, killactive,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, T, togglesplit,"
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };

  xdg.configFile."ssh/allowed_signers".text = ''
    john@johnwilger.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU
    johnwilger@artium.ai ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU
  '';

  xdg.configFile."fontconfig/conf.d/10-nix-fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <dir>~/.nix-profile/share/fonts/</dir>
    </fontconfig>
  '';
}
