{ ... }: {
  # Install atuin via home-manager module
  programs.atuin = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    enableFishIntegration = false;

    settings = {

      inline_height = 25;
      invert = true;
      records = true;
      search_mode = "skim";
      secrets_filter = true;
      style = "compact";
    };
    # We use down to trigger, and use up to quickly edit the last entry only
    flags = [ "--disable-up-arrow" ];
  };
  programs.zsh.initExtra = ''
    # Bind down key for atuin, specifically because we use invert
    bindkey "$key[Down]"  atuin-up-search
  '';
}
