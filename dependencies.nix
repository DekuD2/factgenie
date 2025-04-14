{ pkgs, python-packages }:

rec {
  # This function makes creating pypi derivation easier by providing the dependencies they all have in common.
  make-pypi = {pname, version, hash, dependencies ? []}: python-packages.buildPythonPackage {
    inherit pname version;
    src = python-packages.fetchPypi {
      inherit pname version hash;
    };

    nativeBuildInputs = [
      python-packages.flask
      python-packages.redis
      python-packages.six
      python-packages.setuptools
      python-packages.wheel
      python-packages.cmake
      python-packages.apscheduler
    ];

    propagatedBuildInputs = dependencies;

    dontUseCmakeConfigure = true;
    # pyproject = true;
    doCheck = false;
  };

  pypi = {
    # "> curl: (22) The requested URL returned error: 404" for some reason...
    # Except for version 1.67.0, which I found has a tag on their git: https://github.com/googleapis/python-aiplatform/tree/v1.67
    google-cloud-aiplatform = make-pypi {
      pname = "google-cloud-aiplatform";
      version = "1.67.0";
      hash = "sha256-TJc41aZti6rgHh0BUPqXKWBIGhgpwuwgYLik/hZ2iQE=";
    };
    flask-sse = make-pypi {
      pname = "Flask-SSE";
      version = "1.0.0";
      hash = "sha256-T4RxTCVJpF5PF7/F9o7oqfKYsidApoREBNHHRVHyCQ0";
    };
    flask-apscheduler = make-pypi {
      pname = "Flask-APScheduler";
      version = "1.13.1";
      hash = "sha256-uSmEbwJvszm3Y2Cw5Px12ni3XG0IYlcVvQ03lJvWB9o=";
    };
    json2table = make-pypi {
      pname = "json2table";
      version = "1.1.5";
      hash = "sha256-g45MBSJ2JS/sew29EGaCWM4Jl2BYiKJQMHvWsSSubQo=";
    };
    tinyhtml = make-pypi {
      pname = "tinyhtml";
      version = "1.2.0";
      hash = "sha256-5+43bYOlUviEmUaI3eNkcQqMsPXlyFhYfnvrCx98Bnk=";
    };
    pygamma-agreement = make-pypi {
      pname = "pygamma-agreement";
      version = "0.5.9";
      hash = "sha256-bZpFk4PhJ55AtM9WTDMld9rQubOT4pGQRKsexTeHnic=";
    };
    factgenie = make-pypi {
      pname = "factgenie";
      version = "1.1.0";
      hash = "sha256-SJJlkZ6GhLf3EQSgIwSJlddDaVSsvqv2QUm3DaMbSfM=";
      dependencies = [
        pypi.flask-apscheduler
        pypi.flask-sse
        pypi.google-cloud-aiplatform
        pypi.json2table
        pypi.pygamma-agreement
        pypi.tinyhtml
        python-packages.apscheduler
        python-packages.coloredlogs
        python-packages.cvxpy
        python-packages.datasets
        python-packages.flask
        python-packages.google-api-python-client
        python-packages.litellm
        python-packages.lxml
        python-packages.markdown
        python-packages.natsort
        python-packages.numba
        python-packages.openai
        python-packages.plotly
        python-packages.pyannote-core
        python-packages.pyannote-database
        python-packages.pyannote-metrics
        python-packages.pyannote-pipeline
        python-packages.python-slugify
        python-packages.pyyaml
        python-packages.requests
        python-packages.scipy
      ];
    };
  };

}
