# terraform-azurerm-gkvm-template
Holds workflows and other files that can be used in GKVMs.

This repo has an action that pulls in the required files from [Azure/terraform-azurerm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template) regularly.
You can define both source and target of the copy job in `files.json`.
It contains a JSON object with two sub objects: `copy` and `protected`.
The latter files cannot be overwritten by the script, even if defined in `copy`.

The Github Action is scheduled daily at 07:27 UTC and does nothing if upstream files haven't changed.
Additionally, it starts the copy-job once a PR is merged to this repo.