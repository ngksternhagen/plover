with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "env";

  # Mandatory boilerplate for buildable env
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';

  # Customizable development requirements
  buildInputs = [

    # With Python configuration requiring a special wrapper
    (python35.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python35Packages; [
        Babel
        appdirs
        hidapi
        mock
        pyserial
        pytest
        # python-xlib
        setuptools
        # setuptools-scm
        six
      ];
    })
  ];

  shellHook = ''
    echo "shell hook ran..."
  '';
}
