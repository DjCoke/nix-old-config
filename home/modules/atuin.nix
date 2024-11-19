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
      search_mode = "fuzzy";
      filter_mode_shell_up_key_binding = "session";
      filter_mode = "global";
      enter_accept = true;
      #TODO:(atuin) disable when comfortable
      show_help = true;
      prefers_reduced_motion = true;
      secrets_filter = true;
      style = "compact";

      # This came from https://github.com/nifoc/dotfiles/blob/ce5f9e935db1524d008f97e04c50cfdb41317766/home/programs/atuin.nix#L2
      history_filter = [
        "^base64decode"
        "^instagram-dl"
        "^mp4concat"
      ];
    };
    # We use down to trigger, and use up to quickly edit the last entry only
    flags = [ "--disable-up-arrow" ];
  };
  programs.zsh.initExtra = ''
    # Bind down key for atuin, specifically because we use invert
    bindkey "$key[Down]"  atuin-up-search
  '';
}
