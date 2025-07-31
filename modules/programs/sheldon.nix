{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.sheldon;
  tomlFormat = pkgs.formats.toml { };
  sheldonCmd = "${config.package}/bin/sheldon";
in {
  meta.maintainers = with maintainers; [ Kyure-A mainrs ];

  options.programs.sheldon = {
    enable = mkEnableOption "sheldon";

    package = mkOption {
      type = types.package;
      default = pkgs.sheldon;
      defaultText = literalExpression "pkgs.sheldon";
      description = "The package to use for the sheldon binary.";
    };

    settings = mkOption {
      inherit (tomlFormat) type;
      default = { };
      description = "";
      example = literalExpression "";
    };

    enableZshIntegration =
      hm.shell.mkZshIntegrationOption { inherit config; };

    enableBashIntegration =
      hm.shell.mkBashIntegrationOption { inherit config; };

    enableFishIntegration =
      hm.shell.mkFishIntegrationOption { inherit config; };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."sheldon/plugins.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "sheldon-config" cfg.settings;
    };

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      eval "$(sheldon source)"
      eval "$(sheldon completions --shell=bash)"
    '';

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      eval "$(sheldon source)"
      eval "$(sheldon completions --shell=zsh)"
    '';

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
      eval "$(sheldon source)"
      eval "$(sheldon completions --shell=fish)"
    '';
  };
}
