{ ... }: {
  # Install bat via home-manager module

  programs.bat = {
    enable = true;
    catppuccin.enable = true;
    config = {
      pager = "less -FR";
      #  style = "numbers,changes,header";
    };
  };
}

