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

    # tree-sitter
    tree-sitter # see bindings: https://tree-sitter.github.io/tree-sitter/

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

  #nix.settings.experimental-features = [ "nix-command" "flakes" ];
  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
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

      extraConfig = ''
	" Leader
	let mapleader = ","
        
        " turn relative line numbers on
        set relativenumber
        set number
        set rnu
        
        " Add cursor line and column
        set cursorline
        set cursorcolumn
        set colorcolumn=80,120
        highlight ColorColumn ctermbg=0 guibg=lightgrey
        
        " vsplit
        " USE ':vs' and ':sp'
        "nmap <silent> <leader>sv :vsplit<cr>
        "nmap <silent> <leader>sh :split<cr>
        
        " Tab behavior for different file formats
        autocmd FileType robot          setlocal shiftwidth=8 softtabstop=8 tabstop=8 noexpandtab
        autocmd FileType c,cpp          setlocal shiftwidth=8 softtabstop=8 tabstop=8 noexpandtab
        autocmd FileType python         setlocal shiftwidth=4 softtabstop=4 expandtab
        autocmd FileType html           setlocal shiftwidth=2 softtabstop=2 expandtab
        autocmd FileType javascript     setlocal shiftwidth=2 softtabstop=2 expandtab
        autocmd FileType css            setlocal shiftwidth=2 softtabstop=2 expandtab
        autocmd FileType yaml           setlocal shiftwidth=2 softtabstop=2 expandtab textwidth=100
        autocmd FileType markdown       setlocal shiftwidth=2 softtabstop=2 noexpandtab textwidth=100
        autocmd FileType nix            setlocal shiftwidth=2 softtabstop=2 noexpandtab textwidth=100
        
        " quickfix window full width
        :autocmd FileType qf wincmd J
        
        " Support listchars
        set listchars=eol:¬,trail:·,tab:▸·
        nmap <leader>lc :set invlist<cr>
        
        " Highlight trailing whitespaces and spaces before tabs
        :highlight ExtraWhitespace ctermbg=red guibg=red
        :autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
        
        " Paragraph width using 'par' command
        set formatprg=par\ -w80
        
        " Languages spell
        nmap <leader>sf :setlocal spell spelllang=fr
        nmap <leader>se :setlocal spell spelllang=en_us
        
        " languages spell tips:
        "
        "   z= sur un mot souligné affiche une liste de corrections possibles
        "   zg rajoute un mot dans le dictionnaire
        "   zug pour annuler l’ajout au dictionnaire
        "   ]s pour aller au prochain mot mal orthographié
        "   [s pour le précédent

	""" PLUGIN KEY MAPPING """
	" NerdTree
	nmap <leader>nn :NERDTreeToggle<cr>
	nmap <leader>nb :NERDTreeFromBookmark<Space>
	nmap <leader>nf :NERDTreeFind<cr>

	" fzf-lua
	nnoremap <leader>fr <cmd>lua require('fzf-lua').resume()<CR>
	nnoremap <leader>fb <cmd>lua require('fzf-lua').builtin()<CR>
	nnoremap <leader>ff <cmd>lua require('fzf-lua').files()<CR>
	nnoremap <leader>fg <cmd>lua require('fzf-lua').grep()<CR>

      '';
      
      plugins = with pkgs.vimPlugins; [
	{
	  plugin = fzf-lua;
	  config = ''
	    nnoremap <c-P> <cmd>lua require('fzf-lua').files()<CR>
	    nnoremap <c-F> <cmd>lua require('fzf-lua').builtin()<CR>
	  '';
	}


	#nvim-dap # This would require some setup, to use debug-adapter-protocol (dap)
	vim-startify

	# tmux integration
        vim-tmux-navigator
	#vimux # run commans in tmux from vim
	#tmux-nvim # TBD

	# style
	nvim-web-devicons

	# lightline
	lightline-bufferline
	lightline-lsp # todo: check if this config is good.... https://github.com/spywhere/lightline-lsp/
	{
	  plugin = lightline-vim;
	  config = ''
	    let g:lightline = {
		  \ 'colorscheme': 'wombat',
		  \ 'active': {
		  \   'left': [ ['mode', 'paste'],
		  \             ['fugitive', 'readonly', 'filename', 'modified'] ],
		  \   'right': [ [ 'lineinfo' ], ['percent'] ]
		  \ },
		  \ 'tabline': {
		  \   'left': [ ['buffers']  ],
		  \   'right': [ ['close']  ]
		  \ },
		  \ 'component': {
		  \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
		  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
		  \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
		  \ },
		  \ 'component_visible_condition': {
		  \   'readonly': '(&filetype!="help"&& &readonly)',
		  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
		  \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
		  \ },
		  \ 'component_expand': {
		  \   'buffers': 'lightline#bufferline#buffers',
		  \   'linter_hints': 'lightline#lsp#hints',
		  \   'linter_infos': 'lightline#lsp#infos',
		  \   'linter_warnings': 'lightline#lsp#warnings',
		  \   'linter_errors': 'lightline#lsp#errors',
		  \   'linter_ok': 'lightline#lsp#ok'
		  \ },
		  \ 'component_type': {
		  \   'buffers': 'tabsel',
		  \   'linter_hints': 'right',
		  \   'linter_infos': 'right',
		  \   'linter_warnings': 'warning',
		  \   'linter_errors': 'error',
		  \   'linter_ok': 'right'
		  \ },
		  \ 'separator': { 'left': ' ', 'right': ' ' },
		  \ 'subseparator': { 'left': ' ', 'right': ' ' }
		  \ }

	    let g:lightline#bufferline#show_number=1
	    let g:lightline#bufferline#clickable=1
	    let g:lightline.component_raw = {'buffers': 1}
	  '';
	}

	# utility
	vim-matchup # '%' match syntaxic elements
        {
          plugin = nerdtree;
          config = ''
            let g:NERDTreeWinPos = "right"
            let NERDTreeShowHidden=0
            let NERDTreeIgnore = ['\.pyc$', '__pycache__']
            let g:NERDTreeWinSize=35
          '';
        }

	# tpopope ... because that's just how good
	vim-speeddating
	vim-fugitive
	vim-surround
	vim-commentary
	#vim-dadbod # db management would need to learn
	#vim-dispatch # can run command in tmux from vim, maybe start pytest?

	# Syntax
	nvim-treesitter.withAllGrammars

	# Languages
        vim-nix
	vim-tmux
	robotframework-vim

	# lsp
	nvim-lspconfig


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
	hm = "home-manager";
	hme = "home-manager edit";
	hms = "home-manager switch";
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

    git = {
      enable = true;
      userName = "Laurier Loiselle";
      userEmail = "lal@xiphos.com";
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
