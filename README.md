# Icarus

Icarus is the base helm chart for deployments for Penn Labs. This chart provides sane defaults for creating ingresses, services, and deployments.

## Configuration

The only global configuration option is `image_tag`. This can be used to set all your images to the same tag. You can optionally override the global setting by setting the `tag` attribute for any of your applications.

For configuring each application, put them under the `applications` section, providing any configuration you wish to override from the `defaults` item in `values.yaml`. Here is an example service that has one public-facing application and one internal one:

```yaml
deploy_version: 0.1.0
image_tag: latest

applications:
  - name: basics
    image: pennlabs/pennbasics
    secret: basics
    ingress:
      hosts:
        - host: pennbasics.com
          paths: ["/"]
  - name: 2048
    image: alexwhen/docker-2048
```
