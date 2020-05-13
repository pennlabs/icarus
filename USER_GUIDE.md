# User Guide

To get started with an Icarus project, we recommend you start from one of the [template repositories](https://github.com/pennlabs/templates). If you do not, however, there are only 3 files you need to get started:

- `.circleci/config.yml` - This holds all CI configuration for your project. CI is used to automatically build and deploy your project when you push. Look to the template repositories for examples of CI configurations.
- `Dockerfile` - Dockerfiles specify how to package up your application so it can be run inside a container. Look online and to the template repositories for examples of Dockerfiles.
- `k8s/values.yaml` - This is the only thing that Icarus looks at specificially. This holds your specification for how to deploy your application.

## Configuration

Below is a full list of configuration options and their default values.

- `deploy_version` (Required) - Specifies which tag of Icarus to use. To get a list of tags, go to [the Icarus releases](https://github.com/pennlabs/icarus/releases). Use the most recent one if you're not sure which to use.
- `applications` (Required) - A list of applications to run with Icarus.

Per-application configuration:

- `name` (Required) - name to give your application
- `image` (Required) - image to use for your application
- `tag` (Optional, defaults to CircleCI SHA1) - tag to use for your image
- `secret` (Optional, default `null`) - Secret from Vault to use for your application
- `cmd` (Optional, default `null`) - Command to override docker entrypoint. Provide a list of arguments for the command.
- `secretMounts` (Optional, default `null`) - list of secrets to mount as directories
  - `name` (Required) - name of secret
  - `item` (Required) - name of secret item
  - `path` (Required) - path to mount secret item in
- `replicas` (Optional, default `1`) - number of instances of your application to be run in the cluster
- `pullPolicy` (Optional, default `IfNotPresent`) - what type of [ImagePullPolicy](https://kubernetes.io/docs/concepts/containers/images/#updating-images) to use
- `extraEnv` (Optional, default `null`) - list of extra environment variables to export
  - `name` (Required) - environment variable name
  - `value` (Required) - environment variable value
- `port` (Optional, default `80`) - what port your application exposes
- `svc_type` (Optional, default `ClusterIP`) - what [service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) to use for your application. Ask someone on Platform before overriding this.
- `ingress` (Optional, default `null`) - spec for allowing external users to access your application
  - `hosts` (Required) - list of hosts to route to the ingress
    - `host` (Required) - hostname to route to this ingress
    - `paths` (Required) - list of paths to use for this host
    - `issuer_name` (Optional, default `wildcard-letsencrypt-prod`) - name of the cert manager Issuer to use
  - `annotations` (Optional, default null) - key/value map of annotations to customize the Ingress (do path prefix routing, etc.). Ask Platform before configuring this.

Example configuration with one public-facing application application and one in-cluster application:

```yaml
deploy_version: 0.1.5

applications:
  - name: basics
    image: pennlabs/pennbasics
    secret: basics
    ingress:
      hosts:
        - host: pennbasics.com
          paths: ["/"]
  - name: redis
    tag: latest
    port: 6379
    image: redis
```

## Accessing applications in-cluster

If you want one application to access another solely inside the cluster, you can reference it with it's "App ID". Icarus creates app IDs of the form `<repo_name>-<app_name>`. For example, if you wanted to access the redis in the above example in the `pennbasics` repository, you would access it with the url `pennbasics-redis:6379`.
