# kubernetes.sh

Export kubernetes variables

## Description

Export variable `KUBECONFIG` to tell kubernetes where the kube_config file
is stored.
Export variable `KUBE_ENV`, useless for kubernetes, only usefull if you use
it in your shell prompt.

Parameters in `.envrc.ini` are:

| Name          | Description                                         |
| :------------ | :-------------------------------------------------- |
| `KUBECONFIG`  | Absolute path to a kubernetes kube_config file      |

## Parameters

### `KUBECONFIG`

Absolute path to a `kube_config` file, if not set a file `kube_config` will
be searched from the `${DIRENV_ROOT}`.

## `.envrc.ini` example

Corresponding entry in `.envrc.ini.template` are:

```ini
# Kubernetes module
# ------------------------------------------------------------------------------
# Set Kubernetes environment variable
[kubernetes]
# Path to a specific kubeconfig file relatively to the root of the direnv. If
# not set, will find for file with kube_config in their name and take the first
# result.
KUBECONFIG=path/to/kube_config
```



## kubernetes()
deactivate_kubernetes()

 **Export variables for kubernetes**
 
 Export variable `KUBECONFIG` to tell kubernetes where the kube_config file
 is stored.
 Export variable `KUBE_ENV`, useless for kubernetes, only usefull if you use
 it in your shell prompt.

 **Globals**

 - `KUBECONFIG`
 - `KUBE_ENV`
 - `KUBECONFIG`
 - `KUBE_ENV`

## deactivate_kubernetes()

 **Unset exported variables for kubernetes module**
 
 Unset `KUBECONFIG` and `KUBE_ENV` variables previously exported.

 **Globals**

 - `KUBECONFIG`
 - `KUBE_ENV`
