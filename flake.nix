{
  description = "Factgenie devenv flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = { self, nixpkgs, flake-utils }:
  # Equivalent* to:
  # systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  # forEachSystem = nixpkgs.lib.genAttrs systems;
  # forEachSystem (system: ...)
  # * it does some rearranging so the attributes are in the right order.
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    # python = pkgs.python311;
    python-packages = pkgs.python311Packages;
    # venvDir = ".venv";
    inherit (pkgs.callPackages ./dependencies.nix { inherit python-packages; }) pypi;

    # python-with-packages = (python.withPackages (p: with p; [
    #   apscheduler
    #   coloredlogs
    #   cvxpy
    #   datasets
    #   flask
    #   google-api-python-client
    #   litellm
    #   lxml
    #   markdown
    #   natsort
    #   numba
    #   openai
    #   plotly
    #   pyannote-core
    #   pyannote-database
    #   pyannote-metrics
    #   pyannote-pipeline
    #   pypi.flask-apscheduler
    #   pypi.flask-sse
    #   pypi.google-cloud-aiplatform
    #   pypi.json2table
    #   pypi.pygamma-agreement
    #   pypi.tinyhtml
    #   python-slugify
    #   pyyaml
    #   requests
    #   scipy
    # ]));

    # start = pkgs.writeScriptBin "factgenie_start.nu" ''
    #   #!${pkgs.nushell}/bin/nu
    #   $env.PATH = $env.PATH | append ("${factgenie.startExtraPath}" | split row :)

    #   cd factgenie
    #   print (gpg --version)

    #   # Create virtualenv if doesn't exist
    #   if not ("./${venvDir}" | path exists) {
    #     print "creating venv..."
    #     virtualenv "./${venvDir}" --python="${factgenie.python-with-packages}/bin/python3" --system-site-packages
    #     $env.PYTHONHOME = "${factgenie.python-with-packages}"  # This has to be set AFTER creating virtualenv but BEFORE installing requirements. That is because the --system-site-packages tells the virtualenv to use system packages when they are available (such as the tricky numpy package).
    #     print "installing dependencies... ('pip install -e .')"
    #     ${venvDir}/bin/pip install -e .
    #   }

    #   $env.PYTHONHOME = "${factgenie.python-with-packages}"
    #   source '${factgenie.set-secrets}/bin/set_secrets.nu'
    #   ${venvDir}/bin/python3 ${venvDir}/bin/factgenie run --host=0.0.0.0 --port=8890
    # '';

    # factgenie = python-packages.buildPythonApplication {
    #   pname = "factgenie";
    #   version = "1.1.0";
    #   src = ./.;
    #   # Propagated = anything that uses factgenie will also see these
    #   build-system = [
    #     python-packages.setuptools
    #   ];
      
    #   propagatedBuildInputs = with python-packages; [
    #     apscheduler
    #     pyannote-core
    #     pyannote-database
    #     pyannote-metrics
    #     pyannote-pipeline
    #     pypi.flask-apscheduler
    #     pypi.flask-sse
    #   ];

    #   dependencies = with python-packages; [
    #     coloredlogs
    #     cvxpy
    #     datasets
    #     litellm
    #     lxml
    #     markdown
    #     matplotlib
    #     natsort
    #     numba
    #     openai
    #     plotly
    #     pypi.json2table
    #     pypi.pygamma-agreement
    #     pypi.tinyhtml
    #     python-slugify
    #     pyyaml
    #     requests
    #     scipy
    #   ];

    #   doCheck = false;
    #   pyproject = true;
    #   # format = "pyproject";
    # };
  in
  {
    packages.default = pypi.factgenie;
  }
  );
}
