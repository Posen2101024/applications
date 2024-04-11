# applications

Quickly set up automation for pushing Docker images and Helm charts to a container registry using [dock-cli](https://pypi.org/project/dock-cli/).

This repository accomplishes the following things:

1. Pull requests will check if the modified Docker images or Helm charts can be built or packaged successfully.
2. Merging pull requests into master will automatically push the modified Docker images and Helm charts to the specified registry.
