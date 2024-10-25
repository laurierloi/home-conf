{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lal";
  home.homeDirectory = "/home/lal";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Utilities
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # Unix tools
    bat
    delta
    entr
    ripgrep
    tig
    tree

    # tree-sitter
    tree-sitter # see bindings: https://tree-sitter.github.io/tree-sitter/

    github-copilot-cli # todo set up

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
  #  /etc/profiles/per-user/lal/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;

    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      shortcut = "b";
      terminal = "screen-256color";
      extraConfig = ''
          # to have vi copy mode from: https://superuser.com/a/693990
          unbind-key -T copy-mode-vi v
          bind-key -T copy-mode-vi 'v' send -X begin-selection     # Begin selection in copy mode.
          bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle  # Begin selection in copy mode.
          bind-key -T copy-mode-vi 'y' send -X copy-selection      # Yank selection in copy mode.
          bind-key Enter copy-mode
      ''; # Any extra configuration to add into the configuration file
      plugins = with pkgs.tmuxPlugins; [
        open
	vim-tmux-navigator
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            # see https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/restoring_programs.md
            set -g @resurrect-processes 'ssh "~python3 -m http.server"'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '30'
          '';
        }
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = (builtins.readFile ./vim/vimrc.vim);

      plugins = with pkgs.vimPlugins; [
	fzf-lua

	#nvim-dap # This would require some setup, to use debug-adapter-protocol (dap)
	vim-startify

	# tmux integration
        vim-tmux-navigator
	#vimux # run commans in tmux from vim
	#tmux-nvim # TBD

	# AI
	copilot-vim
	# 3 below use a different plugin, but seem to have interesting features
	# copilot-lua
	# copilot-cmp
	# copilot-lualine

	# Allow chat with copilot? cool stuff...
	# CopilotChat-nvim

	# linting
	ale
	# Syntax
	nvim-treesitter.withAllGrammars

	# Languages
        vim-nix
	vim-tmux
	robotframework-vim

	# lsp
	nvim-lspconfig

	# style
	nvim-web-devicons

	# lightline
	lightline-ale # todo: configure
	lightline-bufferline
	lightline-lsp # todo: check if this config is good.... https://github.com/spywhere/lightline-lsp/
	{
	  plugin = lightline-vim;
	  config = (builtins.readFile ./vim/statusline.vim);
	}

	# utility
	vim-matchup # '%' match syntaxic elements
	nerdtree

	# tpopope ... because that's just how good
	vim-speeddating
	vim-fugitive
	vim-surround
	vim-commentary
	#vim-dadbod # db management would need to learn

	#vim-dispatch # can run command in tmux from vim, maybe start pytest?


	# TBD
	# vim-prettier
	# vim-orgmode
      ];

      # to add
      # https://github.com/tpope/vim-obsession    # This will support resurrect for vim/nvim

    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      history.size=10000;
      shellAliases = { # Add aliases here
        hm = "NIXPKGS_ALLOW_UNFREE=1 home-manager --impure --flake /home/lal/sw/home-conf";
        hms = "NIXPKGS_ALLOW_UNFREE=1 home-manager --impure --flake /home/lal/sw/home-conf switch";
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "brackets"
          "cursor"
          "root"
        ];
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "jeffreytse/zsh-vi-mode"; }
        ];
      };
    };

    gpg = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Laurier Loiselle";
      userEmail = "lal@xiphos.com";
      signing = {
	signByDefault = true;
	key = "0C5C521BAEA0FD293847498252C802C1A7A0454E";
      };
      delta = {
	enable = true;
	options = {
	};
      };
    };

    starship = {
      enable = true;
      settings = {
      };
    };

    fzf = {
      enable = true;

      defaultOptions = [

      ];

      tmux.enableShellIntegration = true;
    };
  };
}
